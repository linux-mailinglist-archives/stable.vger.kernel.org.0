Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449A73961B0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhEaOpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhEaOlb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:41:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2016961C69;
        Mon, 31 May 2021 13:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469203;
        bh=jFKVi9XL6ixV0hbqfoPYTOQJnIaF9QxvbHICEOH5Dn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltHowRXi9PDEigMVmg4ePToab6FNMgbwipF316mNLvz9+tZXfZLmIm08Zpvi5/CHk
         2rcfZdnOt8wqNkKGWAJT1EtubmkKap8XdTcJZUuYkbPZd6h+OO8cSnCrU9k7y58soj
         SRmBX9Ws0UxGnMGhbSCNl64D+VR27e8BIdadkxbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kyle Tso <kyletso@google.com>
Subject: [PATCH 5.12 109/296] usb: typec: tcpm: Respond Not_Supported if no snk_vdo
Date:   Mon, 31 May 2021 15:12:44 +0200
Message-Id: <20210531130707.603616914@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

commit a20dcf53ea9836387b229c4878f9559cf1b55b71 upstream.

If snk_vdo is not populated from fwnode, it implies the port does not
support responding to SVDM commands. Not_Supported Message shall be sent
if the contract is in PD3. And for PD2, the port shall ignore the
commands.

Fixes: 193a68011fdc ("staging: typec: tcpm: Respond to Discover Identity commands")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210523015855.1785484-3-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2410,7 +2410,10 @@ static void tcpm_pd_data_request(struct
 					   NONE_AMS);
 		break;
 	case PD_DATA_VENDOR_DEF:
-		tcpm_handle_vdm_request(port, msg->payload, cnt);
+		if (tcpm_vdm_ams(port) || port->nr_snk_vdo)
+			tcpm_handle_vdm_request(port, msg->payload, cnt);
+		else if (port->negotiated_rev > PD_REV20)
+			tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
 		break;
 	case PD_DATA_BIST:
 		port->bist_request = le32_to_cpu(msg->payload[0]);


