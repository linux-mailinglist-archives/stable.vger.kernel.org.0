Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2D66AEF22
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjCGSUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbjCGSTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:19:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4F29E070
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6779D6152F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C66EC433D2;
        Tue,  7 Mar 2023 18:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212838;
        bh=CwvJC1P2mP88Uf1pycLjJJqRKXaVTQUFbaVBEJxkmx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfHN3wh0ouGUGRwOTkUwvTj31EMPT/DkemP2hIQwvLv8CnLfBOUzWMmJvFznGCj0S
         4P926pN+DVxZ0999sugZ4xe+1JMxg6hrHGrtzfOtOeWqBPOMZMNaUWDe4fF3ta/TLT
         2+wnF+1OaR5BRzZZaJvs8WWJmdJeeSym1NYBMrCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Wahren <stefan.wahren@i2se.com>,
        =?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 274/885] drm/vc4: drop all currently held locks if deadlock happens
Date:   Tue,  7 Mar 2023 17:53:28 +0100
Message-Id: <20230307170013.918114190@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 479d4f0be4237ba33bc9432787aeb62c90e30f95 ]

If vc4_hdmi_reset_link() returns -EDEADLK, it means that a deadlock
happened in the locking context. This situation should be addressed by
dropping all currently held locks and block until the contended lock
becomes available. Currently, vc4 is not dealing with the deadlock
properly, producing the following output when PROVE_LOCKING is enabled:

[  825.612809] ------------[ cut here ]------------
[  825.612852] WARNING: CPU: 1 PID: 116 at drivers/gpu/drm/drm_modeset_lock.c:276 drm_modeset_drop_locks+0x60/0x68 [drm]
[  825.613458] Modules linked in: 8021q mrp garp stp llc
raspberrypi_cpufreq brcmfmac brcmutil crct10dif_ce hci_uart cfg80211
btqca btbcm bluetooth vc4 raspberrypi_hwmon snd_soc_hdmi_codec cec
clk_raspberrypi ecdh_generic drm_display_helper ecc rfkill
drm_dma_helper drm_kms_helper pwm_bcm2835 bcm2835_thermal bcm2835_rng
rng_core i2c_bcm2835 drm fuse ip_tables x_tables ipv6
[  825.613735] CPU: 1 PID: 116 Comm: kworker/1:2 Tainted: G        W 6.1.0-rc6-01399-g941aae326315 #3
[  825.613759] Hardware name: Raspberry Pi 3 Model B Rev 1.2 (DT)
[  825.613777] Workqueue: events output_poll_execute [drm_kms_helper]
[  825.614038] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  825.614063] pc : drm_modeset_drop_locks+0x60/0x68 [drm]
[  825.614603] lr : drm_helper_probe_detect+0x120/0x1b4 [drm_kms_helper]
[  825.614829] sp : ffff800008313bf0
[  825.614844] x29: ffff800008313bf0 x28: ffffcd7778b8b000 x27: 0000000000000000
[  825.614883] x26: 0000000000000001 x25: 0000000000000001 x24: ffff677cc35c2758
[  825.614920] x23: ffffcd7707d01430 x22: ffffcd7707c3edc7 x21: 0000000000000001
[  825.614958] x20: 0000000000000000 x19: ffff800008313c10 x18: 000000000000b6d3
[  825.614995] x17: ffffcd777835e214 x16: ffffcd7777cef870 x15: fffff81000000000
[  825.615033] x14: 0000000000000000 x13: 0000000000000099 x12: 0000000000000002
[  825.615070] x11: 72917988020af800 x10: 72917988020af800 x9 : 72917988020af800
[  825.615108] x8 : ffff677cc665e0a8 x7 : d00a8c180000110c x6 : ffffcd77774c0054
[  825.615145] x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
[  825.615181] x2 : ffff677cc55e1880 x1 : ffffcd7777cef8ec x0 : ffff800008313c10
[  825.615219] Call trace:
[  825.615232]  drm_modeset_drop_locks+0x60/0x68 [drm]
[  825.615773]  drm_helper_probe_detect+0x120/0x1b4 [drm_kms_helper]
[  825.616003]  output_poll_execute+0xe4/0x224 [drm_kms_helper]
[  825.616233]  process_one_work+0x2b4/0x618
[  825.616264]  worker_thread+0x24c/0x464
[  825.616288]  kthread+0xec/0x110
[  825.616310]  ret_from_fork+0x10/0x20
[  825.616335] irq event stamp: 7634
[  825.616349] hardirqs last  enabled at (7633): [<ffffcd777831ee90>] _raw_spin_unlock_irq+0x3c/0x78
[  825.616384] hardirqs last disabled at (7634): [<ffffcd7778315a78>] __schedule+0x134/0x9f0
[  825.616411] softirqs last  enabled at (7630): [<ffffcd7707aacea0>] local_bh_enable+0x4/0x30 [ipv6]
[  825.617019] softirqs last disabled at (7618): [<ffffcd7707aace70>] local_bh_disable+0x4/0x30 [ipv6]
[  825.617586] ---[ end trace 0000000000000000 ]---

Therefore, deal with the deadlock as suggested by [1], using the
function drm_modeset_backoff().

[1] https://docs.kernel.org/gpu/drm-kms.html?highlight=kms#kms-locking

Fixes: 6bed2ea3cb38 ("drm/vc4: hdmi: Reset link on hotplug")
Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20221229194638.178712-1-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index c4b73d9dd0409..0d0b6df4df153 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -402,6 +402,7 @@ static void vc4_hdmi_handle_hotplug(struct vc4_hdmi *vc4_hdmi,
 {
 	struct drm_connector *connector = &vc4_hdmi->connector;
 	struct edid *edid;
+	int ret;
 
 	/*
 	 * NOTE: This function should really be called with
@@ -430,7 +431,15 @@ static void vc4_hdmi_handle_hotplug(struct vc4_hdmi *vc4_hdmi,
 	cec_s_phys_addr_from_edid(vc4_hdmi->cec_adap, edid);
 	kfree(edid);
 
-	vc4_hdmi_reset_link(connector, ctx);
+	for (;;) {
+		ret = vc4_hdmi_reset_link(connector, ctx);
+		if (ret == -EDEADLK) {
+			drm_modeset_backoff(ctx);
+			continue;
+		}
+
+		break;
+	}
 }
 
 static int vc4_hdmi_connector_detect_ctx(struct drm_connector *connector,
-- 
2.39.2



