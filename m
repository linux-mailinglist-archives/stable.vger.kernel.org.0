Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162E1498B9C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344205AbiAXTPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:15:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39938 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346286AbiAXTMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:12:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7C3F612DE;
        Mon, 24 Jan 2022 19:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D79C340E5;
        Mon, 24 Jan 2022 19:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051552;
        bh=2pDpaWx5MhnyIcZv45hliHuSeHM25XYVHYfE71ZrZbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/KWYyGrACCQQZ8Q8INgQyOle8pjMkHEBRnRMXGZRI+d8I/zCptItjqLbbrPRW6bO
         lpQIpvJc19sQj0IbHFZ112tDKwxocro9WMrkoCjnAXGPICjzQsgV6ufxgAQJznEjUU
         8mcPDGPvhFmKyrVh3O0RSop8XBGHEi3UVxYBjaS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?D=C3=A1vid=20Bolvansk=C3=BD?= <david.bolvansky@gmail.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH 4.19 012/239] drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()
Date:   Mon, 24 Jan 2022 19:40:50 +0100
Message-Id: <20220124183943.505209038@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
@@ -3002,9 +3002,9 @@ static void snb_wm_latency_quirk(struct
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


