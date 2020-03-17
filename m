Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 097ED1881C8
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgCQLBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbgCQLBe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:01:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FABB20714;
        Tue, 17 Mar 2020 11:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442893;
        bh=8uwcB0a5h135Fq5P9GABR6dpo+buG43nmj8LlySZ18M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whh5+BVPMkzg2c9XwbP99Bt1jf9f8MAw+ni7M71gTFtygA63RkTsbahjNjBGTc36k
         cKcaHsAAK+wei1KDRDOdf1ja9za+eeKSjV+UKIncIrRxls5G+arzSFiYT03c5kF4aV
         gUP6M8a1dBnomOvSN5hYgWk/H0SgBXdr12Lw6Yhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, You-Sheng Yang <vicamo.yang@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 026/123] r8152: check disconnect status after long sleep
Date:   Tue, 17 Mar 2020 11:54:13 +0100
Message-Id: <20200317103310.483532784@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: You-Sheng Yang <vicamo.yang@canonical.com>

[ Upstream commit d64c7a08034b32c285e576208ae44fc3ba3fa7df ]

Dell USB Type C docking WD19/WD19DC attaches additional peripherals as:

  /: Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/6p, 5000M
      |__ Port 1: Dev 11, If 0, Class=Hub, Driver=hub/4p, 5000M
          |__ Port 3: Dev 12, If 0, Class=Hub, Driver=hub/4p, 5000M
          |__ Port 4: Dev 13, If 0, Class=Vendor Specific Class,
              Driver=r8152, 5000M

where usb 2-1-3 is a hub connecting all USB Type-A/C ports on the dock.

When hotplugging such dock with additional usb devices already attached on
it, the probing process may reset usb 2.1 port, therefore r8152 ethernet
device is also reset. However, during r8152 device init there are several
for-loops that, when it's unable to retrieve hardware registers due to
being disconnected from USB, may take up to 14 seconds each in practice,
and that has to be completed before USB may re-enumerate devices on the
bus. As a result, devices attached to the dock will only be available
after nearly 1 minute after the dock was plugged in:

  [ 216.388290] [250] r8152 2-1.4:1.0: usb_probe_interface
  [ 216.388292] [250] r8152 2-1.4:1.0: usb_probe_interface - got id
  [ 258.830410] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): PHY not ready
  [ 258.830460] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): Invalid header when reading pass-thru MAC addr
  [ 258.830464] r8152 2-1.4:1.0 (unnamed net_device) (uninitialized): Get ether addr fail

This happens in, for example, r8153_init:

  static int generic_ocp_read(struct r8152 *tp, u16 index, u16 size,
			    void *data, u16 type)
  {
    if (test_bit(RTL8152_UNPLUG, &tp->flags))
      return -ENODEV;
    ...
  }

  static u16 ocp_read_word(struct r8152 *tp, u16 type, u16 index)
  {
    u32 data;
    ...
    generic_ocp_read(tp, index, sizeof(tmp), &tmp, type | byen);

    data = __le32_to_cpu(tmp);
    ...
    return (u16)data;
  }

  static void r8153_init(struct r8152 *tp)
  {
    ...
    if (test_bit(RTL8152_UNPLUG, &tp->flags))
      return;

    for (i = 0; i < 500; i++) {
      if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
          AUTOLOAD_DONE)
        break;
      msleep(20);
    }
    ...
  }

Since ocp_read_word() doesn't check the return status of
generic_ocp_read(), and the only exit condition for the loop is to have
a match in the returned value, such loops will only ends after exceeding
its maximum runs when the device has been marked as disconnected, which
takes 500 * 20ms = 10 seconds in theory, 14 in practice.

To solve this long latency another test to RTL8152_UNPLUG flag should be
added after those 20ms sleep to skip unnecessary loops, so that the device
probe can complete early and proceed to parent port reset/reprobe process.

This can be reproduced on all kernel versions up to latest v5.6-rc2, but
after v5.5-rc7 the reproduce rate is dramatically lowered to 1/30 or less
while it was around 1/2.

Signed-off-by: You-Sheng Yang <vicamo.yang@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3006,6 +3006,8 @@ static u16 r8153_phy_status(struct r8152
 		}
 
 		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
 	return data;
@@ -4419,7 +4421,10 @@ static void r8153_init(struct r8152 *tp)
 		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
 		    AUTOLOAD_DONE)
 			break;
+
 		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
 	data = r8153_phy_status(tp, 0);
@@ -4545,7 +4550,10 @@ static void r8153b_init(struct r8152 *tp
 		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
 		    AUTOLOAD_DONE)
 			break;
+
 		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
 	data = r8153_phy_status(tp, 0);


