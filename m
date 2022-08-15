Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1AF59461C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350082AbiHOWVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350922AbiHOWSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5477D66A74;
        Mon, 15 Aug 2022 12:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72878B80EA7;
        Mon, 15 Aug 2022 19:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB31EC433D7;
        Mon, 15 Aug 2022 19:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592580;
        bh=siPGSWciJGt6lgMgSJxzauggUweP0sClQaAVfp+eYbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p65Jf5toj+x/aneJLFAxgs/CtN/cWlH3ED+oMn+Ejk1yDSq8HhxZU9JPnLPRyeexh
         7EFlO3CS0lvvldxs5hTNU0jh7rKLAxWoTf+5MzO7doKUgtx4c6047ohkO4VlRqcnye
         o+izL8+af9zQUpB+WrIrLvNSngWkRi3C57BM/AlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Vagin <avagin@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0811/1095] selftests: kvm: set rax before vmcall
Date:   Mon, 15 Aug 2022 20:03:30 +0200
Message-Id: <20220815180502.809034018@linuxfoundation.org>
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

From: Andrei Vagin <avagin@google.com>

[ Upstream commit 281106f938d3daaea6f8b6723a8217a2a1ef6936 ]

kvm_hypercall has to place the hypercall number in rax.

Trace events show that kvm_pv_test doesn't work properly:
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0

With this change, it starts working as expected:
     kvm_pv_test-54285: kvm_hypercall: nr 0x5 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-54285: kvm_hypercall: nr 0xa a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-54285: kvm_hypercall: nr 0xb a0 0x0 a1 0x0 a2 0x0 a3 0x0

Signed-off-by: Andrei Vagin <avagin@google.com>
Message-Id: <20220722230241.1944655-5-avagin@google.com>
Fixes: ac4a4d6de22e ("selftests: kvm: test enforcement of paravirtual cpuid features")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 33ea5e9955d9..b9984124a294 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1423,7 +1423,7 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 
 	asm volatile("vmcall"
 		     : "=a"(r)
-		     : "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 	return r;
 }
 
-- 
2.35.1



