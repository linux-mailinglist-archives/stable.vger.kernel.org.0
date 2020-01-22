Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A23B144F76
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732393AbgAVJiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732861AbgAVJiF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:38:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C3AF2467F;
        Wed, 22 Jan 2020 09:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685884;
        bh=Rlka6QsD7cuOhT3QEuTFp25l9TRE6qb5THyJ9TzS5C0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZ/UuaPcMJsdA7z1dKlB0hH84xBTpfkf/caw5/bJXgKeK47HQZJ+wMMsNyRekUCJw
         samAx86E5ID4UFigLr9Mrd2d3kfdlFaj17pCXWtc3hx6cnZ3qyL3gWvC839ksRnK2B
         GONnR8vsuqoAwajEA+GffGk8haFzextrol/sOI9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keiya Nobuta <nobuta.keiya@fujitsu.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.14 21/65] usb: core: hub: Improved device recognition on remote wakeup
Date:   Wed, 22 Jan 2020 10:29:06 +0100
Message-Id: <20200122092754.100033239@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keiya Nobuta <nobuta.keiya@fujitsu.com>

commit 9c06ac4c83df6d6fbdbf7488fbad822b4002ba19 upstream.

If hub_activate() is called before D+ has stabilized after remote
wakeup, the following situation might occur:

         __      ___________________
        /  \    /
D+   __/    \__/

Hub  _______________________________
          |  ^   ^           ^
          |  |   |           |
Host _____v__|___|___________|______
          |  |   |           |
          |  |   |           \-- Interrupt Transfer (*3)
          |  |    \-- ClearPortFeature (*2)
          |   \-- GetPortStatus (*1)
          \-- Host detects remote wakeup

- D+ goes high, Host starts running by remote wakeup
- D+ is not stable, goes low
- Host requests GetPortStatus at (*1) and gets the following hub status:
  - Current Connect Status bit is 0
  - Connect Status Change bit is 1
- D+ stabilizes, goes high
- Host requests ClearPortFeature and thus Connect Status Change bit is
  cleared at (*2)
- After waiting 100 ms, Host starts the Interrupt Transfer at (*3)
- Since the Connect Status Change bit is 0, Hub returns NAK.

In this case, port_event() is not called in hub_event() and Host cannot
recognize device. To solve this issue, flag change_bits even if only
Connect Status Change bit is 1 when got in the first GetPortStatus.

This issue occurs rarely because it only if D+ changes during a very
short time between GetPortStatus and ClearPortFeature. However, it is
fatal if it occurs in embedded system.

Signed-off-by: Keiya Nobuta <nobuta.keiya@fujitsu.com>
Cc: stable <stable@vger.kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20200109051448.28150-1-nobuta.keiya@fujitsu.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1164,6 +1164,7 @@ static void hub_activate(struct usb_hub
 			 * PORT_OVER_CURRENT is not. So check for any of them.
 			 */
 			if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
+			    (portchange & USB_PORT_STAT_C_CONNECTION) ||
 			    (portstatus & USB_PORT_STAT_OVERCURRENT) ||
 			    (portchange & USB_PORT_STAT_C_OVERCURRENT))
 				set_bit(port1, hub->change_bits);


