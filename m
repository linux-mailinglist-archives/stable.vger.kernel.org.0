Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B84846A952
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350240AbhLFVQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:16:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51674 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350301AbhLFVQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:16:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0846AB81221;
        Mon,  6 Dec 2021 21:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367B6C341C7;
        Mon,  6 Dec 2021 21:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825187;
        bh=H4uUvM5pppAu6WzREmO2UlgD4GP2fvGc+Ml8KZHDA48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eo0ZRvNgGlVh2u62uSm0aX6OKemDRtFFAgJ2wN2BnWMafYgrHx47gGWFcYrQHH73/
         BgUJd4Ck8mLycyaTaywauEUxxzWaibtMT4i4gQTfCdyj0GOuMEJ7bSaB+YZP2r8LRh
         lJ4kSJCXAG2E29gr1wo0bYIr5A1keppXq6uYSmC41auRQ0tOjDKPF3ePtVqG8Xn676
         GKfF1K5xCEFJGaT2mqv8qMrU6R6HivLXEUjXwOE6nvPqPX2X+zD06gVDB5nf+RZKL6
         mb/3GoO5JDbbbEtQxLzQv1/SiudHB4vzWKJm7iZKP/5nvKiAYaWAT1F3vb3M2hrOUC
         poXqNkbAMKHWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        khsieh@codeaurora.org, swboyd@chromium.org,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 04/24] drm/msm/dp: Avoid unpowered AUX xfers that caused crashes
Date:   Mon,  6 Dec 2021 16:12:09 -0500
Message-Id: <20211206211230.1660072-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit d03fcc1de0863b1188ceb867cfa84a578fdc96bc ]

If you happened to try to access `/dev/drm_dp_aux` devices provided by
the MSM DP AUX driver too early at bootup you could go boom. Let's
avoid that by only allowing AUX transfers when the controller is
powered up.

Specifically the crash that was seen (on Chrome OS 5.4 tree with
relevant backports):
  Kernel panic - not syncing: Asynchronous SError Interrupt
  CPU: 0 PID: 3131 Comm: fwupd Not tainted 5.4.144-16620-g28af11b73efb #1
  Hardware name: Google Lazor (rev3+) with KB Backlight (DT)
  Call trace:
   dump_backtrace+0x0/0x14c
   show_stack+0x20/0x2c
   dump_stack+0xac/0x124
   panic+0x150/0x390
   nmi_panic+0x80/0x94
   arm64_serror_panic+0x78/0x84
   do_serror+0x0/0x118
   do_serror+0xa4/0x118
   el1_error+0xbc/0x160
   dp_catalog_aux_write_data+0x1c/0x3c
   dp_aux_cmd_fifo_tx+0xf0/0x1b0
   dp_aux_transfer+0x1b0/0x2bc
   drm_dp_dpcd_access+0x8c/0x11c
   drm_dp_dpcd_read+0x64/0x10c
   auxdev_read_iter+0xd4/0x1c4

I did a little bit of tracing and found that:
* We register the AUX device very early at bootup.
* Power isn't actually turned on for my system until
  hpd_event_thread() -> dp_display_host_init() -> dp_power_init()
* You can see that dp_power_init() calls dp_aux_init() which is where
  we start allowing AUX channel requests to go through.

In general this patch is a bit of a bandaid but at least it gets us
out of the current state where userspace acting at the wrong time can
fully crash the system.
* I think the more proper fix (which requires quite a bit more
  changes) is to power stuff on while an AUX transfer is
  happening. This is like the solution we did for ti-sn65dsi86. This
  might be required for us to move to populating the panel via the
  DP-AUX bus.
* Another fix considered was to dynamically register / unregister. I
  tried that at <https://crrev.com/c/3169431/3> but it got
  ugly. Currently there's a bug where the pm_runtime() state isn't
  tracked properly and that causes us to just keep registering more
  and more.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Link: https://lore.kernel.org/r/20211109100403.1.I4e23470d681f7efe37e2e7f1a6466e15e9bb1d72@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_aux.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_aux.c b/drivers/gpu/drm/msm/dp/dp_aux.c
index eb40d8413bca9..6d36f63c33388 100644
--- a/drivers/gpu/drm/msm/dp/dp_aux.c
+++ b/drivers/gpu/drm/msm/dp/dp_aux.c
@@ -33,6 +33,7 @@ struct dp_aux_private {
 	bool read;
 	bool no_send_addr;
 	bool no_send_stop;
+	bool initted;
 	u32 offset;
 	u32 segment;
 
@@ -331,6 +332,10 @@ static ssize_t dp_aux_transfer(struct drm_dp_aux *dp_aux,
 	}
 
 	mutex_lock(&aux->mutex);
+	if (!aux->initted) {
+		ret = -EIO;
+		goto exit;
+	}
 
 	dp_aux_update_offset_and_segment(aux, msg);
 	dp_aux_transfer_helper(aux, msg, true);
@@ -380,6 +385,8 @@ static ssize_t dp_aux_transfer(struct drm_dp_aux *dp_aux,
 	}
 
 	aux->cmd_busy = false;
+
+exit:
 	mutex_unlock(&aux->mutex);
 
 	return ret;
@@ -431,8 +438,13 @@ void dp_aux_init(struct drm_dp_aux *dp_aux)
 
 	aux = container_of(dp_aux, struct dp_aux_private, dp_aux);
 
+	mutex_lock(&aux->mutex);
+
 	dp_catalog_aux_enable(aux->catalog, true);
 	aux->retry_cnt = 0;
+	aux->initted = true;
+
+	mutex_unlock(&aux->mutex);
 }
 
 void dp_aux_deinit(struct drm_dp_aux *dp_aux)
@@ -441,7 +453,12 @@ void dp_aux_deinit(struct drm_dp_aux *dp_aux)
 
 	aux = container_of(dp_aux, struct dp_aux_private, dp_aux);
 
+	mutex_lock(&aux->mutex);
+
+	aux->initted = false;
 	dp_catalog_aux_enable(aux->catalog, false);
+
+	mutex_unlock(&aux->mutex);
 }
 
 int dp_aux_register(struct drm_dp_aux *dp_aux)
-- 
2.33.0

