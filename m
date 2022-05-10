Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1202521B27
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244632AbiEJOI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245625AbiEJOHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1803D22B3A2;
        Tue, 10 May 2022 06:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA6336194D;
        Tue, 10 May 2022 13:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5AFC385C2;
        Tue, 10 May 2022 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190059;
        bh=vq6a1fG3vO1KR35Jg16mN5QOD1teXM12MIU7i8SU6zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RwJtJZzmEtnODs9TPi3HF6i5cCdMAKqtzHNcsgvRxYD05SNt+SVH9z3feBaXDe9rQ
         D+e8Afw+k8kHlNPxRXUyP4Id5oktUHI2RNs4X5OfIPZ5eQp4/PDKfxljsgNWGUqEll
         8Jj77L3+r6boX1C3zB9NS0qcGp8w1Cs6IQIQdUxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 114/140] KVM: selftests: Silence compiler warning in the kvm_page_table_test
Date:   Tue, 10 May 2022 15:08:24 +0200
Message-Id: <20220510130744.866749157@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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



