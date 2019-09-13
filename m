Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08492B1FFE
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389278AbfIMNNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388696AbfIMNNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:07 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F066D208C0;
        Fri, 13 Sep 2019 13:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380386;
        bh=/tMcsQLJXwZCavsk4/LHrnvm30ckf20vWoFTw+/AAVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUQ8OCdMz0ngyQGIOuVf6zBqQC3jUk0qpcJRBUvojZqKc6etWmunucllU+skDEqcQ
         2UlL9UAuE3z/wASx38cjyhzg4NtovVWMRXPQzzNvPzkBK5/lkJfVH4p16crsET9h05
         uGkov+f0kDYm7SMcAv76YewYWeF1uMJOErtSvVRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Jan-Marek Glogowski <glogow@fbihome.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 030/190] drm/i915: Re-apply "Perform link quality check, unconditionally during long pulse"
Date:   Fri, 13 Sep 2019 14:04:45 +0100
Message-Id: <20190913130602.044100904@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



