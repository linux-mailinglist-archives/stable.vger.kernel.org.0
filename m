Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C2464A1B5
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiLLNoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiLLNnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:43:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC481146A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:43:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA411B80D4F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A78C433EF;
        Mon, 12 Dec 2022 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852610;
        bh=yEA6rcNxNTAVkTyx9+68yURhJy0yQuRFWbb7JyLy7Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDR/0W7RxSoKM/oVJXHXlpGlYJ7DM0zwb6JLX/f4ESEyEN7TqwZY/8kcibTBjfnTE
         +kUpVbPgZ/NPh4uuBk3hXduSIJInTrh87Mzs8pZpLYKvgXjQmD9e2KJJcdkoeBoH3H
         eRQUWRw/tCMK+CZSMTbKRemCKBYuMMRVtr+GXT1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dawei Li <set_pte_at@outlook.com>,
        Martin Krastev <krastevm@vmware.com>,
        Zack Rusin <zackr@vmware.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 090/157] drm/vmwgfx: Fix race issue calling pin_user_pages
Date:   Mon, 12 Dec 2022 14:17:18 +0100
Message-Id: <20221212130938.428356589@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dawei Li <set_pte_at@outlook.com>

[ Upstream commit ed14d225cc7c842f6d4d5a3009f71a44f5852d09 ]

pin_user_pages() is unsafe without protection of mmap_lock,
fix it by calling pin_user_pages_fast().

Fixes: 7a7a933edd6c ("drm/vmwgfx: Introduce VMware mks-guest-stats")
Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Signed-off-by: Zack Rusin <zackr@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/TYWP286MB23193621CB443E1E1959A00BCA3E9@TYWP286MB2319.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
index 089046fa21be..50fa3df0bc0c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_msg.c
@@ -1085,21 +1085,21 @@ int vmw_mksstat_add_ioctl(struct drm_device *dev, void *data,
 	reset_ppn_array(pdesc->strsPPNs, ARRAY_SIZE(pdesc->strsPPNs));
 
 	/* Pin mksGuestStat user pages and store those in the instance descriptor */
-	nr_pinned_stat = pin_user_pages(arg->stat, num_pages_stat, FOLL_LONGTERM, pages_stat, NULL);
+	nr_pinned_stat = pin_user_pages_fast(arg->stat, num_pages_stat, FOLL_LONGTERM, pages_stat);
 	if (num_pages_stat != nr_pinned_stat)
 		goto err_pin_stat;
 
 	for (i = 0; i < num_pages_stat; ++i)
 		pdesc->statPPNs[i] = page_to_pfn(pages_stat[i]);
 
-	nr_pinned_info = pin_user_pages(arg->info, num_pages_info, FOLL_LONGTERM, pages_info, NULL);
+	nr_pinned_info = pin_user_pages_fast(arg->info, num_pages_info, FOLL_LONGTERM, pages_info);
 	if (num_pages_info != nr_pinned_info)
 		goto err_pin_info;
 
 	for (i = 0; i < num_pages_info; ++i)
 		pdesc->infoPPNs[i] = page_to_pfn(pages_info[i]);
 
-	nr_pinned_strs = pin_user_pages(arg->strs, num_pages_strs, FOLL_LONGTERM, pages_strs, NULL);
+	nr_pinned_strs = pin_user_pages_fast(arg->strs, num_pages_strs, FOLL_LONGTERM, pages_strs);
 	if (num_pages_strs != nr_pinned_strs)
 		goto err_pin_strs;
 
-- 
2.35.1



