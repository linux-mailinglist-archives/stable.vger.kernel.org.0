Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8615BB9A2
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 18:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIQQ6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 12:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIQQ6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 12:58:47 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27DB2CDF4;
        Sat, 17 Sep 2022 09:58:46 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id c7so17902485ljm.12;
        Sat, 17 Sep 2022 09:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=5sU1DzoWkYzmjgKF/V5C37vqq6ZltBq3DYbgZowqGdw=;
        b=WoH1wfJ6K2MCjgl9VG78vDz6DtVWU9igRepXzl1MBAmixRXZE4Awh8Mxeukgyh9Z+v
         iXOqzCGa1B77lQ7vI0+OO4rBFfj1lXkzuYS+EDbUJta1DnV616KkXrpRwiFGcakrNl2C
         fzcQLhKE2WlYwMFIniwQ5kmU4Z9hFE5G7JlT3vL2iMd8MgIyqJpP0V36EIeBC1HTIdwB
         utJX3Uf5fLe+MRItnw0aKs0ud3fD14vXBzCnIXitzLpn3Bozz18ztqEhMtiATBLBuSsV
         oyLYe9zlDxurvus0fGAzYiBE+0gelArwAJSgNzPV66LLEpz6cDu7RFNwnFhg2QmtQAdU
         lpBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=5sU1DzoWkYzmjgKF/V5C37vqq6ZltBq3DYbgZowqGdw=;
        b=jqXpF8q5uzUdkHuVpmZHNochT+zA4NO3QRO4llXgIS/uOlvQYfUoiDKLvooYqC18iU
         r4yLC3Wz5iQ5B7Fgi7sXTc4gRDEU4uGw9rE903/QGWM15Djd1GW4pPshJNDuPdaD1RVI
         HhBmEfDQxZybqSD8sMCrEQ87D+cgJQsP+BTnnh25o78JzlmR45bD52Cp2vYZPi4uLLrn
         J4F1yxG5NfhaR/shLI9LCqNkQN9+4122+1Ff7JK+3rM24VJUrT5VDscZg65ZLAipRfXK
         jTgcW+4YBAz95056cC6cAE8DQ2FKuB05ilX+AV/eCUMe2kNQA23GO+V30P06vXuMNu5g
         ldVw==
X-Gm-Message-State: ACrzQf0awn3A82309x6Bw5WdRPRTAFcbh9Hliq06DOHmoDoelWCLmu86
        XBgUHp+JUWZpGQRHOdAJa3g=
X-Google-Smtp-Source: AMsMyM4aopquTi1RaepOtrD0/af5Dq+LieY5BQnz7CHfQ7qBEQL+WfLwScML0PQUvY2k+I9C/muDAw==
X-Received: by 2002:a2e:92c4:0:b0:25d:9d30:5d61 with SMTP id k4-20020a2e92c4000000b0025d9d305d61mr3059918ljh.202.1663433924708;
        Sat, 17 Sep 2022 09:58:44 -0700 (PDT)
Received: from localhost (95-31-185-216.broadband.corbina.ru. [95.31.185.216])
        by smtp.gmail.com with ESMTPSA id x1-20020a056512078100b0049876c1bb24sm3832426lfr.225.2022.09.17.09.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 09:58:43 -0700 (PDT)
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Samuel Holland <samuel@sholland.org>
Cc:     Mikhail Rudenko <mike.rudenko@gmail.com>, stable@vger.kernel.org,
        linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] phy: rockchip-inno-usb2: Fix otg port initialization
Date:   Sat, 17 Sep 2022 19:58:20 +0300
Message-Id: <20220917165820.2304306-1-mike.rudenko@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are two issues in rockchip_usb2phy_otg_port_init(): (1) even if
devm_extcon_register_notifier() returns error, the code proceeds to
the next if statement and (2) if no extcon is defined in of_node, the
return value of property_enabled() is reused as the return value of
the whole function. If the return value of property_enable() is
nonzero, (2) results in an unexpected probe failure and kernel panic
in delayed work:

    Unable to handle kernel NULL pointer dereference at virtual address 00000000
    Mem abort info:
      ESR = 0x0000000086000006
      EC = 0x21: IABT (current EL), IL = 32 bits
      SET = 0, FnV = 0
      EA = 0, S1PTW = 0
      FSC = 0x06: level 2 translation fault
    user pgtable: 4k pages, 48-bit VAs, pgdp=00000000019dc000
    [0000000000000000] pgd=080000000131a003, p4d=080000000131a003, pud=080000000
    Internal error: Oops: 86000006 [#1] PREEMPT SMP
    Modules linked in: ipv6
    CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.0.0-rc5 #114
    Hardware name: FriendlyElec NanoPi M4 (DT)
    pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
    pc : 0x0
    lr : call_timer_fn.constprop.0+0x24/0x80
    sp : ffff80000a40ba40
    x29: ffff80000a40ba40 x28: 0000000000000000 x27: ffff80000a40baf0
    x26: ffff800009e779c0 x25: ffff00007fb28070 x24: ffff00007fb28028
    x23: ffff80000a40baf0 x22: 0000000000000000 x21: 0000000000000101
    x20: ffff0000006ad880 x19: 0000000000000000 x18: 0000000000000006
    x17: ffff8000761af000 x16: ffff80000800c000 x15: 0000000000004000
    x14: ffff0000006ad880 x13: 000000000000030a x12: 0000000000000000
    x11: ffff8000761af000 x10: ffff80000800bf40 x9 : ffff00007fb2d038
    x8 : 0000000000000001 x7 : 0000000000000009 x6 : 0000000000000240
    x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000200
    x2 : 000000003fffffff x1 : 0000000000000000 x0 : ffff0000016c9710
    Call trace:
     0x0
     __run_timers+0x220/0x264
     run_timer_softirq+0x20/0x40
     __do_softirq+0x10c/0x298
     __irq_exit_rcu+0xec/0xf4
     irq_exit_rcu+0x10/0x1c
     el1_interrupt+0x38/0x70
     el1h_64_irq_handler+0x18/0x24
     el1h_64_irq+0x64/0x68
     cpuidle_enter_state+0x130/0x2fc
     cpuidle_enter+0x38/0x50
     do_idle+0x22c/0x2c0
     cpu_startup_entry+0x24/0x30
     secondary_start_kernel+0x130/0x14c
     __secondary_switched+0xb0/0xb4
    Code: bad PC value
    ---[ end trace 0000000000000000 ]---
    Kernel panic - not syncing: Oops: Fatal exception in interrupt
    SMP: stopping secondary CPUs
    Kernel Offset: disabled
    CPU features: 0x4000,0820b021,00001086
    Memory Limit: none
    ---[ end Kernel panic - not syncing: Oops: Fatal exception in interrupt ]---

Refactor the control flow to avoid both issues. Since the code below
out: label does no cleanup, return error codes immediately instead of
using gotos and return success at the end of the function.

Cc: stable@vger.kernel.org
Fixes: 8dc60f8da22f ("phy: rockchip-inno-usb2: Sync initial otg state")
Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
---
 drivers/phy/rockchip/phy-rockchip-inno-usb2.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
index 0b1e9337ee8e..d31b35d55927 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -1144,8 +1144,7 @@ static int rockchip_usb2phy_otg_port_init(struct rockchip_usb2phy *rphy,
 	rport->mode = of_usb_get_dr_mode_by_phy(child_np, -1);
 	if (rport->mode == USB_DR_MODE_HOST ||
 	    rport->mode == USB_DR_MODE_UNKNOWN) {
-		ret = 0;
-		goto out;
+		return 0;
 	}
 
 	INIT_DELAYED_WORK(&rport->chg_work, rockchip_chg_detect_work);
@@ -1154,7 +1153,7 @@ static int rockchip_usb2phy_otg_port_init(struct rockchip_usb2phy *rphy,
 	ret = rockchip_usb2phy_port_irq_init(rphy, rport, child_np);
 	if (ret) {
 		dev_err(rphy->dev, "failed to init irq for host port\n");
-		goto out;
+		return ret;
 	}
 
 	if (!IS_ERR(rphy->edev)) {
@@ -1162,8 +1161,10 @@ static int rockchip_usb2phy_otg_port_init(struct rockchip_usb2phy *rphy,
 
 		ret = devm_extcon_register_notifier(rphy->dev, rphy->edev,
 					EXTCON_USB_HOST, &rport->event_nb);
-		if (ret)
+		if (ret) {
 			dev_err(rphy->dev, "register USB HOST notifier failed\n");
+			return ret;
+		}
 
 		if (!of_property_read_bool(rphy->dev->of_node, "extcon")) {
 			/* do initial sync of usb state */
@@ -1172,8 +1173,7 @@ static int rockchip_usb2phy_otg_port_init(struct rockchip_usb2phy *rphy,
 		}
 	}
 
-out:
-	return ret;
+	return 0;
 }
 
 static int rockchip_usb2phy_probe(struct platform_device *pdev)
-- 
2.37.3

