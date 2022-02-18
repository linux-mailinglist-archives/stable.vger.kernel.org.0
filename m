Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481254BB519
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 10:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiBRJOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 04:14:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiBRJOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 04:14:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8A328BF62
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 01:14:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88E42618A0
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 09:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3326EC340E9;
        Fri, 18 Feb 2022 09:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645175659;
        bh=Y7peoJ8snUn8TE6JeLsAAeNsXrKOKn21WDq7h5mF+bU=;
        h=Subject:To:Cc:From:Date:From;
        b=kc4utBS0xWgK4/Gpfdq24xIspdMXbScjux7H6MXgrvLptIEfNdsT0VJp0V/S4Hmud
         RR/o+5sB/dcS1V32qgQ3ZqaKKOVrFNvCu4IX4LeWQEbK55kRMpkPjs8hwjexuC65LA
         S7cU7T0TrCGmHr5jGv+afiPyxcOtHLhdx4l+CqCk=
Subject: FAILED: patch "[PATCH] drm/i915: Fix dbuf slice config lookup" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 18 Feb 2022 10:14:15 +0100
Message-ID: <1645175655146186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 698bef8ff5d2edea5d1c9d6e5adf1bfed1e8a106 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Mon, 7 Feb 2022 15:26:59 +0200
Subject: [PATCH] drm/i915: Fix dbuf slice config lookup
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 3edba7fd0c49..da6ce24a42b2 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4870,7 +4870,7 @@ static u8 compute_dbuf_slices(enum pipe pipe, u8 active_pipes, bool join_mbus,
 {
 	int i;
 
-	for (i = 0; i < dbuf_slices[i].active_pipes; i++) {
+	for (i = 0; dbuf_slices[i].active_pipes != 0; i++) {
 		if (dbuf_slices[i].active_pipes == active_pipes &&
 		    dbuf_slices[i].join_mbus == join_mbus)
 			return dbuf_slices[i].dbuf_mask[pipe];

