Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558963EDCDD
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 20:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhHPSKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 14:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhHPSKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 14:10:12 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19078C0613CF
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:09:26 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id b15so33308111ejg.10
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XB1c9ILEXbIGeaE3RF5LyGrxlHfkgsii4y9hKMpsOPM=;
        b=VI1nmQkVG9NF54oMFgNJaqs5PhqOMtqHWzhdyKt7ZAMvAl0yGfSkwqBzm9DlrffV23
         bFTG6mfUKjXFNG+jeKYDqnUpo5wpC8LQLgOZiMAclB91e9HEq90AmJe1Iw5wECEbi2fz
         KP6D7OnyxyBdVA0EvS/foCMdBVcWyQzV+W20KsHYVB9uBEtQ5G8rpabyib+7/n1z5Pwx
         cyyigDW1h/ctrNXOV9HxGMbF7NQXcMQZLyIoXzwh0q2DBo7QtfOhhq17HvRM5+x/UGUt
         sDJrW1kp7zyyq2WuMqggLoFNWJCguBYgMsRk6MTax4VzZOnIYxuieH07wCV3xRzljCkB
         SRlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XB1c9ILEXbIGeaE3RF5LyGrxlHfkgsii4y9hKMpsOPM=;
        b=dnIJF3sL4S0B62Owcf6M+ag9waGVmrkVzLdktNRCxa9DoMwJw7agVw3WLF8twTQlBZ
         P6XENn5wlc6fsu27d8Y9ABdsOgRlUAWIGuSqVaK1fJppZqMIyaHAAVRixQtsj3edgbwm
         t+4wOGLUj0NgjrqtJRmo5cs1b2HZQiS15Fz0xUj44ZTOfK5M3BuJ2p9OQPJFBhx6rJdA
         rJ3MBARnF327DMv50bLJGZ+dFiydobxj2RYBD5Wb5+6uT33Y8lVsplY1JAdGVAvPvl1Q
         +4xOSMfKGBlK/I7vcAE3/fqsE3HMTNGOydgeD5iWJnh22Gel8uefDMG78Bs4oMvhHa1a
         CmAA==
X-Gm-Message-State: AOAM531rBmN6nTFsrbFP1FYo9NSPnhGT5iQnR30L9dB8kuVTDerAX6D0
        Eb8KBX7zV3RH07X1jB47UhsRSQ==
X-Google-Smtp-Source: ABdhPJzCZ7DRGE8vLgBrbRafZo3Y06XGncpHZbIwrh/pRl8HaApv3MofBKSkpLDgVmnLRhLnOAKhgA==
X-Received: by 2002:a17:906:26c1:: with SMTP id u1mr15242796ejc.491.1629137364653;
        Mon, 16 Aug 2021 11:09:24 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id fl2sm3916370ejc.114.2021.08.16.11.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 11:09:24 -0700 (PDT)
Date:   Mon, 16 Aug 2021 20:09:22 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 2/5] net: dsa: microchip: ksz8795: Fix PVID tag insertion
Message-ID: <20210816180921.GF18930@cephalopod>
References: <20210816174905.GD18930@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816174905.GD18930@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ef3b02a1d79b691f9a354c4903cf1e6917e315f9 upstream.

ksz8795 has never actually enabled PVID tag insertion, and it also
programmed the PVID incorrectly.  To fix this:

* Allow tag insertion to be controlled per ingress port.  On most
  chips, set bit 2 in Global Control 19.  On KSZ88x3 this control
  flag doesn't exist.

* When adding a PVID:
  - Set the appropriate register bits to enable tag insertion on
    egress at every other port if this was the packet's ingress port.
  - Mask *out* the VID from the default tag, before or-ing in the new
    PVID.

* When removing a PVID:
  - Clear the same control bits to disable tag insertion.
  - Don't update the default tag.  This wasn't doing anything useful.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backport to 5.10:
 - Drop the KSZ88x3 cases as those chips are not supported here
 - Handle VID ranges in ksz8795_port_vlan_del()]
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz8795.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 108a14db1f1a..3d36ffff1f4e 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -833,9 +833,11 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
 
 	if (new_pvid) {
 		ksz_pread16(dev, port, REG_PORT_CTRL_VID, &vid);
-		vid &= 0xfff;
+		vid &= ~VLAN_VID_MASK;
 		vid |= new_pvid;
 		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, vid);
+
+		ksz_pwrite8(dev, port, REG_PORT_CTRL_12, 0x0f);
 	}
 }
 
@@ -844,8 +846,9 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_device *dev = ds->priv;
-	u16 data, vid, pvid, new_pvid = 0;
+	u16 data, vid, pvid;
 	u8 fid, member, valid;
+	bool del_pvid = false;
 
 	ksz_pread16(dev, port, REG_PORT_CTRL_VID, &pvid);
 	pvid = pvid & 0xFFF;
@@ -865,14 +868,14 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int port,
 		}
 
 		if (pvid == vid)
-			new_pvid = 1;
+			del_pvid = true;
 
 		ksz8795_to_vlan(fid, member, valid, &data);
 		ksz8795_w_vlan_table(dev, vid, data);
 	}
 
-	if (new_pvid != pvid)
-		ksz_pwrite16(dev, port, REG_PORT_CTRL_VID, pvid);
+	if (del_pvid)
+		ksz_pwrite8(dev, port, REG_PORT_CTRL_12, 0x00);
 
 	return 0;
 }
@@ -1085,6 +1088,8 @@ static int ksz8795_setup(struct dsa_switch *ds)
 
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
 
+	ksz_cfg(dev, REG_SW_CTRL_19, SW_INS_TAG_ENABLE, true);
+
 	/* set broadcast storm protection 10% rate */
 	regmap_update_bits(dev->regmap[1], S_REPLACE_VID_CTRL,
 			   BROADCAST_STORM_RATE,
-- 
2.20.1

