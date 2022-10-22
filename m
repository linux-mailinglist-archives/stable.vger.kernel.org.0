Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A752608753
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiJVIAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiJVH6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:58:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB7A3C8C4;
        Sat, 22 Oct 2022 00:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 184C3B82DB3;
        Sat, 22 Oct 2022 07:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A95C433D6;
        Sat, 22 Oct 2022 07:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424919;
        bh=tHZ+Kc3V7pkYjCTEr+UzdBcU68D87nzYfaa2EbrgrWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9H7OtsL5IujnMKO7g+ZSlQh2A4smObuH1COSs7+UzWPYzMj4QNZCInZHilmQMNSc
         PH6WP9NlL2VpwcEluonWie3E76KVE0e81sAS5KGvVR7e1S6j9uAOK0bL7tGaVmvgl6
         Sc04gBymRV3yDWaNLpDJ4ZE8yaCnYFL3L/Oo68Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 296/717] drm: bridge: adv7511: unregister cec i2c device after cec adapter
Date:   Sat, 22 Oct 2022 09:22:55 +0200
Message-Id: <20221022072505.481613332@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit 40cdb02cb9f965732eb543d47f15bef8d10f0f5f ]

cec_unregister_adapter() assumes that the underlying adapter ops are
callable. For example, if the CEC adapter currently has a valid physical
address, then the unregistration procedure will invalidate the physical
address by setting it to f.f.f.f. Whence the following kernel oops
observed after removing the adv7511 module:

    Unable to handle kernel execution of user memory at virtual address 0000000000000000
    Internal error: Oops: 86000004 [#1] PREEMPT_RT SMP
    Call trace:
     0x0
     adv7511_cec_adap_log_addr+0x1ac/0x1c8 [adv7511]
     cec_adap_unconfigure+0x44/0x90 [cec]
     __cec_s_phys_addr.part.0+0x68/0x230 [cec]
     __cec_s_phys_addr+0x40/0x50 [cec]
     cec_unregister_adapter+0xb4/0x118 [cec]
     adv7511_remove+0x60/0x90 [adv7511]
     i2c_device_remove+0x34/0xe0
     device_release_driver_internal+0x114/0x1f0
     driver_detach+0x54/0xe0
     bus_remove_driver+0x60/0xd8
     driver_unregister+0x34/0x60
     i2c_del_driver+0x2c/0x68
     adv7511_exit+0x1c/0x67c [adv7511]
     __arm64_sys_delete_module+0x154/0x288
     invoke_syscall+0x48/0x100
     el0_svc_common.constprop.0+0x48/0xe8
     do_el0_svc+0x28/0x88
     el0_svc+0x1c/0x50
     el0t_64_sync_handler+0xa8/0xb0
     el0t_64_sync+0x15c/0x160
    Code: bad PC value
    ---[ end trace 0000000000000000 ]---

Protect against this scenario by unregistering i2c_cec after
unregistering the CEC adapter. Duly disable the CEC clock afterwards
too.

Fixes: 3b1b975003e4 ("drm: adv7511/33: add HDMI CEC support")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220612144854.2223873-3-alvin@pqrs.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 38bf28720f3a..6031bdd92342 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1340,9 +1340,6 @@ static int adv7511_remove(struct i2c_client *i2c)
 {
 	struct adv7511 *adv7511 = i2c_get_clientdata(i2c);
 
-	i2c_unregister_device(adv7511->i2c_cec);
-	clk_disable_unprepare(adv7511->cec_clk);
-
 	adv7511_uninit_regulators(adv7511);
 
 	drm_bridge_remove(&adv7511->bridge);
@@ -1350,6 +1347,8 @@ static int adv7511_remove(struct i2c_client *i2c)
 	adv7511_audio_exit(adv7511);
 
 	cec_unregister_adapter(adv7511->cec_adap);
+	i2c_unregister_device(adv7511->i2c_cec);
+	clk_disable_unprepare(adv7511->cec_clk);
 
 	i2c_unregister_device(adv7511->i2c_packet);
 	i2c_unregister_device(adv7511->i2c_edid);
-- 
2.35.1



