Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620E92F0B5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfE3EGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731163AbfE3DRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:34 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF70C2464B;
        Thu, 30 May 2019 03:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186253;
        bh=VlALxv8za7zVD5ocOij2gNebnaZB8CTrJQnYlpH9y0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFDJ+qdBFmZabf7qJ0PcyjMCgxbeIaYj8scyTyhSSiyiG91C5FjKCAnnzRu173XsK
         YeY2T6vjdHwNG4FgQQnrFyoXpRth0MnNs57qaA0lUyM7ymRpdZ8Kwx47TShoe3wdG9
         IAo8XGxFRSwZSDiDIaiiS/jg/R4a3D+XCYpl3DMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon DeVree <nuxi@vault24.org>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 133/276] random: fix CRNG initialization when random.trust_cpu=1
Date:   Wed, 29 May 2019 20:04:51 -0700
Message-Id: <20190530030534.073451785@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fe6f1a6a8eedc1aa538fee0baa612b6a59639cf8 ]

When the system boots with random.trust_cpu=1 it doesn't initialize the
per-NUMA CRNGs because it skips the rest of the CRNG startup code. This
means that the code from 1e7f583af67b ("random: make /dev/urandom scalable
for silly userspace programs") is not used when random.trust_cpu=1.

crash> dmesg | grep random:
[    0.000000] random: get_random_bytes called from start_kernel+0x94/0x530 with crng_init=0
[    0.314029] random: crng done (trusting CPU's manufacturer)
crash> print crng_node_pool
$6 = (struct crng_state **) 0x0

After adding the missing call to numa_crng_init() the per-NUMA CRNGs are
initialized again:

crash> dmesg | grep random:
[    0.000000] random: get_random_bytes called from start_kernel+0x94/0x530 with crng_init=0
[    0.314031] random: crng done (trusting CPU's manufacturer)
crash> print crng_node_pool
$1 = (struct crng_state **) 0xffff9a915f4014a0

The call to invalidate_batched_entropy() was also missing. This is
important for architectures like PPC and S390 which only have the
arch_get_random_seed_* functions.

Fixes: 39a8883a2b98 ("random: add a config option to trust the CPU's hwrng")
Signed-off-by: Jon DeVree <nuxi@vault24.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/random.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index c75b6cdf00533..a4515703cfcdd 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -778,6 +778,7 @@ static struct crng_state **crng_node_pool __read_mostly;
 #endif
 
 static void invalidate_batched_entropy(void);
+static void numa_crng_init(void);
 
 static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
 static int __init parse_trust_cpu(char *arg)
@@ -806,7 +807,9 @@ static void crng_initialize(struct crng_state *crng)
 		}
 		crng->state[i] ^= rv;
 	}
-	if (trust_cpu && arch_init) {
+	if (trust_cpu && arch_init && crng == &primary_crng) {
+		invalidate_batched_entropy();
+		numa_crng_init();
 		crng_init = 2;
 		pr_notice("random: crng done (trusting CPU's manufacturer)\n");
 	}
-- 
2.20.1



