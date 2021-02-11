Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5BA318E01
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhBKPT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:19:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D83E64EF6;
        Thu, 11 Feb 2021 15:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055890;
        bh=tgG5ZuzJMSSY7xXkHOE2YZTZXgxpiFihf6Aiob7jUp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEbSjnI+kaZklhLbd6CVL71mEXXufU7mgnhZsxDPKDl0QQlvZ8EvobTYKVt+wo/Q7
         bdGrVduZPL0sIRqBRVuqRy0xjr9DCRRj8bzH2HL1h7ywd7cn0pb2iS7Dv3GMdcugNX
         L4QKxAu5V/0zb8mUbEazHtgjbRnO/9SgUXI0/gvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Imre Deak <imre.deak@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 48/54] drm/i915: Skip vswing programming for TBT
Date:   Thu, 11 Feb 2021 16:02:32 +0100
Message-Id: <20210211150154.962908516@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit eaf5bfe37db871031232d2bf2535b6ca92afbad8 upstream.

In thunderbolt mode the PHY is owned by the thunderbolt controller.
We are not supposed to touch it. So skip the vswing programming
as well (we already skipped the other steps not applicable to TBT).

Touching this stuff could supposedly interfere with the PHY
programming done by the thunderbolt controller.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210128155948.13678-1-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit f8c6b615b921d8a1bcd74870f9105e62b0bceff3)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |    6 ++++++
 1 file changed, 6 insertions(+)


--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -2597,6 +2597,9 @@ static void icl_mg_phy_ddi_vswing_sequen
 	u32 n_entries, val;
 	int ln, rate = 0;
 
+	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
+		return;
+
 	if (type != INTEL_OUTPUT_HDMI) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 
@@ -2741,6 +2744,9 @@ tgl_dkl_phy_ddi_vswing_sequence(struct i
 	u32 n_entries, val, ln, dpcnt_mask, dpcnt_val;
 	int rate = 0;
 
+	if (enc_to_dig_port(encoder)->tc_mode == TC_PORT_TBT_ALT)
+		return;
+
 	if (type != INTEL_OUTPUT_HDMI) {
 		struct intel_dp *intel_dp = enc_to_intel_dp(encoder);
 


