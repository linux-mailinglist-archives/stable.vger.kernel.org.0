Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF541469E1D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350649AbhLFPgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48156 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387877AbhLFPcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:32:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C965D6132A;
        Mon,  6 Dec 2021 15:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB0DC34901;
        Mon,  6 Dec 2021 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804512;
        bh=2ShyBfhNKhTojNtGZoMi+Kkr4HOEAiks/BUaYV0mTgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZClk8nS1r5huO3q7Qt2GlvqlHcEcStMi+7TxJS4Nymhr2hLMpbjVz5evUb91U/Re2
         W1g5wgERO3KHNNmNIFmwo3A/ytt69F32e6mrDC3hHq3OeEqyaNc+zidR6dpUwkbrAm
         Eg7zTDsj97Rvbq9vF/j3VAjzN9wCzfTlLP55hFGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH 5.15 141/207] drm/vc4: kms: Add missing drm_crtc_commit_put
Date:   Mon,  6 Dec 2021 15:56:35 +0100
Message-Id: <20211206145615.114552684@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

commit 049cfff8d53a30cae3349ff71a4c01b7d9981bc2 upstream.

Commit 9ec03d7f1ed3 ("drm/vc4: kms: Wait on previous FIFO users before a
commit") introduced a global state for the HVS, with each FIFO storing
the current CRTC commit so that we can properly synchronize commits.

However, the refcounting was off and we thus ended up leaking the
drm_crtc_commit structure every commit. Add a drm_crtc_commit_put to
prevent the leakage.

Fixes: 9ec03d7f1ed3 ("drm/vc4: kms: Wait on previous FIFO users before a commit")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Tested-by: Jian-Hong Pan <jhp@endlessos.org>
Link: https://lore.kernel.org/r/20211117094527.146275-4-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vc4/vc4_kms.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vc4/vc4_kms.c
+++ b/drivers/gpu/drm/vc4/vc4_kms.c
@@ -361,6 +361,7 @@ static void vc4_atomic_commit_tail(struc
 		struct vc4_crtc_state *vc4_crtc_state =
 			to_vc4_crtc_state(old_crtc_state);
 		unsigned int channel = vc4_crtc_state->assigned_channel;
+		struct drm_crtc_commit *commit;
 		int ret;
 
 		if (channel == VC4_HVS_CHANNEL_DISABLED)
@@ -369,9 +370,15 @@ static void vc4_atomic_commit_tail(struc
 		if (!old_hvs_state->fifo_state[channel].in_use)
 			continue;
 
-		ret = drm_crtc_commit_wait(old_hvs_state->fifo_state[channel].pending_commit);
+		commit = old_hvs_state->fifo_state[channel].pending_commit;
+		if (!commit)
+			continue;
+
+		ret = drm_crtc_commit_wait(commit);
 		if (ret)
 			drm_err(dev, "Timed out waiting for commit\n");
+
+		drm_crtc_commit_put(commit);
 	}
 
 	if (vc4->hvs->hvs5)


