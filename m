Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C245DC91F2
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfJBTMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:12:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35406 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729110AbfJBTIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-000368-P0; Wed, 02 Oct 2019 20:08:06 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003cf-0J; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Julian Wiedmann" <jwi@linux.ibm.com>,
        "Harald Freudenberger" <freude@linux.ibm.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.71050877@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 35/87] s390/crypto: fix possible sleep during
 spinlock aquired
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
[bwh: Backported to 3.16:
 - Replace spin_unlock() on all exit paths
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -25,7 +25,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include "crypt_s390.h"
 
 #define AES_KEYLEN_128		1
@@ -33,7 +33,7 @@
 #define AES_KEYLEN_256		4
 
 static u8 *ctrblk;
-static DEFINE_SPINLOCK(ctrblk_lock);
+static DEFINE_MUTEX(ctrblk_lock);
 static char keylen_flag;
 
 struct s390_aes_ctx {
@@ -785,7 +785,7 @@ static int ctr_aes_crypt(struct blkciphe
 	if (!walk->nbytes)
 		return ret;
 
-	if (spin_trylock(&ctrblk_lock))
+	if (mutex_trylock(&ctrblk_lock))
 		ctrptr = ctrblk;
 
 	memcpy(ctrptr, walk->iv, AES_BLOCK_SIZE);
@@ -801,7 +801,7 @@ static int ctr_aes_crypt(struct blkciphe
 					       n, ctrptr);
 			if (ret < 0 || ret != n) {
 				if (ctrptr == ctrblk)
-					spin_unlock(&ctrblk_lock);
+					mutex_unlock(&ctrblk_lock);
 				return -EIO;
 			}
 			if (n > AES_BLOCK_SIZE)
@@ -819,7 +819,7 @@ static int ctr_aes_crypt(struct blkciphe
 			memcpy(ctrbuf, ctrptr, AES_BLOCK_SIZE);
 		else
 			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
-		spin_unlock(&ctrblk_lock);
+		mutex_unlock(&ctrblk_lock);
 	} else {
 		if (!nbytes)
 			memcpy(walk->iv, ctrptr, AES_BLOCK_SIZE);
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
+#include <linux/mutex.h>
 #include <crypto/algapi.h>
 #include <crypto/des.h>
 
@@ -25,7 +26,7 @@
 #define DES3_KEY_SIZE	(3 * DES_KEY_SIZE)
 
 static u8 *ctrblk;
-static DEFINE_SPINLOCK(ctrblk_lock);
+static DEFINE_MUTEX(ctrblk_lock);
 
 struct s390_des_ctx {
 	u8 iv[DES_BLOCK_SIZE];
@@ -394,7 +395,7 @@ static int ctr_desall_crypt(struct blkci
 	if (!walk->nbytes)
 		return ret;
 
-	if (spin_trylock(&ctrblk_lock))
+	if (mutex_trylock(&ctrblk_lock))
 		ctrptr = ctrblk;
 
 	memcpy(ctrptr, walk->iv, DES_BLOCK_SIZE);
@@ -410,7 +411,7 @@ static int ctr_desall_crypt(struct blkci
 					       n, ctrptr);
 			if (ret < 0 || ret != n) {
 				if (ctrptr == ctrblk)
-					spin_unlock(&ctrblk_lock);
+					mutex_unlock(&ctrblk_lock);
 				return -EIO;
 			}
 			if (n > DES_BLOCK_SIZE)
@@ -428,7 +429,7 @@ static int ctr_desall_crypt(struct blkci
 			memcpy(ctrbuf, ctrptr, DES_BLOCK_SIZE);
 		else
 			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);
-		spin_unlock(&ctrblk_lock);
+		mutex_unlock(&ctrblk_lock);
 	} else {
 		if (!nbytes)
 			memcpy(walk->iv, ctrptr, DES_BLOCK_SIZE);

