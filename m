Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F499441843
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhKAJp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233992AbhKAJnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:43:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BECD4613A3;
        Mon,  1 Nov 2021 09:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758938;
        bh=zDx+N3cq3WeFQo5p1KFkudxQYPfci7eZ44WG7gflmlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQeBW7zcsrELYPIKrP2IF38lFcDeNMF6+PZEIH7P71KyRuWNRABSl9BATJHMx0/vJ
         hfeqzjjR8rHWYLXKusTwLVE5pn82BlSuGaK7Vix/Oo2ny+7VLyDgs06yW7Af6OtKNA
         W4rFsBOIR59Pqq8MWYAF0ck0K32mVD76G9RGJaX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mat Jonczyk <mat.jonczyk@o2.pl>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>
Subject: [PATCH 5.14 046/125] drm/i915/dp: Skip the HW readout of DPCD on disabled encoders
Date:   Mon,  1 Nov 2021 10:16:59 +0100
Message-Id: <20211101082541.907535250@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit 6e6f96630805874fa80b0067e1a57aafc06225f6 upstream.

Reading out the DP encoders' DPCD during booting or resume is only
required for enabled encoders: such encoders may be modesetted during
the initial commit and the link training this involves depends on an
initialized DPCD. For DDI encoders reading out the DPCD is skipped, do
the same on pre-DDI platforms.

Atm, the first DPCD readout without a sink connected - which is a likely
scneario if the encoder is disabled - leaves intel_dp->num_common_rates
at 0, which resulted in

intel_dp_sync_state()->intel_dp_max_common_rate()

in a

intel_dp->common_rates[-1]

access. This by definition results in an undefined behaviour, though to
my best knowledge in all HW/compiler configurations it actually results
in accessing the array item type value preceding the array. In this
case the preceding value happens to be intel_dp->num_common_rates,
which is 0, so this issue - by luck - didn't cause a user visible
problem.

Nevertheless it's still an undefined behaviour and in CONFIG_UBSAN
builds leads to a kernel BUG() (which revealed this problem for us),
hence CC:stable.

A related problem in case the encoder is enabled but the sink is not
connected or the DPCD readout fails is fixed by the next patch.

v2: Amend the commit message describing the root cause of the
    CONFIG_UBSAN BUG().

Fixes: a532cde31de3 ("drm/i915/tc: Fix TypeC port init/resume time sanitization")
Reported-and-tested-by: Mat Jonczyk <mat.jonczyk@o2.pl>
Cc: Mat Jonczyk <mat.jonczyk@o2.pl>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211018094154.1407705-2-imre.deak@intel.com
(cherry picked from commit 4ec5ffc341cecbea060739aea1d53398ac2ec3f8)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1924,6 +1924,9 @@ void intel_dp_sync_state(struct intel_en
 {
 	struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
+	if (!crtc_state)
+		return;
+
 	/*
 	 * Don't clobber DPCD if it's been already read out during output
 	 * setup (eDP) or detect.


