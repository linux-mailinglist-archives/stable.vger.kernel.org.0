Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87C2594990
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243631AbiHOXRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353534AbiHOXQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57B5AF497;
        Mon, 15 Aug 2022 13:03:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C328B80EAD;
        Mon, 15 Aug 2022 20:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF78C433D6;
        Mon, 15 Aug 2022 20:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593807;
        bh=1UQTlE+KgZKe/65niCjLYaTpKD6QDiBXlSIHeo+yO74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zFRsddy7MwPZ1e2RdZ/FPyqAjjFX/Vwn2sftMAmEDMyZcwBnmdKjAPZx7l8tAoAAH
         xX3XHzK9+rBpqUlnRS8xyFP6kKBI+FYwH+pjI27wbJMnVbr4I9rG1E7YCgUageFnVI
         /ERYh115uEl0WzGgEOJk9qbjxGaISP0TIiRZRlIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen jingwen <chenjingwen6@huawei.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1009/1095] locking/csd_lock: Change csdlock_debug from early_param to __setup
Date:   Mon, 15 Aug 2022 20:06:48 +0200
Message-Id: <20220815180510.844804678@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 9c9b26b0df270d4f9246e483a44686fca951a29c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 65a630f62363..381eb15cd28f 100644
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
2.35.1



