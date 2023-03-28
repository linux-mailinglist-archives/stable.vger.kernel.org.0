Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9546CC467
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbjC1PEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjC1PEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:04:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204A2EB48
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F6E1B81D7D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E14CC433EF;
        Tue, 28 Mar 2023 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015784;
        bh=6xKV1IegHjiXEHUs7HhfNhN/Bsm0ZPS2qRjBo0cH1H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZfA2dYRaVq7xBBPwy6ni4mMWZZQ8T9XBOXY1wVtBeDk3b8J6Hn3vTDNiI2//Sogg
         VFi/9DhXiAXJXDCEIZNa/Njfc0l6eJb52IuN1aAe6DZ9LbBv6D7UGSSRDZDuKhP4/S
         28fXmTN07HaM8Qgu44DiLVzCpSNWEzHU5z+h6cSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Yang <xu.yang_2@nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 174/224] usb: typec: tcpm: fix create duplicate source-capabilities file
Date:   Tue, 28 Mar 2023 16:42:50 +0200
Message-Id: <20230328142624.635737075@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yang <xu.yang_2@nxp.com>

commit a826492fc9dfe32afd70fff93955ae8174bbf14b upstream.

The kernel will dump in the below cases:
sysfs: cannot create duplicate filename
'/devices/virtual/usb_power_delivery/pd1/source-capabilities'

1. After soft reset has completed, an Explicit Contract negotiation occurs.
The sink device will receive source capabilitys again. This will cause
a duplicate source-capabilities file be created.
2. Power swap twice on a device that is initailly sink role.

This will unregister existing capabilities when above cases occurs.

Fixes: 8203d26905ee ("usb: typec: tcpm: Register USB Power Delivery Capabilities")
cc: <stable@vger.kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230215054951.238394-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4547,6 +4547,9 @@ static void run_state_machine(struct tcp
 	case SOFT_RESET:
 		port->message_id = 0;
 		port->rx_msgid = -1;
+		/* remove existing capabilities */
+		usb_power_delivery_unregister_capabilities(port->partner_source_caps);
+		port->partner_source_caps = NULL;
 		tcpm_pd_send_control(port, PD_CTRL_ACCEPT);
 		tcpm_ams_finish(port);
 		if (port->pwr_role == TYPEC_SOURCE) {
@@ -4566,6 +4569,9 @@ static void run_state_machine(struct tcp
 	case SOFT_RESET_SEND:
 		port->message_id = 0;
 		port->rx_msgid = -1;
+		/* remove existing capabilities */
+		usb_power_delivery_unregister_capabilities(port->partner_source_caps);
+		port->partner_source_caps = NULL;
 		if (tcpm_pd_send_control(port, PD_CTRL_SOFT_RESET))
 			tcpm_set_state_cond(port, hard_reset_state(port), 0);
 		else
@@ -4695,6 +4701,9 @@ static void run_state_machine(struct tcp
 		tcpm_set_state(port, SNK_STARTUP, 0);
 		break;
 	case PR_SWAP_SNK_SRC_SINK_OFF:
+		/* will be source, remove existing capabilities */
+		usb_power_delivery_unregister_capabilities(port->partner_source_caps);
+		port->partner_source_caps = NULL;
 		/*
 		 * Prevent vbus discharge circuit from turning on during PR_SWAP
 		 * as this is not a disconnect.


