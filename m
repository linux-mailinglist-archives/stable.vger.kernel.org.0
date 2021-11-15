Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58ED450139
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 10:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbhKOJ1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 04:27:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237018AbhKOJ1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 04:27:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D2C461B95;
        Mon, 15 Nov 2021 09:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636968231;
        bh=ZFAYqNw0ZWrNygPU9IRInHt0T4/GKpAFS5lPC4qcNAY=;
        h=Subject:To:From:Date:From;
        b=spn0YwUFPGs8alsXxKCGW1EZx2mMDyJn1tXuKsj95r5MCCAx0nMLM/Qw1MjzoJNv7
         bZ3EDCRmwuU3vlIRPOSOjrGpP7bMssqjaaUMMXri2jFedfqqX6JuIaeFY9Xi8h1SHC
         2uD+LNtQhy/e+k3OeU2tr7e0AMKzNt8ECDZxDkII=
Subject: patch "staging: r8188eu: Fix breakage introduced when 5G code was removed" added to staging-linus
To:     Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        lkp@intel.com, phil@philpotter.co.uk, stable@vger.kernel.org,
        zmanji@gmail.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 10:23:49 +0100
Message-ID: <1636968229150235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: r8188eu: Fix breakage introduced when 5G code was removed

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d5f0b804368951b6b4a77d2f14b5bb6a04b0e011 Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 7 Nov 2021 11:35:43 -0600
Subject: staging: r8188eu: Fix breakage introduced when 5G code was removed

In commit 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions
and code"), two entries were removed from RTW_ChannelPlanMap[], but not replaced
with zeros. The position within this table is important, thus the patch broke
systems operating in regulatory domains osted later than entry 0x13 in the table.
Unfortunately, the FCC entry comes before that point and most testers did not see
this problem.

Fixes: 221abd4d478a ("staging: r8188eu: Remove no more necessary definitions and code")
Cc: Stable <stable@vger.kernel.org> # v5.5+
Reported-and-tested-by: Zameer Manji <zmanji@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Link: https://lore.kernel.org/r/20211107173543.7486-1-Larry.Finger@lwfinger.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/r8188eu/core/rtw_mlme_ext.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/r8188eu/core/rtw_mlme_ext.c b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
index 55c3d4a6faeb..5b60e6df5f87 100644
--- a/drivers/staging/r8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
@@ -107,6 +107,7 @@ static struct rt_channel_plan_map	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
 	{0x01},	/* 0x10, RT_CHANNEL_DOMAIN_JAPAN */
 	{0x02},	/* 0x11, RT_CHANNEL_DOMAIN_FCC_NO_DFS */
 	{0x01},	/* 0x12, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
+	{0x00}, /* 0x13 */
 	{0x02},	/* 0x14, RT_CHANNEL_DOMAIN_TAIWAN_NO_DFS */
 	{0x00},	/* 0x15, RT_CHANNEL_DOMAIN_ETSI_NO_DFS */
 	{0x00},	/* 0x16, RT_CHANNEL_DOMAIN_KOREA_NO_DFS */
@@ -118,6 +119,7 @@ static struct rt_channel_plan_map	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
 	{0x00},	/* 0x1C, */
 	{0x00},	/* 0x1D, */
 	{0x00},	/* 0x1E, */
+	{0x00},	/* 0x1F, */
 	/*  0x20 ~ 0x7F , New Define ===== */
 	{0x00},	/* 0x20, RT_CHANNEL_DOMAIN_WORLD_NULL */
 	{0x01},	/* 0x21, RT_CHANNEL_DOMAIN_ETSI1_NULL */
-- 
2.33.1


