Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F0D6DEF06
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjDLIq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjDLIqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989AE83F0
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34EA363093
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4224DC433D2;
        Wed, 12 Apr 2023 08:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289189;
        bh=YWyD+qEB/dXKPhzA0Ydochg7X9UnwWMvHIbeeWJylg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQiZAMzNw31dtvsFLrd2bGgSKOA0cfeLy6oLsuqjyGVB29EmBo75NsGEYPhzSGYAC
         MMiSoECpq+hF35XaEN4sThxRTgTfVaCqJUxDGt6f6JXeDFvonEmR6hVjZUKUJ1cLXd
         kJFClZdqjyUMyerShXBajxGEAkQSx6qPktpOTtr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Subject: [PATCH 6.1 149/164] drm/i915: Use _MMIO_PIPE() for SKL_BOTTOM_COLOR
Date:   Wed, 12 Apr 2023 10:34:31 +0200
Message-Id: <20230412082842.938632535@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 05ca98523481aa687c5a8dce8939fec539632153 upstream.

No need to use _MMIO_PIPE2() for SKL_BOTTOM_COLOR
since all pipe registers are evenly spread on skl+.
Switch to _MMIO_PIPE() and thus avoid the hidden dev_priv.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026113906.10551-3-ville.syrjala@linux.intel.com
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_reg.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3747,9 +3747,10 @@
 
 /* Skylake+ pipe bottom (background) color */
 #define _SKL_BOTTOM_COLOR_A		0x70034
+#define _SKL_BOTTOM_COLOR_B		0x71034
 #define   SKL_BOTTOM_COLOR_GAMMA_ENABLE		REG_BIT(31)
 #define   SKL_BOTTOM_COLOR_CSC_ENABLE		REG_BIT(30)
-#define SKL_BOTTOM_COLOR(pipe)		_MMIO_PIPE2(pipe, _SKL_BOTTOM_COLOR_A)
+#define SKL_BOTTOM_COLOR(pipe)		_MMIO_PIPE(pipe, _SKL_BOTTOM_COLOR_A, _SKL_BOTTOM_COLOR_B)
 
 #define _ICL_PIPE_A_STATUS			0x70058
 #define ICL_PIPESTATUS(pipe)			_MMIO_PIPE2(pipe, _ICL_PIPE_A_STATUS)


