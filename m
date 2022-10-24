Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F1860B273
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiJXQrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbiJXQp4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:45:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD0D19C23A;
        Mon, 24 Oct 2022 08:31:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC59EB81929;
        Mon, 24 Oct 2022 12:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1AAC433D6;
        Mon, 24 Oct 2022 12:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615224;
        bh=Pykm3Y3TIG++FUq3sDT51kXall0jNBqzsTHVbkscQgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLjU5TlfZtcW5Qm/m0MD1lyXMQlzGrghMPzCqBwq/OdIpUhbgLhw0AI9X4zc2OJ+P
         /zqzUWrTubKNFAPeLiS3Augcybn/THpZxYc8HqCRAkOjK0o8A2YWy5trgvreZW/Q0/
         F/ZENBGatabQ/3Es5JJNgE4xSDqapxhokNfSIS88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/530] bpf: Use this_cpu_{inc|dec|inc_return} for bpf_task_storage_busy
Date:   Mon, 24 Oct 2022 13:28:26 +0200
Message-Id: <20221024113052.396658021@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b305270b7a4b..de4d741d99a3 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -506,11 +506,11 @@ void bpf_local_storage_map_free(struct bpf_local_storage_map *smap,
 				struct bpf_local_storage_elem, map_node))) {
 			if (busy_counter) {
 				migrate_disable();
-				__this_cpu_inc(*busy_counter);
+				this_cpu_inc(*busy_counter);
 			}
 			bpf_selem_unlink(selem);
 			if (busy_counter) {
-				__this_cpu_dec(*busy_counter);
+				this_cpu_dec(*busy_counter);
 				migrate_enable();
 			}
 			cond_resched_rcu();
diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
index ebfa8bc90892..6b7bfce23915 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -25,20 +25,20 @@ static DEFINE_PER_CPU(int, bpf_task_storage_busy);
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



