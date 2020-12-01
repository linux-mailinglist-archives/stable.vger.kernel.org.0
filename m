Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E5A2C9C61
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389538AbgLAJRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389536AbgLAJLm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:11:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 300FB20671;
        Tue,  1 Dec 2020 09:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813880;
        bh=zD6wCW7jEzn8ryTtSSvwutuQXC+qVdXkoN53FJ3PHX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMlKzlw8CARX/epDR6SmYEkcwwZtIQdTtuj7dZGpTbhD7IscNFPumL8JWIRsFCOVg
         9maeijT2jGsbCaILm9IMG151nSgDE3QSuDKWYFRs/se6v5MQbbsGtSTbO+yxG3wIbY
         TQ9XQF6FxALHpj4admOLY3DyRvIH9UzeXz44vLSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 092/152] block/keyslot-manager: prevent crash when num_slots=1
Date:   Tue,  1 Dec 2020 09:53:27 +0100
Message-Id: <20201201084723.921696550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 47a846536e1bf62626f1c0d8488f3718ce5f8296 ]

If there is only one keyslot, then blk_ksm_init() computes
slot_hashtable_size=1 and log_slot_ht_size=0.  This causes
blk_ksm_find_keyslot() to crash later because it uses
hash_ptr(key, log_slot_ht_size) to find the hash bucket containing the
key, and hash_ptr() doesn't support the bits == 0 case.

Fix this by making the hash table always have at least 2 buckets.

Tested by running:

    kvm-xfstests -c ext4 -g encrypt -m inlinecrypt \
                 -o blk-crypto-fallback.num_keyslots=1

Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/keyslot-manager.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
index 35abcb1ec051d..86f8195d8039e 100644
--- a/block/keyslot-manager.c
+++ b/block/keyslot-manager.c
@@ -103,6 +103,13 @@ int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots)
 	spin_lock_init(&ksm->idle_slots_lock);
 
 	slot_hashtable_size = roundup_pow_of_two(num_slots);
+	/*
+	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
+	 * buckets.  This only makes a difference when there is only 1 keyslot.
+	 */
+	if (slot_hashtable_size < 2)
+		slot_hashtable_size = 2;
+
 	ksm->log_slot_ht_size = ilog2(slot_hashtable_size);
 	ksm->slot_hashtable = kvmalloc_array(slot_hashtable_size,
 					     sizeof(ksm->slot_hashtable[0]),
-- 
2.27.0



