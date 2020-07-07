Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F6E217019
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgGGPOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728757AbgGGPOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A81E20674;
        Tue,  7 Jul 2020 15:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134887;
        bh=lSfh8vrWqPNATRwT9slBYWsJgUPknOms0F44TCpkAEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzApgtuWkxuzLFqHLcY1hcdCxlek0QTdKEnNolqFuEoh8zCSkybCMfXoLJv2uPIaJ
         vWV+5kbQIeDX0bwYUSWbPiMqEesaLCsOEa+DIqSUdAJYeS3Y6ypEiaF8/0JiaQb1Dt
         v+XBT3f6JskO+/0K6/GF6ojmEpB4jmIHUk8LQY5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Andersson <pipatron@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/24] EDAC/amd64: Read back the scrub rate PCI register on F15h
Date:   Tue,  7 Jul 2020 17:13:37 +0200
Message-Id: <20200707145749.212029983@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
References: <20200707145748.952502272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit ee470bb25d0dcdf126f586ec0ae6dca66cb340a4 ]

Commit:

  da92110dfdfa ("EDAC, amd64_edac: Extend scrub rate support to F15hM60h")

added support for F15h, model 0x60 CPUs but in doing so, missed to read
back SCRCTRL PCI config register on F15h CPUs which are *not* model
0x60. Add that read so that doing

  $ cat /sys/devices/system/edac/mc/mc0/sdram_scrub_rate

can show the previously set DRAM scrub rate.

Fixes: da92110dfdfa ("EDAC, amd64_edac: Extend scrub rate support to F15hM60h")
Reported-by: Anders Andersson <pipatron@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> #v4.4..
Link: https://lkml.kernel.org/r/CAKkunMbNWppx_i6xSdDHLseA2QQmGJqj_crY=NF-GZML5np4Vw@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 1c5f23224b3cb..020dd07d1c23a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -243,6 +243,8 @@ static int get_scrub_rate(struct mem_ctl_info *mci)
 
 		if (pvt->model == 0x60)
 			amd64_read_pci_cfg(pvt->F2, F15H_M60H_SCRCTRL, &scrubval);
+		else
+			amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
 	} else
 		amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
 
-- 
2.25.1



