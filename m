Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230F38DA4B
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731029AbfHNROJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731023AbfHNROI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 044A12063F;
        Wed, 14 Aug 2019 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802848;
        bh=9J/hVlocitOzGgJbVxHih96oSCV/jmUgFFqrsAWV2aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8meYCjttmB6wmApiI60hfpHkJyuNEkp0MIGhTJNAALJmKEJ+iiiVPpqEnKiStn6g
         oL8sSWZ0wzztwCrj5aLWv9HI69ve2TmbjaPqO7PCm6pzUPkfFs/iksS/V99S069clu
         rM0SajkKL7lG3Tt6wtHiD5dOlX1WaHr2c3zMQtwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Roland Kammerer <roland.kammerer@linbit.com>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 42/69] drbd: dynamically allocate shash descriptor
Date:   Wed, 14 Aug 2019 19:01:40 +0200
Message-Id: <20190814165748.230767321@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 77ce56e2bfaa64127ae5e23ef136c0168b818777 ]

Building with clang and KASAN, we get a warning about an overly large
stack frame on 32-bit architectures:

drivers/block/drbd/drbd_receiver.c:921:31: error: stack frame size of 1280 bytes in function 'conn_connect'
      [-Werror,-Wframe-larger-than=]

We already allocate other data dynamically in this function, so
just do the same for the shash descriptor, which makes up most of
this memory.

Link: https://lore.kernel.org/lkml/20190617132440.2721536-1-arnd@arndb.de/
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Roland Kammerer <roland.kammerer@linbit.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_receiver.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1aad373da50e2..8fbdfaacc2226 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -5237,7 +5237,7 @@ static int drbd_do_auth(struct drbd_connection *connection)
 	unsigned int key_len;
 	char secret[SHARED_SECRET_MAX]; /* 64 byte */
 	unsigned int resp_size;
-	SHASH_DESC_ON_STACK(desc, connection->cram_hmac_tfm);
+	struct shash_desc *desc;
 	struct packet_info pi;
 	struct net_conf *nc;
 	int err, rv;
@@ -5250,6 +5250,13 @@ static int drbd_do_auth(struct drbd_connection *connection)
 	memcpy(secret, nc->shared_secret, key_len);
 	rcu_read_unlock();
 
+	desc = kmalloc(sizeof(struct shash_desc) +
+		       crypto_shash_descsize(connection->cram_hmac_tfm),
+		       GFP_KERNEL);
+	if (!desc) {
+		rv = -1;
+		goto fail;
+	}
 	desc->tfm = connection->cram_hmac_tfm;
 	desc->flags = 0;
 
@@ -5392,7 +5399,10 @@ static int drbd_do_auth(struct drbd_connection *connection)
 	kfree(peers_ch);
 	kfree(response);
 	kfree(right_response);
-	shash_desc_zero(desc);
+	if (desc) {
+		shash_desc_zero(desc);
+		kfree(desc);
+	}
 
 	return rv;
 }
-- 
2.20.1



