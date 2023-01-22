Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DED676F2B
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjAVPS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjAVPS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:18:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC7E16AF5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:18:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 691A4B80B1D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28C4C433EF;
        Sun, 22 Jan 2023 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400705;
        bh=x0E8hxBOayhXmBhdN3WcFSMcMkrEFDhSTXlO5D9YmIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMb86PMn2VbRI8Botji0lMlGbc6BrtdSVS+nlJmkv0xvdsJT5T9J6KUAs+JrVNfa8
         VCuwQ6RxY0lcGK8h9lk1kiv7dDfVV+JWruIbwHKlm4CmbjVTdGaAS/bbEXRQgS/RQb
         eVFNbx6hfvbS9q5AIVmpw0FpNGi90oJVixt5xcJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Macpaul Lin <macpaul.lin@mediatek.com>,
        TommyYl Chen <tommyyl.chen@mediatek.com>,
        ChiYuan Huang <cy_huang@richtek.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 078/117] usb: typec: tcpm: Fix altmode re-registration causes sysfs create fail
Date:   Sun, 22 Jan 2023 16:04:28 +0100
Message-Id: <20230122150236.042206048@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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

From: ChiYuan Huang <cy_huang@richtek.com>

commit 36f78477ac2c89e9a2eed4a31404a291a3450b5d upstream.

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
Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together")
Reported-by: TommyYl Chen <tommyyl.chen@mediatek.com>
Cc: stable@vger.kernel.org
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/1673248790-15794-1-git-send-email-cy_huang@richtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4527,14 +4527,13 @@ static void run_state_machine(struct tcp
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


