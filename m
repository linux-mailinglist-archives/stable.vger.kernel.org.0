Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1D376906
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387530AbfGZNsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbfGZNpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:45:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB7A122BF5;
        Fri, 26 Jul 2019 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148707;
        bh=6/uPIlYL4tXXpClEj4Iy438L3wZe0nAPdUyNVWwWoeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCutMo4cHyJlUZ7b1j5pA1vO4fh9TpCSIdpYqJ4iQ7mBPwul2TU0vJmm3fdS0iyQN
         ARSwG6l+dXVie/uLA5ocDXxC238/iII44QrdAGIrepppqPtzAgFF7vmne+abenK3qQ
         NWuv/6FVYSzClSrnfFdajP61IAQm3b43n1yNQVjA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikko Rapeli <mikko.rapeli@iki.fi>,
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
        Sasha Levin <sashal@kernel.org>, codalist@coda.cs.cmu.edu
Subject: [PATCH AUTOSEL 4.9 22/30] uapi linux/coda_psdev.h: move upc_req definition from uapi to kernel side headers
Date:   Fri, 26 Jul 2019 09:44:24 -0400
Message-Id: <20190726134432.12993-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134432.12993-1-sashal@kernel.org>
References: <20190726134432.12993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikko Rapeli <mikko.rapeli@iki.fi>

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
index 5b8721efa948..fe1466daf291 100644
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
index 79d05981fc4b..e2c44d2f7d5b 100644
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

