Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8507548E5E9
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbiANIWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:22:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32852 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239894AbiANIVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:21:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2C93B82444;
        Fri, 14 Jan 2022 08:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BEDC36AEA;
        Fri, 14 Jan 2022 08:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148461;
        bh=oKUB4z0s4Ss2VDDaUjB+aK/qDUsfpB+nGHt5h1CkT84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXOxwQpAQyD4DYT6vqCnkcqZ2j3Nt48lRpUvmWffbuY7HKok1eq9XqhGodiQk48wq
         3oxxPAnGKlzC3+zbtu4B3NnOW282LbbjKqdQgzDDCJm8VjSfRSAWdpwgNuLx6HmA+p
         BJ1PaRHQwQ8zmlv2gdpr8YxXYvu6VqRw5QhtBiGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?D=C3=A1vid=20Bolvansk=C3=BD?= <david.bolvansky@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 5.15 40/41] drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()
Date:   Fri, 14 Jan 2022 09:16:40 +0100
Message-Id: <20220114081546.506413579@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 2e70570656adfe1c5d9a29940faa348d5f132199 upstream.

A new warning in clang points out a place in this file where a bitwise
OR is being used with boolean types:

drivers/gpu/drm/i915/intel_pm.c:3066:12: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
        changed = ilk_increase_wm_latency(dev_priv, dev_priv->wm.pri_latency, 12) |
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This construct is intentional, as it allows every one of the calls to
ilk_increase_wm_latency() to occur (instead of short circuiting with
logical OR) while still caring about the result of each call.

To make this clearer to the compiler, use the '|=' operator to assign
the result of each ilk_increase_wm_latency() call to changed, which
keeps the meaning of the code the same but makes it obvious that every
one of these calls is expected to happen.

Link: https://github.com/ClangBuiltLinux/linux/issues/1473
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Dávid Bolvanský <david.bolvansky@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211014211916.3550122-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3063,9 +3063,9 @@ static void snb_wm_latency_quirk(struct
 	 * The BIOS provided WM memory latency values are often
 	 * inadequate for high resolution displays. Adjust them.
 	 */
-	changed = ilk_increase_wm_latency(dev_priv, dev_priv->wm.pri_latency, 12) |
-		ilk_increase_wm_latency(dev_priv, dev_priv->wm.spr_latency, 12) |
-		ilk_increase_wm_latency(dev_priv, dev_priv->wm.cur_latency, 12);
+	changed = ilk_increase_wm_latency(dev_priv, dev_priv->wm.pri_latency, 12);
+	changed |= ilk_increase_wm_latency(dev_priv, dev_priv->wm.spr_latency, 12);
+	changed |= ilk_increase_wm_latency(dev_priv, dev_priv->wm.cur_latency, 12);
 
 	if (!changed)
 		return;


