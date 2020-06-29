Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E584E20E757
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391605AbgF2V4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgF2Sfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5391B24688;
        Mon, 29 Jun 2020 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443984;
        bh=B6B7CbmE1beGD7a0XoTWkaxDA7EpKHPavxaZ8XF46Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qnu+SUqFuA5dU8DNBa4oZ8bctBrdorWb5RuEAUSvJht2ljfaoD0Rm5Ejp1rG3qZ0m
         na/oRj5n2w3/tOlBEfKpcea+uZDkdUs5uMRe5uaX50eCkzsqs6+jKMlAJRJLTvmPxj
         kEdjBhKA7a/Ea9Lj+WhL3UPUxPiTox8GdQaVRUFc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Tjernlund <joakim.tjernlund@infinera.com>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 089/265] cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip
Date:   Mon, 29 Jun 2020 11:15:22 -0400
Message-Id: <20200629151818.2493727-90-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Tjernlund <joakim.tjernlund@infinera.com>

commit 03894573f2913181ee5aae0089f333b2131f2d4b upstream.

USB_DEVICE(0x0424, 0x274e) can send data before cdc_acm is ready,
causing garbage chars on the TTY causing stray input to the shell
and/or login prompt.

Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
Cc: stable@vger.kernel.org
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20200605105418.22263-1-joakim.tjernlund@infinera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index f67088bb8218b..d5187b50fc828 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1689,6 +1689,8 @@ static int acm_pre_reset(struct usb_interface *intf)
 
 static const struct usb_device_id acm_ids[] = {
 	/* quirky and broken devices */
+	{ USB_DEVICE(0x0424, 0x274e), /* Microchip Technology, Inc. (formerly SMSC) */
+	  .driver_info = DISABLE_ECHO, }, /* DISABLE ECHO in termios flag */
 	{ USB_DEVICE(0x076d, 0x0006), /* Denso Cradle CU-321 */
 	.driver_info = NO_UNION_NORMAL, },/* has no union descriptor */
 	{ USB_DEVICE(0x17ef, 0x7000), /* Lenovo USB modem */
-- 
2.25.1

