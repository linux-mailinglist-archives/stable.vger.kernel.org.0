Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A8D396057
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhEaOZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232768AbhEaOXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 840E96141E;
        Mon, 31 May 2021 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468733;
        bh=cmvl3lmxDmIROeHOoE0A5c/xC3Cp4aQM9DxioMsIpKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vf/AM1fO8GvhIOvrRsZ4sbdfzmgHSaE+33lhuEIPQVXdGjDU47RcqwKV8QgMG0v94
         /KylkK4zzzhS7EX3dei4AWU4Dc22CfV4nM6T8qO7+Bre6gxieRHwSQSV3YF7gmvQU0
         0ANJrCCb4gbebRPFp/YbAzRR+B9MWbqUjNj+w3mY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 106/177] isdn: mISDN: correctly handle ph_info allocation failure in hfcsusb_ph_info
Date:   Mon, 31 May 2021 15:14:23 +0200
Message-Id: <20210531130651.569751086@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 5265db2ccc735e2783b790d6c19fb5cee8c025ed ]

Modify return type of hfcusb_ph_info to int, so that we can pass error
value up the call stack when allocation of ph_info fails. Also change
three of four call sites to actually account for the memory failure.
The fourth, in ph_state_nt, is infeasible to change as it is in turn
called by ph_state which is used as a function pointer argument to
mISDN_initdchannel, which would necessitate changing its signature
and updating all the places where it is used (too many).

Fixes original flawed commit (38d22659803a) from the University of
Minnesota.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210503115736.2104747-48-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 7a051435c406..1f89378b5623 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -46,7 +46,7 @@ static void hfcsusb_start_endpoint(struct hfcsusb *hw, int channel);
 static void hfcsusb_stop_endpoint(struct hfcsusb *hw, int channel);
 static int  hfcsusb_setup_bch(struct bchannel *bch, int protocol);
 static void deactivate_bchannel(struct bchannel *bch);
-static void hfcsusb_ph_info(struct hfcsusb *hw);
+static int  hfcsusb_ph_info(struct hfcsusb *hw);
 
 /* start next background transfer for control channel */
 static void
@@ -241,7 +241,7 @@ hfcusb_l2l1B(struct mISDNchannel *ch, struct sk_buff *skb)
  * send full D/B channel status information
  * as MPH_INFORMATION_IND
  */
-static void
+static int
 hfcsusb_ph_info(struct hfcsusb *hw)
 {
 	struct ph_info *phi;
@@ -249,6 +249,9 @@ hfcsusb_ph_info(struct hfcsusb *hw)
 	int i;
 
 	phi = kzalloc(struct_size(phi, bch, dch->dev.nrbchan), GFP_ATOMIC);
+	if (!phi)
+		return -ENOMEM;
+
 	phi->dch.ch.protocol = hw->protocol;
 	phi->dch.ch.Flags = dch->Flags;
 	phi->dch.state = dch->state;
@@ -261,6 +264,8 @@ hfcsusb_ph_info(struct hfcsusb *hw)
 		    sizeof(struct ph_info_dch) + dch->dev.nrbchan *
 		    sizeof(struct ph_info_ch), phi, GFP_ATOMIC);
 	kfree(phi);
+
+	return 0;
 }
 
 /*
@@ -345,8 +350,7 @@ hfcusb_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 			ret = l1_event(dch->l1, hh->prim);
 		break;
 	case MPH_INFORMATION_REQ:
-		hfcsusb_ph_info(hw);
-		ret = 0;
+		ret = hfcsusb_ph_info(hw);
 		break;
 	}
 
@@ -401,8 +405,7 @@ hfc_l1callback(struct dchannel *dch, u_int cmd)
 			       hw->name, __func__, cmd);
 		return -1;
 	}
-	hfcsusb_ph_info(hw);
-	return 0;
+	return hfcsusb_ph_info(hw);
 }
 
 static int
@@ -744,8 +747,7 @@ hfcsusb_setup_bch(struct bchannel *bch, int protocol)
 			handle_led(hw, (bch->nr == 1) ? LED_B1_OFF :
 				   LED_B2_OFF);
 	}
-	hfcsusb_ph_info(hw);
-	return 0;
+	return hfcsusb_ph_info(hw);
 }
 
 static void
-- 
2.30.2



