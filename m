Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3BB4ABC2E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384939AbiBGLaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384086AbiBGLYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:24:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA3AC043181;
        Mon,  7 Feb 2022 03:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 290E7B81028;
        Mon,  7 Feb 2022 11:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52033C004E1;
        Mon,  7 Feb 2022 11:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233079;
        bh=KA0v6uzmrpCq8CZngEmIzixkjPkWni2L1J8EWKJLKg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aygwEb0CYYhKshccfKdNiK32+hxkZCKTEm+rUhreEzTrl8LE4S7c8qDzrYa1tyQT6
         5dHwo09gmohfI+/JMtA/mTXNbneUHeYAmt7keorf7Mtbl8KdvdVFc7QmKsGaYf3kMt
         I4+DPf2W5U6NfFqNHFvt6AGeSowi75xjQ4iCP9ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Mario Kleiner <mario.kleiner.de@gmail.com>
Subject: [PATCH 5.15 001/110] drm/i915: Disable DSB usage for now
Date:   Mon,  7 Feb 2022 12:05:34 +0100
Message-Id: <20220207103802.334366967@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

commit 99510e1afb4863a225207146bd988064c5fd0629 upstream.

Turns out the DSB has trouble correctly loading the gamma LUT.
>From a cursory look maybe like some entries do not load
properly, or they get loaded with some gibberish. Unfortunately
our current kms_color/etc. tests do not seem to catch this.

I had a brief look at the generated DSB batch and it looked
correct. Tried a few quick tricks like writing the index
register twice/etc. but didn't see any improvement.
Also tried switching to the 10bit gamma mode in case
there is yet another issue with the multi-segment mode, but
even the 10bit mode was showing issues.

Switching to mmio fixes all of it. I suppose one theory is that
maybe the DSB bangs on the LUT too quickly and it can't keep up
and instead some data either gets dropped or corrupted. To confirm
that someone should try to slow down the DSB's progress a bit.
Another thought was that maybe the LUT has crappy dual porting
and you get contention if you try to load it during active
scanout. But why then would the mmio path work, unless it's
just sufficiently slow?

Whatever the case, this is currently busted so let's disable
it until we get to the root of the problem.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3916
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211014181856.17581-2-ville.syrjala@linux.intel.com
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Cc: Mario Kleiner <mario.kleiner.de@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -865,7 +865,7 @@ static const struct intel_device_info js
 	}, \
 	TGL_CURSOR_OFFSETS, \
 	.has_global_mocs = 1, \
-	.display.has_dsb = 1
+	.display.has_dsb = 0 /* FIXME: LUT load is broken with DSB */
 
 static const struct intel_device_info tgl_info = {
 	GEN12_FEATURES,


