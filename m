Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4F8DA0EE
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732875AbfJPWR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395072AbfJPVys (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:48 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB96121928;
        Wed, 16 Oct 2019 21:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262888;
        bh=ym8G2ZdQbDsO+1BvbPg5YIeTwSU9bt9Wg46NbwfNwBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfNkk4ng9fAnioPeveCXa4vL9cKuNiGNAlalXLoPWCrxXeLaMEuaK89DKLtfVqNmv
         JQaRH2v8638p6A4e/ihBi2FdLoZ9/m9zDwTKAH91jW/jLkZ5ApI4WsVS1PjNCszMb2
         hgnJjvJJ/POG/ccar6ow5mdz/gkFV+qTT4A8o3ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.9 09/92] crypto: qat - Silence smp_processor_id() warning
Date:   Wed, 16 Oct 2019 14:49:42 -0700
Message-Id: <20191016214806.016745726@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

commit 1b82feb6c5e1996513d0fb0bbb475417088b4954 upstream.

It seems that smp_processor_id() is only used for a best-effort
load-balancing, refer to qat_crypto_get_instance_node(). It's not feasible
to disable preemption for the duration of the crypto requests. Therefore,
just silence the warning. This commit is similar to e7a9b05ca4
("crypto: cavium - Fix smp_processor_id() warnings").

Silences the following splat:
BUG: using smp_processor_id() in preemptible [00000000] code: cryptomgr_test/2904
caller is qat_alg_ablkcipher_setkey+0x300/0x4a0 [intel_qat]
CPU: 1 PID: 2904 Comm: cryptomgr_test Tainted: P           O    4.14.69 #1
...
Call Trace:
 dump_stack+0x5f/0x86
 check_preemption_disabled+0xd3/0xe0
 qat_alg_ablkcipher_setkey+0x300/0x4a0 [intel_qat]
 skcipher_setkey_ablkcipher+0x2b/0x40
 __test_skcipher+0x1f3/0xb20
 ? cpumask_next_and+0x26/0x40
 ? find_busiest_group+0x10e/0x9d0
 ? preempt_count_add+0x49/0xa0
 ? try_module_get+0x61/0xf0
 ? crypto_mod_get+0x15/0x30
 ? __kmalloc+0x1df/0x1f0
 ? __crypto_alloc_tfm+0x116/0x180
 ? crypto_skcipher_init_tfm+0xa6/0x180
 ? crypto_create_tfm+0x4b/0xf0
 test_skcipher+0x21/0xa0
 alg_test_skcipher+0x3f/0xa0
 alg_test.part.6+0x126/0x2a0
 ? finish_task_switch+0x21b/0x260
 ? __schedule+0x1e9/0x800
 ? __wake_up_common+0x8d/0x140
 cryptomgr_test+0x40/0x50
 kthread+0xff/0x130
 ? cryptomgr_notify+0x540/0x540
 ? kthread_create_on_node+0x70/0x70
 ret_from_fork+0x24/0x50

Fixes: ed8ccaef52 ("crypto: qat - Add support for SRIOV")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/qat/qat_common/adf_common_drv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -95,7 +95,7 @@ struct service_hndl {
 
 static inline int get_current_node(void)
 {
-	return topology_physical_package_id(smp_processor_id());
+	return topology_physical_package_id(raw_smp_processor_id());
 }
 
 int adf_service_register(struct service_hndl *service);


