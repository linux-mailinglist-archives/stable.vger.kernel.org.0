Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5AA6AEEC8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjCGSQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjCGSPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:15:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D86AB8B2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97B3AB819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F8FC433D2;
        Tue,  7 Mar 2023 18:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212653;
        bh=qhn9Mz5Xf0sM/28BzNMo9OYqjwBhnKFBO9plANfz3mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLMMPStZkTSa57fCuQu0TSLYJb/xY1+adAQowPNQYHIalEUqM9tlhmHn7zQHFAwFs
         SlGiufrsxMP4FLIC91D2o7apoi+iPdQArBW3kLZ6BLPdeLaKL8db1Si7Ft9Z799ewf
         miIbSO3pccqr2pCVlWitQ6tma7aFQp3WLetGVsME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "D. Wythe" <alibuda@linux.alibaba.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 254/885] net/smc: fix potential panic dues to unprotected smc_llc_srv_add_link()
Date:   Tue,  7 Mar 2023 17:53:08 +0100
Message-Id: <20230307170013.026076898@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit e40b801b3603a8f90b46acbacdea3505c27f01c0 ]

There is a certain chance to trigger the following panic:

PID: 5900   TASK: ffff88c1c8af4100  CPU: 1   COMMAND: "kworker/1:48"
 #0 [ffff9456c1cc79a0] machine_kexec at ffffffff870665b7
 #1 [ffff9456c1cc79f0] __crash_kexec at ffffffff871b4c7a
 #2 [ffff9456c1cc7ab0] crash_kexec at ffffffff871b5b60
 #3 [ffff9456c1cc7ac0] oops_end at ffffffff87026ce7
 #4 [ffff9456c1cc7ae0] page_fault_oops at ffffffff87075715
 #5 [ffff9456c1cc7b58] exc_page_fault at ffffffff87ad0654
 #6 [ffff9456c1cc7b80] asm_exc_page_fault at ffffffff87c00b62
    [exception RIP: ib_alloc_mr+19]
    RIP: ffffffffc0c9cce3  RSP: ffff9456c1cc7c38  RFLAGS: 00010202
    RAX: 0000000000000000  RBX: 0000000000000002  RCX: 0000000000000004
    RDX: 0000000000000010  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff88c1ea281d00   R8: 000000020a34ffff   R9: ffff88c1350bbb20
    R10: 0000000000000000  R11: 0000000000000001  R12: 0000000000000000
    R13: 0000000000000010  R14: ffff88c1ab040a50  R15: ffff88c1ea281d00
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #7 [ffff9456c1cc7c60] smc_ib_get_memory_region at ffffffffc0aff6df [smc]
 #8 [ffff9456c1cc7c88] smcr_buf_map_link at ffffffffc0b0278c [smc]
 #9 [ffff9456c1cc7ce0] __smc_buf_create at ffffffffc0b03586 [smc]

The reason here is that when the server tries to create a second link,
smc_llc_srv_add_link() has no protection and may add a new link to
link group. This breaks the security environment protected by
llc_conf_mutex.

Fixes: 2d2209f20189 ("net/smc: first part of add link processing as SMC server")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e12d4fa5aece6..d9413d43b1045 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1826,8 +1826,10 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
 	smc_llc_link_active(link);
 	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
 
+	mutex_lock(&link->lgr->llc_conf_mutex);
 	/* initial contact - try to establish second link */
 	smc_llc_srv_add_link(link, NULL);
+	mutex_unlock(&link->lgr->llc_conf_mutex);
 	return 0;
 }
 
-- 
2.39.2



