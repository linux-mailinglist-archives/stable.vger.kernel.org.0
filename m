Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A634C86A47
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404766AbfHHTH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404389AbfHHTHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F6142173E;
        Thu,  8 Aug 2019 19:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291274;
        bh=sC+HEfa11I6BN7a/9w7edfoxIeYOhoaFVDR/Rtx8ogE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFIo09rOle1Nql8PDRzq+tlQxiP8fFmw7m5S+Xiapk8Ufbrpd4RR0MHT26OQhYK58
         D6VLjBqKpOG8ybRHw76lByXRfmV9dZm7knsPjc28wuGFLJdhVLk4Z0fKsH4wPfzSYJ
         j/GKYh5Vb+KK3i3mrzbYtYb7ZlpG2BTbkPT9pkqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        =?UTF-8?q?Fran=C3=A7ois=20Guerraz?= <kubrick@fgv6.net>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.2 54/56] drm/i915/vbt: Fix VBT parsing for the PSR section
Date:   Thu,  8 Aug 2019 21:05:20 +0200
Message-Id: <20190808190455.496774701@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>

commit 6d61f716a01ec0e134de38ae97e71d6fec5a6ff6 upstream.

A single 32-bit PSR2 training pattern field follows the sixteen element
array of PSR table entries in the VBT spec. But, we incorrectly define
this PSR2 field for each of the PSR table entries. As a result, the PSR1
training pattern duration for any panel_type != 0 will be parsed
incorrectly. Secondly, PSR2 training pattern durations for VBTs with bdb
version >= 226 will also be wrong.

Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: stable@vger.kernel.org
Cc: stable@vger.kernel.org #v5.2
Fixes: 88a0d9606aff ("drm/i915/vbt: Parse and use the new field with PSR2 TP2/3 wakeup time")
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204183
Signed-off-by: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Tested-by: François Guerraz <kubrick@fgv6.net>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190717223451.2595-1-dhinakaran.pandiyan@intel.com
(cherry picked from commit b5ea9c9337007d6e700280c8a60b4e10d070fb53)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/i915/intel_bios.c     |    2 +-
 drivers/gpu/drm/i915/intel_vbt_defs.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -762,7 +762,7 @@ parse_psr(struct drm_i915_private *dev_p
 	}
 
 	if (bdb->version >= 226) {
-		u32 wakeup_time = psr_table->psr2_tp2_tp3_wakeup_time;
+		u32 wakeup_time = psr->psr2_tp2_tp3_wakeup_time;
 
 		wakeup_time = (wakeup_time >> (2 * panel_type)) & 0x3;
 		switch (wakeup_time) {
--- a/drivers/gpu/drm/i915/intel_vbt_defs.h
+++ b/drivers/gpu/drm/i915/intel_vbt_defs.h
@@ -772,13 +772,13 @@ struct psr_table {
 	/* TP wake up time in multiple of 100 */
 	u16 tp1_wakeup_time;
 	u16 tp2_tp3_wakeup_time;
-
-	/* PSR2 TP2/TP3 wakeup time for 16 panels */
-	u32 psr2_tp2_tp3_wakeup_time;
 } __packed;
 
 struct bdb_psr {
 	struct psr_table psr_table[16];
+
+	/* PSR2 TP2/TP3 wakeup time for 16 panels */
+	u32 psr2_tp2_tp3_wakeup_time;
 } __packed;
 
 /*


