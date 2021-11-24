Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C04645C650
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354217AbhKXOGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350650AbhKXOEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 439676333A;
        Wed, 24 Nov 2021 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759502;
        bh=bq63Sw2Z8ROOhThbXGprlxY8HUTF1QBWNtKW608PWT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHoyiqsW2qDYM1Ep5oaaM+gokoKdo2HvWzshlyE3I6vQsgXqS0r1xBHzgESrNEr2n
         E4Cj2+Be+l1X0afkVMw3O/ZGJx8fFKjtlj+d69qaCmR9rZZtDHvaH4v0cRuxCN4pKH
         xaWcb8Kr3TrzUXbJ2vk8bnI0DnzxoHOq4ZAZA7CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baihua Lu <baihua.lu@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.15 231/279] Drivers: hv: balloon: Use VMBUS_RING_SIZE() wrapper for dm_ring_size
Date:   Wed, 24 Nov 2021 12:58:38 +0100
Message-Id: <20211124115726.722941546@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

commit 8a7eb2d476c6823cd44d8c25a6230a52417d7ef8 upstream.

Baihua reported an error when boot an ARM64 guest with PAGE_SIZE=64k and
BALLOON is enabled:

	hv_vmbus: registering driver hv_balloon
	hv_vmbus: probe failed for device 1eccfd72-4b41-45ef-b73a-4a6e44c12924 (-22)

The cause of this is that the ringbuffer size for hv_balloon is not
adjusted with VMBUS_RING_SIZE(), which makes the size not large enough
for ringbuffers on guest with PAGE_SIZE=64k. Therefore use
VMBUS_RING_SIZE() to calculate the ringbuffer size. Note that the old
size (20 * 1024) counts a 4k header in the total size, while
VMBUS_RING_SIZE() expects the parameter as the payload size, so use
16 * 1024.

Cc: <stable@vger.kernel.org> # 5.15.x
Reported-by: Baihua Lu <baihua.lu@microsoft.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20211101150026.736124-1-boqun.feng@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/hv_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -480,7 +480,7 @@ module_param(pressure_report_delay, uint
 MODULE_PARM_DESC(pressure_report_delay, "Delay in secs in reporting pressure");
 static atomic_t trans_id = ATOMIC_INIT(0);
 
-static int dm_ring_size = 20 * 1024;
+static int dm_ring_size = VMBUS_RING_SIZE(16 * 1024);
 
 /*
  * Driver specific state.


