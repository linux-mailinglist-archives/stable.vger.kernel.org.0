Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E253A6433
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhFNLVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235859AbhFNLTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:19:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 893056146D;
        Mon, 14 Jun 2021 10:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667883;
        bh=eZoL2bR4zZrJTCBHg1P1deW+/wiQH08DCVcdTQ25AWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHHaWdPZFIzJuf/XsqUcKDv3K6/K8jEmFrCPyIAyLMxFGrm/qkfNHAYXpFKI2InbS
         GsfNbJNASCumiSTO/7VcNPBj2jEmgpAxiT1exbokvgjERqiDn1vOPqAXHGWa2fh1kb
         Kybp91EBooDJIiP+D2g6RbhqCp4makmJdP8hY6go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kyle Tso <kyletso@google.com>
Subject: [PATCH 5.12 112/173] usb: typec: tcpm: Do not finish VDM AMS for retrying Responses
Date:   Mon, 14 Jun 2021 12:27:24 +0200
Message-Id: <20210614102701.891223351@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

commit 5ab14ab1f2db24ffae6c5c39a689660486962e6e upstream.

If the VDM responses couldn't be sent successfully, it doesn't need to
finish the AMS until the retry count reaches the limit.

Fixes: 0908c5aca31e ("usb: typec: tcpm: AMS and Collision Avoidance")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210606081452.764032-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1917,6 +1917,9 @@ static void vdm_run_state_machine(struct
 			tcpm_log(port, "VDM Tx error, retry");
 			port->vdm_retries++;
 			port->vdm_state = VDM_STATE_READY;
+			if (PD_VDO_SVDM(vdo_hdr) && PD_VDO_CMDT(vdo_hdr) == CMDT_INIT)
+				tcpm_ams_finish(port);
+		} else {
 			tcpm_ams_finish(port);
 		}
 		break;


