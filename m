Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F09661BF4
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 02:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbjAIBfW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 8 Jan 2023 20:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbjAIBfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Jan 2023 20:35:22 -0500
Received: from mg.richtek.com (mg.richtek.com [220.130.44.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7CC6B86E
        for <stable@vger.kernel.org>; Sun,  8 Jan 2023 17:35:18 -0800 (PST)
X-MailGates: (flag:4,DYNAMIC,BADHELO,RELAY,NOHOST:PASS)(compute_score:DE
        LIVER,40,3)
Received: from 192.168.10.46
        by mg.richtek.com with MailGates ESMTP Server V5.0(16482:0:AUTH_RELAY)
        (envelope-from <cy_huang@richtek.com>); Mon, 09 Jan 2023 09:34:54 +0800 (CST)
Received: from ex3.rt.l (192.168.10.46) by ex3.rt.l (192.168.10.46) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.20; Mon, 9 Jan
 2023 09:34:53 +0800
Received: from linuxcarl2.richtek.com (192.168.10.154) by ex3.rt.l
 (192.168.10.45) with Microsoft SMTP Server id 15.2.1118.20 via Frontend
 Transport; Mon, 9 Jan 2023 09:34:53 +0800
From:   <cy_huang@richtek.com>
To:     <linux@roeck-us.net>, <heikki.krogerus@linux.intel.com>,
        <matthias.bgg@gmail.com>
CC:     <gregkh@linuxfoundation.org>, <gene_chen@richtek.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        ChiYuan Huang <cy_huang@richtek.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] usb: typec: tcpm: Fix altmode re-registration causes sysfs create fail
Date:   Mon, 9 Jan 2023 09:34:52 +0800
Message-ID: <1673228092-27281-1-git-send-email-cy_huang@richtek.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Macpaul Lin <macpaul.lin@mediatek.com>
Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together)
Reported-by: TommyYl Chen <tommyyl.chen@mediatek.com>
Cc: stable@vger.kernel.org
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
---
Since v2:
1. Correct the mail sent from Richtek.
2. Add 'Reviewed-by' tag.

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
-               if (port->data_role == TYPEC_HOST) {
-                       tcpm_unregister_altmodes(port);
+               tcpm_unregister_altmodes(port);
+               if (port->data_role == TYPEC_HOST)
                        tcpm_set_roles(port, true, port->pwr_role,
                                       TYPEC_DEVICE);
-               } else {
+               else
                        tcpm_set_roles(port, true, port->pwr_role,
                                       TYPEC_HOST);
-               }
                tcpm_ams_finish(port);
                tcpm_set_state(port, ready_state(port), 0);
                break;
--
2.7.4

************* Email Confidentiality Notice ********************

The information contained in this e-mail message (including any attachments) may be confidential, proprietary, privileged, or otherwise exempt from disclosure under applicable laws. It is intended to be conveyed only to the designated recipient(s). Any use, dissemination, distribution, printing, retaining or copying of this e-mail (including its attachments) by unintended recipient(s) is strictly prohibited and may be unlawful. If you are not an intended recipient of this e-mail, or believe that you have received this e-mail in error, please notify the sender immediately (by replying to this e-mail), delete any and all copies of this e-mail (including any attachments) from your system, and do not disclose the content of this e-mail to any other person. Thank you!
