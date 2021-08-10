Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B253E7F62
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhHJRkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233720AbhHJRhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A782C603E7;
        Tue, 10 Aug 2021 17:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616962;
        bh=OFEBgr4VXBm6Ho5C/vyJntXGXOedipYLtwXZl5inAB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2PN2RJoZyeZFwlME4Uk9us77wo3501JP3JMebbpkQcWAAqIh4fyEpNYIPC9KF/2c
         EeQJDZ5ptZ2GPJW6ATOQZS3tzBoe/5RzyJvGLmXTZkC+ZgMGoTAnWICLlp9l8eOw5P
         oJoEw+9UiOx+1m4M5Ug/sNJuJfW9IO0vC21sYxwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Hicks <tyhicks@linux.microsoft.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH 5.4 52/85] optee: Clear stale cache entries during initialization
Date:   Tue, 10 Aug 2021 19:30:25 +0200
Message-Id: <20210810172949.998606371@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyler Hicks <tyhicks@linux.microsoft.com>

commit b5c10dd04b7418793517e3286cde5c04759a86de upstream.

The shm cache could contain invalid addresses if
optee_disable_shm_cache() was not called from the .shutdown hook of the
previous kernel before a kexec. These addresses could be unmapped or
they could point to mapped but unintended locations in memory.

Clear the shared memory cache, while being careful to not translate the
addresses returned from OPTEE_SMC_DISABLE_SHM_CACHE, during driver
initialization. Once all pre-cache shm objects are removed, proceed with
enabling the cache so that we know that we can handle cached shm objects
with confidence later in the .shutdown hook.

Cc: stable@vger.kernel.org
Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/call.c          |   36 +++++++++++++++++++++++++++++++++---
 drivers/tee/optee/core.c          |    9 +++++++++
 drivers/tee/optee/optee_private.h |    1 +
 3 files changed, 43 insertions(+), 3 deletions(-)

--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -407,11 +407,13 @@ void optee_enable_shm_cache(struct optee
 }
 
 /**
- * optee_disable_shm_cache() - Disables caching of some shared memory allocation
- *			      in OP-TEE
+ * __optee_disable_shm_cache() - Disables caching of some shared memory
+ *                               allocation in OP-TEE
  * @optee:	main service struct
+ * @is_mapped:	true if the cached shared memory addresses were mapped by this
+ *		kernel, are safe to dereference, and should be freed
  */
-void optee_disable_shm_cache(struct optee *optee)
+static void __optee_disable_shm_cache(struct optee *optee, bool is_mapped)
 {
 	struct optee_call_waiter w;
 
@@ -430,6 +432,13 @@ void optee_disable_shm_cache(struct opte
 		if (res.result.status == OPTEE_SMC_RETURN_OK) {
 			struct tee_shm *shm;
 
+			/*
+			 * Shared memory references that were not mapped by
+			 * this kernel must be ignored to prevent a crash.
+			 */
+			if (!is_mapped)
+				continue;
+
 			shm = reg_pair_to_ptr(res.result.shm_upper32,
 					      res.result.shm_lower32);
 			tee_shm_free(shm);
@@ -440,6 +449,27 @@ void optee_disable_shm_cache(struct opte
 	optee_cq_wait_final(&optee->call_queue, &w);
 }
 
+/**
+ * optee_disable_shm_cache() - Disables caching of mapped shared memory
+ *                             allocations in OP-TEE
+ * @optee:	main service struct
+ */
+void optee_disable_shm_cache(struct optee *optee)
+{
+	return __optee_disable_shm_cache(optee, true);
+}
+
+/**
+ * optee_disable_unmapped_shm_cache() - Disables caching of shared memory
+ *                                      allocations in OP-TEE which are not
+ *                                      currently mapped
+ * @optee:	main service struct
+ */
+void optee_disable_unmapped_shm_cache(struct optee *optee)
+{
+	return __optee_disable_shm_cache(optee, false);
+}
+
 #define PAGELIST_ENTRIES_PER_PAGE				\
 	((OPTEE_MSG_NONCONTIG_PAGE_SIZE / sizeof(u64)) - 1)
 
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -628,6 +628,15 @@ static struct optee *optee_probe(struct
 	optee->memremaped_shm = memremaped_shm;
 	optee->pool = pool;
 
+	/*
+	 * Ensure that there are no pre-existing shm objects before enabling
+	 * the shm cache so that there's no chance of receiving an invalid
+	 * address during shutdown. This could occur, for example, if we're
+	 * kexec booting from an older kernel that did not properly cleanup the
+	 * shm cache.
+	 */
+	optee_disable_unmapped_shm_cache(optee);
+
 	optee_enable_shm_cache(optee);
 
 	if (optee->sec_caps & OPTEE_SMC_SEC_CAP_DYNAMIC_SHM)
--- a/drivers/tee/optee/optee_private.h
+++ b/drivers/tee/optee/optee_private.h
@@ -152,6 +152,7 @@ int optee_cancel_req(struct tee_context
 
 void optee_enable_shm_cache(struct optee *optee);
 void optee_disable_shm_cache(struct optee *optee);
+void optee_disable_unmapped_shm_cache(struct optee *optee);
 
 int optee_shm_register(struct tee_context *ctx, struct tee_shm *shm,
 		       struct page **pages, size_t num_pages,


