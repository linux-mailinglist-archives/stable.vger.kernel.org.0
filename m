Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDA46086B4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiJVHwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiJVHu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:50:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985038A6DE;
        Sat, 22 Oct 2022 00:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF71560B3D;
        Sat, 22 Oct 2022 07:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE747C433D6;
        Sat, 22 Oct 2022 07:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424641;
        bh=fOZI99R9xfcgoIm40CdSm7/zmpiNb38vJN2fwxj97xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwfLxX3GhSxhqhdMdHZPtGG4vawlKb4qhdSupzz2OtY/nsAFRV3O3SIkTnbyr5NO4
         ZTy6r3DUiDN3dAW2GIWV6qcnZZouq6PGznF/MA6kx6myEQy2u69yh28P2QH61Q0EL1
         4h7I+HpkxvamDm9nmX9WtFyN65z2PO2PVmJjKvA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 221/717] bpf: Use this_cpu_{inc|dec|inc_return} for bpf_task_storage_busy
Date:   Sat, 22 Oct 2022 09:21:40 +0200
Message-Id: <20221022072454.252150939@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 197827a05e13808c60f52632e9887eede63f1c16 ]

Now migrate_disable() does not disable preemption and under some
architectures (e.g. arm64) __this_cpu_{inc|dec|inc_return} are neither
preemption-safe nor IRQ-safe, so for fully preemptible kernel concurrent
lookups or updates on the same task local storage and on the same CPU
may make bpf_task_storage_busy be imbalanced, and
bpf_task_storage_trylock() on the specific cpu will always fail.

Fixing it by using this_cpu_{inc|dec|inc_return} when manipulating
bpf_task_storage_busy.

Fixes: bc235cdb423a ("bpf: Prevent deadlock from recursive bpf_task_storage_[get|delete]")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20220901061938.3789460-2-houtao@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 4 ++--
 kernel/bpf/bpf_task_storage.c  | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 8ce40fd869f6..d13ffb00e981 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -555,11 +555,11 @@ void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
 				struct bpf_local_storage_elem, map_node))) {
 			if (busy_counter) {
 				migrate_disable();
-				__this_cpu_inc(*busy_counter);
+				this_cpu_inc(*busy_counter);
 			}
 			bpf_selem_unlink(selem, false);
 			if (busy_counter) {
-				__this_cpu_dec(*busy_counter);
+				this_cpu_dec(*busy_counter);
 				migrate_enable();
 			}
 			cond_resched_rcu();
diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
index e9014dc62682..6f290623347e 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -26,20 +26,20 @@ static DEFINE_PER_CPU(int, bpf_task_storage_busy);
 static void bpf_task_storage_lock(void)
 {
 	migrate_disable();
-	__this_cpu_inc(bpf_task_storage_busy);
+	this_cpu_inc(bpf_task_storage_busy);
 }
 
 static void bpf_task_storage_unlock(void)
 {
-	__this_cpu_dec(bpf_task_storage_busy);
+	this_cpu_dec(bpf_task_storage_busy);
 	migrate_enable();
 }
 
 static bool bpf_task_storage_trylock(void)
 {
 	migrate_disable();
-	if (unlikely(__this_cpu_inc_return(bpf_task_storage_busy) != 1)) {
-		__this_cpu_dec(bpf_task_storage_busy);
+	if (unlikely(this_cpu_inc_return(bpf_task_storage_busy) != 1)) {
+		this_cpu_dec(bpf_task_storage_busy);
 		migrate_enable();
 		return false;
 	}
-- 
2.35.1



