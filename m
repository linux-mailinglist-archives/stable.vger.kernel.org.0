Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EAC4625F6
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhK2Wpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbhK2WpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:45:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF99C12BCEC;
        Mon, 29 Nov 2021 10:34:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 781E3B81600;
        Mon, 29 Nov 2021 18:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F89C53FC7;
        Mon, 29 Nov 2021 18:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210893;
        bh=xUvMoZYGmuBBzRmrjq/69Y1IajOE2r/HRPwucOx7NN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rp5733hdUwbFV5P+6c+K7T7m5UCJXbwqznC1tlQ+FdjZHdoha07ZTiazPpuW8uO3f
         NvXG9yHvNvzaqvowI0PBDdfwxGLtR0cTxpWnQyQknLN3voMLs7LublTk3tDWuHt7sh
         sTkABHcrDqdvNgO3eBXC7csRcWOdykHCJ0FJoGsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Zameer Manji <zmanji@gmail.com>
Subject: [PATCH 5.15 032/179] staging: r8188eu: Fix breakage introduced when 5G code was removed
Date:   Mon, 29 Nov 2021 19:17:06 +0100
Message-Id: <20211129181720.006303705@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit d5f0b804368951b6b4a77d2f14b5bb6a04b0e011 upstream.

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
 drivers/staging/r8188eu/core/rtw_mlme_ext.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/r8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/r8188eu/core/rtw_mlme_ext.c
@@ -104,6 +104,7 @@ static struct rt_channel_plan_map	RTW_Ch
 	{0x01},	/* 0x10, RT_CHANNEL_DOMAIN_JAPAN */
 	{0x02},	/* 0x11, RT_CHANNEL_DOMAIN_FCC_NO_DFS */
 	{0x01},	/* 0x12, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
+	{0x00}, /* 0x13 */
 	{0x02},	/* 0x14, RT_CHANNEL_DOMAIN_TAIWAN_NO_DFS */
 	{0x00},	/* 0x15, RT_CHANNEL_DOMAIN_ETSI_NO_DFS */
 	{0x00},	/* 0x16, RT_CHANNEL_DOMAIN_KOREA_NO_DFS */
@@ -115,6 +116,7 @@ static struct rt_channel_plan_map	RTW_Ch
 	{0x00},	/* 0x1C, */
 	{0x00},	/* 0x1D, */
 	{0x00},	/* 0x1E, */
+	{0x00},	/* 0x1F, */
 	/*  0x20 ~ 0x7F , New Define ===== */
 	{0x00},	/* 0x20, RT_CHANNEL_DOMAIN_WORLD_NULL */
 	{0x01},	/* 0x21, RT_CHANNEL_DOMAIN_ETSI1_NULL */


