Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED65511DB0
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240636AbiD0P5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240605AbiD0P5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:57:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B915B88B;
        Wed, 27 Apr 2022 08:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 711CDB8287D;
        Wed, 27 Apr 2022 15:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA34C385A9;
        Wed, 27 Apr 2022 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074860;
        bh=vq6a1fG3vO1KR35Jg16mN5QOD1teXM12MIU7i8SU6zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6vvC5GarUYhovlg/d85BZt3bxdycNZnp+BdxEVru4fdFMN5wZ0t5NBwwAhgQy+/y
         GSKo9bdFWnIfGlN2lzupSRA5YBqShWj8fsJFCeI9c0Wvc3Fkca5xuEpkFcwiuRG5x+
         HmuNF8+gSlVyM0NpWM7RzF7C2BJymQUBEqB8K5dq2N7HL8PoO3aCamDGPjwGB3bxuj
         FZUlMeW4fM+lYzQKi5Yco8V0qxxxiIJWUfoReho35qK2nYrQ/tq5RIiSSB4lDCvL/e
         OGnkDyDCmTU71V3NkIrAU/fViXRpMkBWRoeSNGcSQy4msJJlITnEBMeGD3VIZVnMRA
         ++ZjZIcYAVDBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH MANUALSEL 5.17 2/7] KVM: selftests: Silence compiler warning in the kvm_page_table_test
Date:   Wed, 27 Apr 2022 11:53:58 -0400
Message-Id: <20220427155408.19352-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427155408.19352-1-sashal@kernel.org>
References: <20220427155408.19352-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

[ Upstream commit 266a19a0bc4fbfab4d981a47640ca98972a01865 ]

When compiling kvm_page_table_test.c, I get this compiler warning
with gcc 11.2:

kvm_page_table_test.c: In function 'pre_init_before_test':
../../../../tools/include/linux/kernel.h:44:24: warning: comparison of
 distinct pointer types lacks a cast
   44 |         (void) (&_max1 == &_max2);              \
      |                        ^~
kvm_page_table_test.c:281:21: note: in expansion of macro 'max'
  281 |         alignment = max(0x100000, alignment);
      |                     ^~~

Fix it by adjusting the type of the absolute value.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20220414103031.565037-1-thuth@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/kvm_page_table_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index ba1fdc3dcf4a..2c4a7563a4f8 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -278,7 +278,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	else
 		guest_test_phys_mem = p->phys_offset;
 #ifdef __s390x__
-	alignment = max(0x100000, alignment);
+	alignment = max(0x100000UL, alignment);
 #endif
 	guest_test_phys_mem = align_down(guest_test_phys_mem, alignment);
 
-- 
2.35.1

