Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837512ABD89
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgKIM5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729896AbgKIM5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:57:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBDA020684;
        Mon,  9 Nov 2020 12:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926623;
        bh=SJfxIJl2q4MsodwaH95fqs9gynZ3yjK70+umDhNMypI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+JLONGYnhtypmbXOKBIA7FuRZh29ow8esMX8SsFlEaTLaxYWd11J/E7IqGdrPxM8
         rzTVJy3cNJhnsweLC1AqifRFi3z/sZOBfkjRtOPwR4fvui5t6iS8gNmDp71h6sxdCq
         gLjbkVa7FWyvILwI8la6DzwxWg7RGcyFv3/aqCK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, KoWei Sung <winders@amazon.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 4.4 33/86] md/raid5: fix oops during stripe resizing
Date:   Mon,  9 Nov 2020 13:54:40 +0100
Message-Id: <20201109125022.451961167@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

commit b44c018cdf748b96b676ba09fdbc5b34fc443ada upstream.

KoWei reported crash during raid5 reshape:

[ 1032.252932] Oops: 0002 [#1] SMP PTI
[...]
[ 1032.252943] RIP: 0010:memcpy_erms+0x6/0x10
[...]
[ 1032.252947] RSP: 0018:ffffba1ac0c03b78 EFLAGS: 00010286
[ 1032.252949] RAX: 0000784ac0000000 RBX: ffff91bec3d09740 RCX: 0000000000001000
[ 1032.252951] RDX: 0000000000001000 RSI: ffff91be6781c000 RDI: 0000784ac0000000
[ 1032.252953] RBP: ffffba1ac0c03bd8 R08: 0000000000001000 R09: ffffba1ac0c03bf8
[ 1032.252954] R10: 0000000000000000 R11: 0000000000000000 R12: ffffba1ac0c03bf8
[ 1032.252955] R13: 0000000000001000 R14: 0000000000000000 R15: 0000000000000000
[ 1032.252958] FS:  0000000000000000(0000) GS:ffff91becf500000(0000) knlGS:0000000000000000
[ 1032.252959] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1032.252961] CR2: 0000784ac0000000 CR3: 000000031780a002 CR4: 00000000001606e0
[ 1032.252962] Call Trace:
[ 1032.252969]  ? async_memcpy+0x179/0x1000 [async_memcpy]
[ 1032.252977]  ? raid5_release_stripe+0x8e/0x110 [raid456]
[ 1032.252982]  handle_stripe_expansion+0x15a/0x1f0 [raid456]
[ 1032.252988]  handle_stripe+0x592/0x1270 [raid456]
[ 1032.252993]  handle_active_stripes.isra.0+0x3cb/0x5a0 [raid456]
[ 1032.252999]  raid5d+0x35c/0x550 [raid456]
[ 1032.253002]  ? schedule+0x42/0xb0
[ 1032.253006]  ? schedule_timeout+0x10e/0x160
[ 1032.253011]  md_thread+0x97/0x160
[ 1032.253015]  ? wait_woken+0x80/0x80
[ 1032.253019]  kthread+0x104/0x140
[ 1032.253022]  ? md_start_sync+0x60/0x60
[ 1032.253024]  ? kthread_park+0x90/0x90
[ 1032.253027]  ret_from_fork+0x35/0x40

This is because cache_size_mutex was unlocked too early in resize_stripes,
which races with grow_one_stripe() that grow_one_stripe() allocates a
stripe with wrong pool_size.

Fix this issue by unlocking cache_size_mutex after updating pool_size.

Cc: <stable@vger.kernel.org> # v4.4+
Reported-by: KoWei Sung <winders@amazon.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2238,8 +2238,6 @@ static int resize_stripes(struct r5conf
 	} else
 		err = -ENOMEM;
 
-	mutex_unlock(&conf->cache_size_mutex);
-
 	conf->slab_cache = sc;
 	conf->active_name = 1-conf->active_name;
 
@@ -2262,6 +2260,8 @@ static int resize_stripes(struct r5conf
 
 	if (!err)
 		conf->pool_size = newsize;
+	mutex_unlock(&conf->cache_size_mutex);
+
 	return err;
 }
 


