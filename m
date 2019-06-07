Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673923906D
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbfFGPt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732065AbfFGPt4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:49:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B3E020840;
        Fri,  7 Jun 2019 15:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922595;
        bh=2YaMuI3RJKFG5nQj8FFJEYnNadIMoqYra8uLWOutnmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vmrkIZvBvu591w60QLb9gCWuobyWcgWkR5qrFKlgzeqo+/Gl15Gn43mzey2ol7gw
         ee+aqE4SNAqWM1FrapzXMdaHx4QDFE2gBUJURKTSvGqg9z+NTzSQigYqm011yRWWCC
         KEGAveI2XJfwDns4KK4i+co1UrGc/InZcigmj0OU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 5.1 33/85] s390/crypto: fix possible sleep during spinlock aquired
Date:   Fri,  7 Jun 2019 17:39:18 +0200
Message-Id: <20190607153853.342312000@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

commit 1c2c7029c008922d4d48902cc386250502e73d51 upstream.

This patch fixes a complain about possible sleep during
spinlock aquired
"BUG: sleeping function called from invalid context at
include/crypto/algapi.h:426"
for the ctr(aes) and ctr(des) s390 specific ciphers.

Instead of using a spinlock this patch introduces a mutex
which is save to be held in sleeping context. Please note
a deadlock is not possible as mutex_trylock() is used.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/crypto/aes_s390.c |    8 ++++----
 arch/s390/crypto/des_s390.c |    7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -27,14 +27,14 @@
 #include <linux/module.h>
 #include <linux/cpufeature.h>
 #include <linux/init.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/fips.h>
 #include <linux/string.h>
 #include <crypto/xts.h>
 #include <asm/cpacf.h>
 
 static u8 *ctrblk;
-static DEFINE_SPINLOCK(ctrblk_lock);
+static DEFINE_MUTEX(ctrblk_lock);
 
 static cpacf_mask_t km_functions, kmc_functions, kmctr_functions,
 		    kma_functions;
@@ -698,7 +698,7 @@ static int ctr_aes_crypt(struct blkciphe
 	unsigned int n, nbytes;
 	int ret, locked;
 
-	locked = spin_trylock(&ctrblk_lock);
+	locked = mutex_trylock(&ctrblk_lock);
 
 	ret = blkcipher_walk_virt_block(desc, walk, AES_BLOCK_SIZE);
 	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
@@ -716,7 +716,7 @@ static int ctr_aes_crypt(struct blkciphe
 		ret = blkcipher_walk_done(desc, walk, nbytes - n);
 	}
 	if (locked)
-		spin_unlock(&ctrblk_lock);
+		mutex_unlock(&ctrblk_lock);
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -14,6 +14,7 @@
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <linux/fips.h>
+#include <linux/mutex.h>
 #include <crypto/algapi.h>
 #include <crypto/des.h>
 #include <asm/cpacf.h>
@@ -21,7 +22,7 @@
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
 
 static u8 *ctrblk;
-static DEFINE_SPINLOCK(ctrblk_lock);
+static DEFINE_MUTEX(ctrblk_lock);
 
 static cpacf_mask_t km_functions, kmc_functions, kmctr_functions;
 
@@ -387,7 +388,7 @@ static int ctr_desall_crypt(struct blkci
 	unsigned int n, nbytes;
 	int ret, locked;
 
-	locked = spin_trylock(&ctrblk_lock);
+	locked = mutex_trylock(&ctrblk_lock);
 
 	ret = blkcipher_walk_virt_block(desc, walk, DES_BLOCK_SIZE);
 	while ((nbytes = walk->nbytes) >= DES_BLOCK_SIZE) {
@@ -404,7 +405,7 @@ static int ctr_desall_crypt(struct blkci
 		ret = blkcipher_walk_done(desc, walk, nbytes - n);
 	}
 	if (locked)
-		spin_unlock(&ctrblk_lock);
+		mutex_unlock(&ctrblk_lock);
 	/* final block may be < DES_BLOCK_SIZE, copy only nbytes */
 	if (nbytes) {
 		cpacf_kmctr(fc, ctx->key, buf, walk->src.virt.addr,


