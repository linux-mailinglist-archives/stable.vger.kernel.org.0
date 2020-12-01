Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564B32C9B27
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgLAJF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388832AbgLAJEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:04:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1889621D7A;
        Tue,  1 Dec 2020 09:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813445;
        bh=qW4Okc9SGp3n6wIi4MXS+Qo7u7tQ+3l4AEIGC1RCLa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjuOX2QmsN1jOfAQMyOcDBtokw4j2znMGScprXTD2ZHcdG91eRH6tes3xycXXYl4y
         3YBUgTljLG+J2E7emZp3Lfu6xLARFP6xMdqgy02VED0RIf+uXyOEN0VpVjNHvUHU0V
         oNxxaijFSduzb24lrXXSpZ2ioJP3w2gYFwBPIpkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/98] bus: ti-sysc: Fix bogus resetdone warning on enable for cpsw
Date:   Tue,  1 Dec 2020 09:53:19 +0100
Message-Id: <20201201084657.167879966@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e7ae08d398e094e1305dee823435b1f996d39106 ]

Bail out early from sysc_wait_softreset() just like we do in sysc_reset()
if there's no sysstatus srst_shift to fix a bogus resetdone warning on
enable as suggested by Grygorii Strashko <grygorii.strashko@ti.com>.

We do not currently handle resets for modules that need writing to the
sysstatus register. If we at some point add that, we also need to add
SYSS_QUIRK_RESETDONE_INVERTED flag for cpsw as the sysstatus bit is low
when reset is done as described in the am335x TRM "Table 14-202
SOFT_RESET Register Field Descriptions"

Fixes: d46f9fbec719 ("bus: ti-sysc: Use optional clocks on for enable and wait for softreset bit")
Suggested-by: Grygorii Strashko <grygorii.strashko@ti.com>
Acked-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 770a780dfa544..3934ce3385ac3 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -192,6 +192,9 @@ static int sysc_wait_softreset(struct sysc *ddata)
 	u32 sysc_mask, syss_done, rstval;
 	int syss_offset, error = 0;
 
+	if (ddata->cap->regbits->srst_shift < 0)
+		return 0;
+
 	syss_offset = ddata->offsets[SYSC_SYSSTATUS];
 	sysc_mask = BIT(ddata->cap->regbits->srst_shift);
 
-- 
2.27.0



