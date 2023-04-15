Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6186E3071
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 12:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjDOKMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 06:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDOKMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 06:12:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AEA10E9;
        Sat, 15 Apr 2023 03:12:01 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pz8C228mxzSrfY;
        Sat, 15 Apr 2023 18:07:58 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 15 Apr 2023 18:11:58 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <stable@vger.kernel.org>, <cuigaosheng1@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 5.10 0/4] Fix built-in testing dependency failures
Date:   Sat, 15 Apr 2023 18:11:54 +0800
Message-ID: <20230415101158.1648486-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When complex algorithms that depend on other algorithms are built
into the kernel, the order of registration must be done such that
the underlying algorithms are ready before the ones on top are
registered. As otherwise they would fail during the self-test
which is required during registration.

We can enable fips=1 and ecdh, the calltrace like below:

alg: ecdh: test failed on vector 2, err=-14
Kernel panic - not syncing: alg: self-tests for ecdh-generic (ecdh)
failed in fips mode!
Call Trace:
 dump_stack+0x57/0x6e
 panic+0x109/0x2ca
 alg_test+0x414/0x420
 ? __switch_to_asm+0x3a/0x60
 ? __switch_to_asm+0x34/0x60
 ? __schedule+0x263/0x640
 ? crypto_acomp_scomp_free_ctx+0x30/0x30
 cryptomgr_test+0x22/0x40
 kthread+0xf9/0x130
 ? kthread_park+0x90/0x90
 ret_from_fork+0x22/0x30

adad556efcd ("crypto: api - Fix built-in testing dependency failures") will
fix the issue, and others fix its bugs.

So we can merge them into linux-5.10-y to fix it, thanks!

Herbert Xu (4):
  crypto: api - Fix built-in testing dependency failures
  crypto: api - Do not create test larvals if manager is disabled
  crypto: api - Export crypto_boot_test_finished
  crypto: api - Fix boot-up crash when crypto manager is disabled

 crypto/algapi.c   | 125 +++++++++++++++++++++++++++++++---------------
 crypto/api.c      |  50 +++++++++++++++++--
 crypto/internal.h |  10 ++++
 3 files changed, 141 insertions(+), 44 deletions(-)

-- 
2.25.1

