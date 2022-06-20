Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D275526DD
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 00:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbiFTWUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 18:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244759AbiFTWUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 18:20:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7191BE82;
        Mon, 20 Jun 2022 15:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ABB7B8164E;
        Mon, 20 Jun 2022 22:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8C3C341CF;
        Mon, 20 Jun 2022 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655763634;
        bh=lyNCAIvYhX/+kHwlAad/y9gHMFmiZO/u932Jluyi4aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjIFk5YxhEODc2yYfvgjOXXFHf3Ik38rQd+LeQZ+Oek9uUtSZ38cy8J4RZ5+l8XFm
         VaGTwCO0bXakKzgxFSgEVtK9UY2il7+RWQB5d4UhfLFHZ2CpRVi2ae9cVhnm/gQNbF
         G5UKOuoFendHYd+tezPrBS6rqLpFqaoU6c3BWoiKv1sdt223xkCpQ2ukK7mY8z8HRq
         HPvGFZRgHmnCv3Vov0EbAtgGgrnE168NzYsNNwSbZgpVYDQypzNhn5ntHLf1DbaWcW
         pbOaB5ccgWHX/Mce4mAr+4kwdYKKRkZSymeKTQzMnIij7QUwx+cTX/X/h0vEZAC9Ji
         ugsXHrG/y59Tg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 078495C0B06; Mon, 20 Jun 2022 15:20:34 -0700 (PDT)
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com,
        rostedt@goodmis.org, Chen Zhongjin <chenzhongjin@huawei.com>,
        stable@vger.kernel.org, Chen jingwen <chenjingwen6@huawei.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: [PATCH rcu 06/12] locking/csd_lock: Change csdlock_debug from early_param to __setup
Date:   Mon, 20 Jun 2022 15:20:26 -0700
Message-Id: <20220620222032.3839547-6-paulmck@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
In-Reply-To: <20220620222022.GA3839466@paulmck-ThinkPad-P17-Gen-1>
References: <20220620222022.GA3839466@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

The csdlock_debug kernel-boot parameter is parsed by the
early_param() function csdlock_debug().  If set, csdlock_debug()
invokes static_branch_enable() to enable csd_lock_wait feature, which
triggers a panic on arm64 for kernels built with CONFIG_SPARSEMEM=y and
CONFIG_SPARSEMEM_VMEMMAP=n.

With CONFIG_SPARSEMEM_VMEMMAP=n, __nr_to_section is called in
static_key_enable() and returns NULL, resulting in a NULL dereference
because mem_section is initialized only later in sparse_init().

This is also a problem for powerpc because early_param() functions
are invoked earlier than jump_label_init(), also resulting in
static_key_enable() failures.  These failures cause the warning "static
key 'xxx' used before call to jump_label_init()".

Thus, early_param is too early for csd_lock_wait to run
static_branch_enable(), so changes it to __setup to fix these.

Fixes: 8d0968cc6b8f ("locking/csd_lock: Add boot parameter for controlling CSD lock debugging")
Cc: stable@vger.kernel.org
Reported-by: Chen jingwen <chenjingwen6@huawei.com>
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 kernel/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index dd215f4394264..650810a6f29b3 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -174,9 +174,9 @@ static int __init csdlock_debug(char *str)
 	if (val)
 		static_branch_enable(&csdlock_debug_enabled);
 
-	return 0;
+	return 1;
 }
-early_param("csdlock_debug", csdlock_debug);
+__setup("csdlock_debug=", csdlock_debug);
 
 static DEFINE_PER_CPU(call_single_data_t *, cur_csd);
 static DEFINE_PER_CPU(smp_call_func_t, cur_csd_func);
-- 
2.31.1.189.g2e36527f23

