Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E7A25943E
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgIAPhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731287AbgIAPhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:37:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAAA620E65;
        Tue,  1 Sep 2020 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974632;
        bh=cLkCh0TQ3r1z5Bof6eBuZFAV4BBLrF+5jl34LRuXq4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o1IG8XRpAYxW5xG1q73L2Wpi8WAqTb9asQqCXBOUVPbz2tiyysuMy0xc/CsEBZaNn
         OVvTSWydoeIhW8t5YRl6ek2fP8D1nMvQM/oNzr8cDR9ZyM7DLug1MLgUdwHXi5XTTr
         OGv97K85aM+6wKod3Qrh6wx01hU5cK9wlsBWV8Rg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 018/255] staging: rts5208: fix memleaks on error handling paths in probe
Date:   Tue,  1 Sep 2020 17:07:54 +0200
Message-Id: <20200901151001.652486270@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 11507bf9a8832741db69efd32bf09a2ab26426bf ]

rtsx_probe() allocates host, but does not free it on error handling
paths. The patch adds missed scsi_host_put().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Link: https://lore.kernel.org/r/20200623141230.7258-1-novikov@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rts5208/rtsx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index be0053c795b7a..937f4e732a75c 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -972,6 +972,7 @@ ioremap_fail:
 	kfree(dev->chip);
 chip_alloc_fail:
 	dev_err(&pci->dev, "%s failed\n", __func__);
+	scsi_host_put(host);
 scsi_host_alloc_fail:
 	pci_release_regions(pci);
 	return err;
-- 
2.25.1



