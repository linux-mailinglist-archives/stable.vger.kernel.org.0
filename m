Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37403F6458
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238822AbhHXRDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238961AbhHXRBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:01:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBFBA617E1;
        Tue, 24 Aug 2021 16:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824277;
        bh=RgOCeAmK5c7mi0zdARVtH07cFgrer3l44b+B8Ky/N2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEnOpEZ5xk+CO7iN+eY2zi4W1+P8Lc/46vr6PsYWIrKBDmdDh2nR2j54MIjP6PCCU
         vnoxH46fhf9fgjoyugOSu1HI8Nx529hyp+X4skisdUR921cJXFZQmJhsaCn9Gef/Dh
         B9Is5sayj2C/kXWiNanY+tz0YhiLPAxM5JX0vZA2aaioE6SmaWlpRlW4jUxux/JkZw
         HCtptEnKBj9TX+elt5YUaRYyw9olOLgVjmD+fpaf+vTBkvkR2abvm2c/jR8NBUVqYw
         aLrSIvQ71VLeERBAaxs+yIxYpyIeXULEf1oEXxVcjdpK0+GPYx9AHn3qOWRQ6a446c
         4i8jcUmBCQj6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, Kyle Tso <kyletso@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 112/127] usb: typec: tcpm: Fix VDMs sometimes not being forwarded to alt-mode drivers
Date:   Tue, 24 Aug 2021 12:55:52 -0400
Message-Id: <20210824165607.709387-113-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5571ea3117ca22849072adb58074fb5a2fd12c00 ]

Commit a20dcf53ea98 ("usb: typec: tcpm: Respond Not_Supported if no
snk_vdo"), stops tcpm_pd_data_request() calling tcpm_handle_vdm_request()
when port->nr_snk_vdo is not set. But the VDM might be intended for an
altmode-driver, in which case nr_snk_vdo does not matter.

This change breaks the forwarding of connector hotplug (HPD) events
for displayport altmode on devices which don't set nr_snk_vdo.

tcpm_pd_data_request() is the only caller of tcpm_handle_vdm_request(),
so we can move the nr_snk_vdo check to inside it, at which point we
have already looked up the altmode device so we can check for this too.

Doing this check here also ensures that vdm_state gets set to
VDM_STATE_DONE if it was VDM_STATE_BUSY, even if we end up with
responding with PD_MSG_CTRL_NOT_SUPP later.

Note that tcpm_handle_vdm_request() was already sending
PD_MSG_CTRL_NOT_SUPP in some circumstances, after moving the nr_snk_vdo
check the same error-path is now taken when that check fails. So that
we have only one error-path for this and not two. Replace the
tcpm_queue_message(PD_MSG_CTRL_NOT_SUPP) used by the existing error-path
with the more robust tcpm_pd_handle_msg() from the (now removed) second
error-path.

Fixes: a20dcf53ea98 ("usb: typec: tcpm: Respond Not_Supported if no snk_vdo")
Cc: stable <stable@vger.kernel.org>
Cc: Kyle Tso <kyletso@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Kyle Tso <kyletso@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210816154632.381968-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 426e37a1e78c..1b886d80ba1c 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1709,6 +1709,10 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 	return rlen;
 }
 
+static void tcpm_pd_handle_msg(struct tcpm_port *port,
+			       enum pd_msg_request message,
+			       enum tcpm_ams ams);
+
 static void tcpm_handle_vdm_request(struct tcpm_port *port,
 				    const __le32 *payload, int cnt)
 {
@@ -1736,11 +1740,11 @@ static void tcpm_handle_vdm_request(struct tcpm_port *port,
 		port->vdm_state = VDM_STATE_DONE;
 	}
 
-	if (PD_VDO_SVDM(p[0])) {
+	if (PD_VDO_SVDM(p[0]) && (adev || tcpm_vdm_ams(port) || port->nr_snk_vdo)) {
 		rlen = tcpm_pd_svdm(port, adev, p, cnt, response, &adev_action);
 	} else {
 		if (port->negotiated_rev >= PD_REV30)
-			tcpm_queue_message(port, PD_MSG_CTRL_NOT_SUPP);
+			tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
 	}
 
 	/*
@@ -2443,10 +2447,7 @@ static void tcpm_pd_data_request(struct tcpm_port *port,
 					   NONE_AMS);
 		break;
 	case PD_DATA_VENDOR_DEF:
-		if (tcpm_vdm_ams(port) || port->nr_snk_vdo)
-			tcpm_handle_vdm_request(port, msg->payload, cnt);
-		else if (port->negotiated_rev > PD_REV20)
-			tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
+		tcpm_handle_vdm_request(port, msg->payload, cnt);
 		break;
 	case PD_DATA_BIST:
 		port->bist_request = le32_to_cpu(msg->payload[0]);
-- 
2.30.2

