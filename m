Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0973781CC0
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbfHENZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:25:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730916AbfHENZu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:25:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DD6A20644;
        Mon,  5 Aug 2019 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011549;
        bh=O81cY2+UO09peQGoXM9mbiGl/Zz6yhVdTmLOCrqsWy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvae2LmQHCdKoqDEewTy59ddlu9mEgPkwaNIgRvG9OUvtD7739cV5Hhbx+0wa6FS7
         1F3lcmJ3iFAsb05L7nigE5YRiqtqLh722hzn4AIgU+vYmiqY4Lfmper1J498ESiaRT
         XlN5dWfXgK+r/ywWOP3F4vuJKH2AM5X6DFjpUAJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.2 130/131] drm/i915/perf: fix ICL perf register offsets
Date:   Mon,  5 Aug 2019 15:03:37 +0200
Message-Id: <20190805125000.682940232@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lionel Landwerlin <lionel.g.landwerlin@intel.com>

commit 95eef14cdad150fed43147bcd4f29eea3d0a3f03 upstream.

We got the wrong offsets (could they have changed?). New values were
computed off an error state by looking up the register offset in the
context image as written by the HW.

Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Fixes: 1de401c08fa805 ("drm/i915/perf: enable perf support on ICL")
Cc: <stable@vger.kernel.org> # v4.18+
Acked-by: Kenneth Graunke <kenneth@whitecape.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190610081914.25428-1-lionel.g.landwerlin@intel.com
(cherry picked from commit 8dcfdfb4501012a8d36d2157dc73925715f2befb)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_perf.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -3457,9 +3457,13 @@ void i915_perf_init(struct drm_i915_priv
 			dev_priv->perf.oa.ops.enable_metric_set = gen8_enable_metric_set;
 			dev_priv->perf.oa.ops.disable_metric_set = gen10_disable_metric_set;
 
-			dev_priv->perf.oa.ctx_oactxctrl_offset = 0x128;
-			dev_priv->perf.oa.ctx_flexeu0_offset = 0x3de;
-
+			if (IS_GEN(dev_priv, 10)) {
+				dev_priv->perf.oa.ctx_oactxctrl_offset = 0x128;
+				dev_priv->perf.oa.ctx_flexeu0_offset = 0x3de;
+			} else {
+				dev_priv->perf.oa.ctx_oactxctrl_offset = 0x124;
+				dev_priv->perf.oa.ctx_flexeu0_offset = 0x78e;
+			}
 			dev_priv->perf.oa.gen8_valid_ctx_bit = (1<<16);
 		}
 	}


