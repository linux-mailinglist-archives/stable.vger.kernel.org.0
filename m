Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A34534CA0F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhC2Iep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234737AbhC2Ide (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EDD461613;
        Mon, 29 Mar 2021 08:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006799;
        bh=IJqCyNackXpL528wu5sFIUdHxJsAEA0WXvHutPPDykw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kf5rov0M0tHKw/M5LMRhezQ6JWuvOTc93L4uj1IZjUsOyHxyk6yWHEYdvSLMDfuHF
         JaJV0JqIn+DGuVoXjSXIZKAMzpHCBMtO460C7kIrJFeTlQ+2o+IJ/X4H0nA8ukInt6
         8cznE8vSjzyZdDao1VICE5qb9FUZMdlqOeB6sQS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manasi Navare <manasi.d.navare@intel.com>,
        Animesh Manna <animesh.manna@intel.com>,
        Vandita Kulkarni <vandita.kulkarni@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.11 101/254] drm/i915/dsc: fix DSS CTL register usage for ICL DSI transcoders
Date:   Mon, 29 Mar 2021 09:56:57 +0200
Message-Id: <20210329075636.524516879@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

commit b61fde1beb6b1847f1743e75f4d9839acebad76a upstream.

Use the correct DSS CTL registers for ICL DSI transcoders.

As a side effect, this also brings back the sanity check for trying to
use pipe DSC registers on pipe A on ICL.

Fixes: 8a029c113b17 ("drm/i915/dp: Modify VDSC helpers to configure DSC for Bigjoiner slave")
Cc: Manasi Navare <manasi.d.navare@intel.com>
Cc: Animesh Manna <animesh.manna@intel.com>
Cc: Vandita Kulkarni <vandita.kulkarni@intel.com>
Cc: <stable@vger.kernel.org> # v5.11+
Reviewed-by: Manasi Navare <manasi.d.navare@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210319115333.8330-1-jani.nikula@intel.com
(cherry picked from commit 5706d02871240fdba7ddd6ab1cc31672fc95a90f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vdsc.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_vdsc.c
+++ b/drivers/gpu/drm/i915/display/intel_vdsc.c
@@ -1016,20 +1016,14 @@ static i915_reg_t dss_ctl1_reg(const str
 {
 	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
 
-	if (crtc_state->cpu_transcoder == TRANSCODER_EDP)
-		return DSS_CTL1;
-
-	return ICL_PIPE_DSS_CTL1(pipe);
+	return is_pipe_dsc(crtc_state) ? ICL_PIPE_DSS_CTL1(pipe) : DSS_CTL1;
 }
 
 static i915_reg_t dss_ctl2_reg(const struct intel_crtc_state *crtc_state)
 {
 	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
 
-	if (crtc_state->cpu_transcoder == TRANSCODER_EDP)
-		return DSS_CTL2;
-
-	return ICL_PIPE_DSS_CTL2(pipe);
+	return is_pipe_dsc(crtc_state) ? ICL_PIPE_DSS_CTL2(pipe) : DSS_CTL2;
 }
 
 void intel_dsc_enable(struct intel_encoder *encoder,


