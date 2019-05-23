Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B06279E7
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 11:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbfEWJ6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 05:58:17 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60145 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729762AbfEWJ6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 05:58:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 02E04354F2;
        Thu, 23 May 2019 05:58:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 05:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rBIEyl
        /8iLHBH3hF00HUp5y/tAyl7MlZxfrpXM86rUw=; b=aTJePot5KYNrJQt9CPbaI/
        bj4EfAZ8OqSYfpPKn4Vck4vQ9JK2d5VH43MMhk1oI7H6HS5YdCoGUsxVxx7fghiz
        Uzngz3b01dmOycAC3e2RY5f4uW3erS8WVY2gKE2CAVZaIr56eYHAk9hRpROHb2d9
        SxVauftVsHts5TtGDWEm3mC0Z12ckl4RncKxiRofGe7n0Dzbep4QVW/F9cZJtnf7
        BWG6ZleEjGgxyA9LBOPHsEQ3qkYVekCqt5rdgSOA5cWdC2IITblyRg0wnAq1LDmS
        gVqMdF3eAY5OI/oCW+Vwo8VIuHIud0zMJ8H5OqiRIbN8Ojpq3S0UhND4oT0wTEZg
        ==
X-ME-Sender: <xms:t27mXE7rPUJOV5AF8tqXj4bD0qSSHihvZ9bR8959urjrVn0rkFu9oQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:t27mXMbjGsu6x3yVOHA3ad_2n3sYtup30qrb2NrWhAg41dZORKLM7A>
    <xmx:t27mXBfqiOq-ArC-1K_QqTX0RSBTYd9EafwQJbxYI67-B9IWBI6dQA>
    <xmx:t27mXL6heqtn8cXJr6s8L_780-7XaGPvcBpn9_8as4Kok5wa1xcUoQ>
    <xmx:t27mXK5GRY6vUI1WrUYQ4PVRE14nQV8GNcKb8lo0Tmr0xOjEcCj_GQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65A8380062;
        Thu, 23 May 2019 05:58:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] stm class: Fix channel bitmap on 32-bit systems" failed to apply to 4.4-stable tree
To:     alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org,
        muluhe@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 11:58:06 +0200
Message-ID: <1558605486248167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 51e0f227812ed81a368de54157ebe14396b4be03 Mon Sep 17 00:00:00 2001
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Date: Wed, 17 Apr 2019 10:35:35 +0300
Subject: [PATCH] stm class: Fix channel bitmap on 32-bit systems

Commit 7bd1d4093c2f ("stm class: Introduce an abstraction for System Trace
Module devices") naively calculates the channel bitmap size in 64-bit
chunks regardless of the size of underlying unsigned long, making the
bitmap half as big on a 32-bit system. This leads to an out of bounds
access with the upper half of the bitmap.

Fix this by using BITS_TO_LONGS. While at it, convert to using
struct_size() for the total size calculation of the master struct.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Fixes: 7bd1d4093c2f ("stm class: Introduce an abstraction for System Trace Module devices")
Reported-by: Mulu He <muluhe@codeaurora.org>
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index 5b5807cbcf7c..e55b902560de 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -166,11 +166,10 @@ stm_master(struct stm_device *stm, unsigned int idx)
 static int stp_master_alloc(struct stm_device *stm, unsigned int idx)
 {
 	struct stp_master *master;
-	size_t size;
 
-	size = ALIGN(stm->data->sw_nchannels, 8) / 8;
-	size += sizeof(struct stp_master);
-	master = kzalloc(size, GFP_ATOMIC);
+	master = kzalloc(struct_size(master, chan_map,
+				     BITS_TO_LONGS(stm->data->sw_nchannels)),
+			 GFP_ATOMIC);
 	if (!master)
 		return -ENOMEM;
 

