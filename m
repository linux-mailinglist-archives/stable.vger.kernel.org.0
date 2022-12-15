Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF03564D876
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 10:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiLOJWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 04:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiLOJV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 04:21:59 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E36CCD6;
        Thu, 15 Dec 2022 01:21:55 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id g10so6189237plo.11;
        Thu, 15 Dec 2022 01:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKq+74lFzjG0ld+n/1zNhWFFCw+s5cZPvJZHWPcwlfs=;
        b=Z8ftD08MnvO6lYokc6C0FaaznWFY7oZ2o88H4jjh1XTIGX6LCllsoCoAxrA/N8wBug
         UTR2e/IWhyja/+QvOSxfe8qeW/TykJjcGxshfabALZTM0BPoTQ994q6LWQhnDU5bWH7M
         dQWeF7BF5wj3Ye0QzJIrUbhazEzJXRvTPtEkPz1WFFq1Tzsz0vibXrETarxlClMVtlBk
         eGJUNgHRgFszz48swWN2wMgNypMj3VWBODgPMWoH4YzOJC4EVQl/Z4IbC2dRp1o0vAV6
         kwi54D/CUUdcx4EBco/m5r+z9lDAuOKrsjh7yC51H23U8y3vhBwXVAQkxmt1Ynn6nupS
         9dYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tKq+74lFzjG0ld+n/1zNhWFFCw+s5cZPvJZHWPcwlfs=;
        b=uqQuLsS8gFcaO46Wz/k6ogXjcOGnM+dXnqYwzosCvDGJxe9OTOQUP6sXXH3zJtulII
         zbMPdncdFCDN25MsgZXWVMkFJFtrRQuWhDxDMIaKB4UNq6gXkDZSxLygMv3gYoPdcc9L
         A+f+lKtw+bEPmu4u36kvmft9VnBti3Bs4Gh0bqpi16/HX8w03kIAL4iUpXwrHhgNkrQS
         AlM6dAs7h9COJZR+el/23yOFgCSiQxEIpxBwgRd+P+DPkiX5xmZH2NrSIapwmmHI+pjL
         uk/FlKDV/plhZ8eS0EcU2m4x42SrPVfVtmH/gXOHlRAbWTcMjSVTnObiU1EyTKxbP4L9
         syLA==
X-Gm-Message-State: ANoB5pkd3DwV5i0xEo8e7xPmb76wt2lTiB1gK50xozFW3LLqOglwsFax
        nOHJbAvuBKMkW1IrLRpRdaA=
X-Google-Smtp-Source: AA0mqf4M/m6d20Wa2QLk2x8QrsVMGAZaeNnv4gUOVoyKz4OfGf8lZpjqzPtas5y6ZGgoyfOzR4Bkcg==
X-Received: by 2002:a17:902:f610:b0:185:441e:2349 with SMTP id n16-20020a170902f61000b00185441e2349mr31031911plg.63.1671096114339;
        Thu, 15 Dec 2022 01:21:54 -0800 (PST)
Received: from localhost.localdomain ([2402:7500:486:1c9c:f86e:3e0f:1a37:f7a5])
        by smtp.gmail.com with ESMTPSA id k13-20020a170902c40d00b0017a032d7ae4sm3334796plk.104.2022.12.15.01.21.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Dec 2022 01:21:53 -0800 (PST)
From:   cy_huang <u0084500@gmail.com>
To:     linux@roeck-us.net, heikki.krogerus@linux.intel.com,
        matthias.bgg@gmail.com
Cc:     gregkh@linuxfoundation.org, tommyyl.chen@mediatek.com,
        macpaul.lin@mediatek.com, gene_chen@richtek.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        ChiYuan Huang <cy_huang@richtek.com>, stable@vger.kernel.org
Subject: [PATCH] usb: typec: tcpm: Fix altmode re-registration causes sysfs create fail
Date:   Thu, 15 Dec 2022 17:21:36 +0800
Message-Id: <1671096096-20307-1-git-send-email-u0084500@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ChiYuan Huang <cy_huang@richtek.com>

There's the altmode re-registeration issue after data role
swap (DR_SWAP).

Comparing to USBPD 2.0, in USBPD 3.0, it loose the limit that only DFP
can initiate the VDM command to get partner identity information.

For a USBPD 3.0 UFP device, it may already get the identity information
from its port partner before DR_SWAP. If DR_SWAP send or receive at the
mean time, 'send_discover' flag will be raised again. It causes discover
identify action restart while entering ready state. And after all
discover actions are done, the 'tcpm_register_altmodes' will be called.
If old altmode is not unregistered, this sysfs create fail can be found.

In 'DR_SWAP_CHANGE_DR' state case, only DFP will unregister altmodes.
For UFP, the original altmodes keep registered.

This patch fix the logic that after DR_SWAP, 'tcpm_unregister_altmodes'
must be called whatever the current data role is.

Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together)
Reported-by: TommyYl Chen <tommyyl.chen@mediatek.com>
Cc: stable@vger.kernel.org
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
---
Hi,

Below's the issue log for the reference.

*TCPM
[    3.856679] AMS DISCOVER_MODES start
[    3.856687] PD TX, header: 0x188f
[    3.858827] PD TX complete, status: 0
[    3.865330] PD RX, header: 0x2daf [1]
[    3.865340] Rx VDM cmd 0xff01a043 type 1 cmd 3 len 2
[    3.865348] AMS DISCOVER_MODES finished
[    3.865352]  Alternate mode 0: SVID 0xff01, VDO 1: 0x001c0045
[    3.865362] AMS DISCOVER_MODES start
[    3.865367] PD TX, header: 0x1a8f
[    3.867802] PD TX complete, status: 0
[    3.875208] PD RX, header: 0x2faf [1]
[    3.875216] Rx VDM cmd 0x413ca043 type 1 cmd 3 len 2
[    3.875222] AMS DISCOVER_MODES finished
[    3.875225]  Alternate mode 1: SVID 0x413c, VDO 1: 0x00000001
[    3.938243] AMS GET_SINK_CAPABILITIES start
[    3.938255] state change SNK_READY -> AMS_START [rev3 GET_SINK_CAPABILITIES]
[    3.938266] state change AMS_START -> GET_SINK_CAP [rev3 GET_SINK_CAPABILITIES]
[    3.938274] PD TX, header: 0xe88
[    3.940268] PD TX complete, status: 0
[    3.940310] pending state change GET_SINK_CAP -> GET_SINK_CAP_TIMEOUT @ 60 ms
[rev3 GET_SINK_CAPABILITIES]
[    3.946291] PD RX, header: 0x13a4 [1]
[    3.946295] Port partner FRS capable partner_frs_current:0 port_frs_current:0 enable:n
[    3.946298] state change GET_SINK_CAP -> SNK_READY [rev3 GET_SINK_CAPABILITIES]
[    3.946304] AMS GET_SINK_CAPABILITIES finished
[    4.239342] CC1: 5 -> 4, CC2: 0 -> 0 [state SNK_READY, polarity 0, connected]
[    4.256594] PD RX, header: 0x5a9 [1]
[    4.256603] state change SNK_READY -> DR_SWAP_ACCEPT [rev3 DATA_ROLE_SWAP]
[    4.256609] PD TX, header: 0x83
[    4.258528] PD TX complete, status: 0
[    4.258584] state change DR_SWAP_ACCEPT -> DR_SWAP_CHANGE_DR [rev3 DATA_ROLE_SWAP]
[    4.258591] Requesting mux state 1, usb-role 1, orientation 1
[    4.259588] AMS DATA_ROLE_SWAP finished
[    4.259592] state change DR_SWAP_CHANGE_DR -> SNK_READY [rev3 NONE_AMS]
[    4.259605] AMS DISCOVER_IDENTITY start
[    4.259609] Sink TX No Go
[    4.260874] CC1: 4 -> 5, CC2: 0 -> 0 [state SNK_READY, polarity 0, connected]
[    4.359636] AMS DISCOVER_IDENTITY start
[    4.359642] PD TX, header: 0x12af
[    4.361884] PD TX complete, status: 0
[    4.369433] PD RX, header: 0x578f [1]
[    4.369439] Rx VDM cmd 0xff00a041 type 1 cmd 1 len 5
[    4.369448] AMS DISCOVER_IDENTITY finished
[    4.369515] Identity: 413c:c013.0712
[    4.369521] AMS DISCOVER_SVIDS start
[    4.369524] PD TX, header: 0x14af
[    4.371696] PD TX complete, status: 0
[    4.378564] PD RX, header: 0x398f [1]
[    4.378573] Rx VDM cmd 0xff00a042 type 1 cmd 2 len 3
[    4.378579] AMS DISCOVER_SVIDS finished
[    4.378582] SVID 1: 0xff01
[    4.378584] SVID 2: 0x413c
[    4.378594] AMS DISCOVER_MODES start
[    4.378597] PD TX, header: 0x16af
[    4.380696] PD TX complete, status: 0
[    4.387008] PD RX, header: 0x2b8f [1]
[    4.387014] Rx VDM cmd 0xff01a043 type 1 cmd 3 len 2
[    4.387021] AMS DISCOVER_MODES finished
[    4.387023]  Alternate mode 0: SVID 0xff01, VDO 1: 0x001c0045
[    4.387029] AMS DISCOVER_MODES start
[    4.387031] PD TX, header: 0x18af
[    4.389134] PD TX complete, status: 0
[    4.395528] PD RX, header: 0x2d8f [1]
[    4.395538] Rx VDM cmd 0x413ca043 type 1 cmd 3 len 2
[    4.395546] AMS DISCOVER_MODES finished
[    4.395548]  Alternate mode 1: SVID 0x413c, VDO 1: 0x00000001

*Kernel TRACE
sysfs: cannot create duplicate filename
'/devices/platform/soc/11d01000.i2c/i2c-0/0-0034/mt6360-tcpc.6.auto/typec/port0/port0.0/partner'
CPU: 2 PID: 299 Comm: mt6360-tcpc.6.a Tainted: GO      5.15.37-mtk+g880abc5122e7 #1
Hardware name: MediaTek MT8195 demo board (DT)
Call trace:
 dump_backtrace+0x0/0x1ac
 show_stack+0x24/0x30
 dump_stack_lvl+0x68/0x84
 dump_stack+0x1c/0x38
 sysfs_warn_dup+0x70/0x90
 typec_probe+0xa4/0x134 [typec]
 really_probe.part.0+0xa4/0x310
 __device_attach_driver+0x100/0x16c
 bus_for_each_drv+0x84/0xe0
 __device_attach+0xe0/0x1ac
 device_add+0x39c/0x8b0
 device_register+0x2c/0x40
 typec_register_altmode+0x1f4/0x360 [typec]
 typec_partner_register_altmode+0x1c/0x30 [typec]
 tcpm_pd_rx_handler+0x19d4/0x1c0c [tcpm]
 kthread_worker_fn+0xb8/0x290
 kthread+0x15c/0x170
 ret_from_fork+0x10/0x20
[    4.395962] typec_displayport port0-partner.2: failed to create symlinks
[    4.395967] typec_displayport: probe of port0-partner.2 failed with error -17

It seems it's a common issue if typec port supports the modal operation.

---
 drivers/usb/typec/tcpm/tcpm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 904c7b4..59b366b 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4594,14 +4594,13 @@ static void run_state_machine(struct tcpm_port *port)
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 	case DR_SWAP_CHANGE_DR:
-		if (port->data_role == TYPEC_HOST) {
-			tcpm_unregister_altmodes(port);
+		tcpm_unregister_altmodes(port);
+		if (port->data_role == TYPEC_HOST)
 			tcpm_set_roles(port, true, port->pwr_role,
 				       TYPEC_DEVICE);
-		} else {
+		else
 			tcpm_set_roles(port, true, port->pwr_role,
 				       TYPEC_HOST);
-		}
 		tcpm_ams_finish(port);
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
-- 
2.7.4

