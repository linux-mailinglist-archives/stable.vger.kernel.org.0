Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC331A709F
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbfICQZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730355AbfICQZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:25:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11F432343A;
        Tue,  3 Sep 2019 16:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527921;
        bh=y6jv+OHUHxEmn5hA5V/b/pfb8RWdE4SDWdiWC+3AyFY=;
        h=From:To:Cc:Subject:Date:From;
        b=fktxo9kwQhwWMFXoU7eQDyn04xa/nB5bfIOAislXbhxWTJ4g9LGpF9cmGc6rq2ps0
         VRB42Q6W2KyfuaY0P5a7TblDJND6KmCI2kShRIn+DhNumBMSbcO1I8AwQm2Rz6g+5W
         LJqybxcRH3j1hlbMqPd97dqhlnP+Lg263ri59lSU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan-Marek Glogowski <glogow@fbihome.de>,
        Lyude Paul <lyude@redhat.com>, Sasha Levin <sashal@kernel.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 001/167] drm/i915: Re-apply "Perform link quality check, unconditionally during long pulse"
Date:   Tue,  3 Sep 2019 12:22:33 -0400
Message-Id: <20190903162519.7136-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan-Marek Glogowski <glogow@fbihome.de>

[ Upstream commit 3cf71bc9904d7ee4a25a822c5dcb54c7804ea388 ]

This re-applies the workaround for "some DP sinks, [which] are a
little nuts" from commit 1a36147bb939 ("drm/i915: Perform link
quality check unconditionally during long pulse").
It makes the secondary AOC E2460P monitor connected via DP to an
acer Veriton N4640G usable again.

This hunk was dropped in commit c85d200e8321 ("drm/i915: Move SST
DP link retraining into the ->post_hotplug() hook")

Fixes: c85d200e8321 ("drm/i915: Move SST DP link retraining into the ->post_hotplug() hook")
[Cleaned up commit message, added stable cc]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Jan-Marek Glogowski <glogow@fbihome.de>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20180825191035.3945-1-lyude@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/intel_dp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index f92079e19de8d..20cd4c8acecc3 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -4739,6 +4739,22 @@ intel_dp_long_pulse(struct intel_connector *connector,
 		 */
 		status = connector_status_disconnected;
 		goto out;
+	} else {
+		/*
+		 * If display is now connected check links status,
+		 * there has been known issues of link loss triggering
+		 * long pulse.
+		 *
+		 * Some sinks (eg. ASUS PB287Q) seem to perform some
+		 * weird HPD ping pong during modesets. So we can apparently
+		 * end up with HPD going low during a modeset, and then
+		 * going back up soon after. And once that happens we must
+		 * retrain the link to get a picture. That's in case no
+		 * userspace component reacted to intermittent HPD dip.
+		 */
+		struct intel_encoder *encoder = &dp_to_dig_port(intel_dp)->base;
+
+		intel_dp_retrain_link(encoder, ctx);
 	}
 
 	/*
-- 
2.20.1

