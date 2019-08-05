Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3989881A7C
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbfHENGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbfHENGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:06:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 192852075B;
        Mon,  5 Aug 2019 13:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010391;
        bh=m3AUNa45QmVDF2VHITaB9pzyD5ROiFTPHFTLG+IWK0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPodm97exKO3XmRK6ImMypOz8S1sY0r+6K5FVxv7qI+O3xnUkf89+FOtCT5GQqghq
         TseWGBrvgBZKDXPZ8wouMvPPeu1naDLh9eP3bly5ZTFBlfGBYGNRpMN5RuAfaw4Nh5
         OQq2hoQfnZ5Vr5tESSunKcbHw9WVgfFTsZFy0lHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikko Rapeli <mikko.rapeli@iki.fi>,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Zhouyang Jia <jiazhouyang09@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 21/42] uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel side headers
Date:   Mon,  5 Aug 2019 15:02:47 +0200
Message-Id: <20190805124927.429028298@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124924.788666484@linuxfoundation.org>
References: <20190805124924.788666484@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f90fb3c7e2c13ae829db2274b88b845a75038b8a ]

Only users of upc_req in kernel side fs/coda/psdev.c and
fs/coda/upcall.c already include linux/coda_psdev.h.

Suggested by Jan Harkes <jaharkes@cs.cmu.edu> in
  https://lore.kernel.org/lkml/20150531111913.GA23377@cs.cmu.edu/

Fixes these include/uapi/linux/coda_psdev.h compilation errors in userspace:

  linux/coda_psdev.h:12:19: error: field `uc_chain' has incomplete type
  struct list_head    uc_chain;
                   ^
  linux/coda_psdev.h:13:2: error: unknown type name `caddr_t'
  caddr_t             uc_data;
  ^
  linux/coda_psdev.h:14:2: error: unknown type name `u_short'
  u_short             uc_flags;
  ^
  linux/coda_psdev.h:15:2: error: unknown type name `u_short'
  u_short             uc_inSize;  /* Size is at most 5000 bytes */
  ^
  linux/coda_psdev.h:16:2: error: unknown type name `u_short'
  u_short             uc_outSize;
  ^
  linux/coda_psdev.h:17:2: error: unknown type name `u_short'
  u_short             uc_opcode;  /* copied from data to save lookup */
  ^
  linux/coda_psdev.h:19:2: error: unknown type name `wait_queue_head_t'
  wait_queue_head_t   uc_sleep;   /* process' wait queue */
  ^

Link: http://lkml.kernel.org/r/9f99f5ce6a0563d5266e6cf7aa9585aac2cae971.1558117389.git.jaharkes@cs.cmu.edu
Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/coda_psdev.h      | 11 +++++++++++
 include/uapi/linux/coda_psdev.h | 13 -------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 5b8721efa948e..fe1466daf2918 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -19,6 +19,17 @@ struct venus_comm {
 	struct mutex	    vc_mutex;
 };
 
+/* messages between coda filesystem in kernel and Venus */
+struct upc_req {
+	struct list_head	uc_chain;
+	caddr_t			uc_data;
+	u_short			uc_flags;
+	u_short			uc_inSize;  /* Size is at most 5000 bytes */
+	u_short			uc_outSize;
+	u_short			uc_opcode;  /* copied from data to save lookup */
+	int			uc_unique;
+	wait_queue_head_t	uc_sleep;   /* process' wait queue */
+};
 
 static inline struct venus_comm *coda_vcp(struct super_block *sb)
 {
diff --git a/include/uapi/linux/coda_psdev.h b/include/uapi/linux/coda_psdev.h
index 79d05981fc4b0..e2c44d2f7d5bd 100644
--- a/include/uapi/linux/coda_psdev.h
+++ b/include/uapi/linux/coda_psdev.h
@@ -6,19 +6,6 @@
 #define CODA_PSDEV_MAJOR 67
 #define MAX_CODADEVS  5	   /* how many do we allow */
 
-
-/* messages between coda filesystem in kernel and Venus */
-struct upc_req {
-	struct list_head    uc_chain;
-	caddr_t	            uc_data;
-	u_short	            uc_flags;
-	u_short             uc_inSize;  /* Size is at most 5000 bytes */
-	u_short	            uc_outSize;
-	u_short	            uc_opcode;  /* copied from data to save lookup */
-	int		    uc_unique;
-	wait_queue_head_t   uc_sleep;   /* process' wait queue */
-};
-
 #define CODA_REQ_ASYNC  0x1
 #define CODA_REQ_READ   0x2
 #define CODA_REQ_WRITE  0x4
-- 
2.20.1



