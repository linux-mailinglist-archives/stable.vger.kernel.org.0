Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705E252199D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244362AbiEJNt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244949AbiEJNrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E746C21B178;
        Tue, 10 May 2022 06:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E0F618A0;
        Tue, 10 May 2022 13:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBB5C385A6;
        Tue, 10 May 2022 13:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189573;
        bh=ueB1Y6/yuNWGMloKhd/JUy0TqGqlP4o97wbX0fFeZTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pk2KDvE2F4dJLlGsM79y6251i9aZie0Bj9YtOJhEYTDuPyF/R36+gQTd+da/ElPv0
         DwPPXAkZ3YsKBwu5fxeJFcUUSDwQ1CpzxF+ysQqtMPd3Qw77WmOqTfAoscllmCs/a2
         ktGqqUilwos5VaPzBdauN4cYCvQJpQWuruBGhzJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/135] KVM: selftests: Silence compiler warning in the kvm_page_table_test
Date:   Tue, 10 May 2022 15:07:57 +0200
Message-Id: <20220510130743.134928802@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 36407cb0ec85..f1ddfe4c4a03 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -278,7 +278,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 	else
 		guest_test_phys_mem = p->phys_offset;
 #ifdef __s390x__
-	alignment = max(0x100000, alignment);
+	alignment = max(0x100000UL, alignment);
 #endif
 	guest_test_phys_mem &= ~(alignment - 1);
 
-- 
2.35.1



