Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7947A4D822A
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239911AbiCNMA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240161AbiCNMAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF73488BC;
        Mon, 14 Mar 2022 04:58:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20CB66129D;
        Mon, 14 Mar 2022 11:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9D9C340E9;
        Mon, 14 Mar 2022 11:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259116;
        bh=icEDEpDgLSl7wJF0aO509gDlWKyVm8JZ8orC63osoE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJaCjJZ+g+5ZUdWSdOVqyc0iDTsFsZXV6u73S9vs8hgZL75PVemVA9rVu/hm+T2Rs
         SyLejICFP3f9HFfmCoQ8/jrjUMX+WaVj5LCdFhJfZ+d8t2iB2fujIu4l7gordhrUkm
         XyXIeeajjBIIvo3lpTifZYzVkqZoocN48SNu11dM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liam Merwick <liam.merwick@oracle.com>
Subject: [PATCH 5.4 43/43] KVM: SVM: Dont flush cache if hardware enforces cache coherency across encryption domains
Date:   Mon, 14 Mar 2022 12:53:54 +0100
Message-Id: <20220314112735.628330783@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krish Sadhukhan <krish.sadhukhan@oracle.com>

commit e1ebb2b49048c4767cfa0d8466f9c701e549fa5e upstream.

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page in a VM is enforced. In
such a system, it is not required for software to flush the VM's page
from all CPU caches in the system prior to changing the value of the
C-bit for the page.

So check that bit before flushing the cache.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lkml.kernel.org/r/20200917212038.5090-4-krish.sadhukhan@oracle.com
[ The linux-5.4.y stable branch does not have the Linux 5.7 refactoring commit
  eaf78265a4ab ("KVM: SVM: Move SEV code to separate file") so the
  change was manually applied to sev_clflush_pages() in arch/x86/kvm/svm.c. ]
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1904,7 +1904,8 @@ static void sev_clflush_pages(struct pag
 	uint8_t *page_virtual;
 	unsigned long i;
 
-	if (npages == 0 || pages == NULL)
+	if (this_cpu_has(X86_FEATURE_SME_COHERENT) || npages == 0 ||
+	    pages == NULL)
 		return;
 
 	for (i = 0; i < npages; i++) {


