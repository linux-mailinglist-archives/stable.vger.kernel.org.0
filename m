Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDD9593C50
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344795AbiHOTyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344612AbiHOTxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:53:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDAF75381;
        Mon, 15 Aug 2022 11:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0BE860C0B;
        Mon, 15 Aug 2022 18:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF283C433C1;
        Mon, 15 Aug 2022 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589461;
        bh=LR3N5+oQRgb7cEg49ztNE+Ds4xKavOMtfP3KjrzlCi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1D8fU87JzlKk94yuryPXtPZNXsLKsxdZP3eMn2/V0lU9aqRZ8YAqU3Y5hZvsen5va
         qQeteEo5FkISC4KCdOcYkpN9F9tyRn9GSAvNGs1fcQJnUDIFdeYXASNcCySkAvm53V
         w9KvPtBOpdNGCDIKGoOg5R+l35fYV82UKTlG84AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen jingwen <chenjingwen6@huawei.com>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 724/779] locking/csd_lock: Change csdlock_debug from early_param to __setup
Date:   Mon, 15 Aug 2022 20:06:08 +0200
Message-Id: <20220815180408.415618303@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index b68d63e965db..82825345432c 100644
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



