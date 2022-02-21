Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0460E4BE197
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351686AbiBUJuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352593AbiBUJrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1595842EF4;
        Mon, 21 Feb 2022 01:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A05B260EB3;
        Mon, 21 Feb 2022 09:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE5BC340EC;
        Mon, 21 Feb 2022 09:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435210;
        bh=MCHtTJpifQkGD42L/6e6W90C2fxMXP0SRmYINnpTOuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ly51+vqmFARuLaz0v2jxV8/hwi3ZymoLjez+TDAdhOo95xDJnQgQ5gq5i2QSg2Gw7
         nmbut2GZfRhysJ6nPL9PFiFrOaKn0yUu3rBCsQWu3X50jc3OeBrSobK/VNojU3Gwwo
         swcl1xmtzue89XkRvs+Sn5a8G2l2UDsS4ft5V3Po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.16 084/227] drm/i915: Fix dbuf slice config lookup
Date:   Mon, 21 Feb 2022 09:48:23 +0100
Message-Id: <20220221084937.660836840@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 698bef8ff5d2edea5d1c9d6e5adf1bfed1e8a106 upstream.

Apparently I totally fumbled the loop condition when I
removed the ARRAY_SIZE() stuff from the dbuf slice config
lookup. Comparing the loop index with the active_pipes bitmask
is utter nonsense, what we want to do is check to see if the
mask is zero or not.

Note that the code actually ended up working correctly despite
the fumble, up until commit eef173954432 ("drm/i915: Allow
!join_mbus cases for adlp+ dbuf configuration") when things
broke for real.

Cc: stable@vger.kernel.org
Fixes: 05e8155afe35 ("drm/i915: Use a sentinel to terminate the dbuf slice arrays")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220207132700.481-1-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit a28fde308c3c1c174249ff9559b57f24e6850086)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4860,7 +4860,7 @@ static u8 compute_dbuf_slices(enum pipe
 {
 	int i;
 
-	for (i = 0; i < dbuf_slices[i].active_pipes; i++) {
+	for (i = 0; dbuf_slices[i].active_pipes != 0; i++) {
 		if (dbuf_slices[i].active_pipes == active_pipes &&
 		    dbuf_slices[i].join_mbus == join_mbus)
 			return dbuf_slices[i].dbuf_mask[pipe];


