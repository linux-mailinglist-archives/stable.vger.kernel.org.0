Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7440E4F338E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbiDEI4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241130AbiDEIcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DE816587;
        Tue,  5 Apr 2022 01:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6EE1B81BC6;
        Tue,  5 Apr 2022 08:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2516DC385A2;
        Tue,  5 Apr 2022 08:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147299;
        bh=Ce799mPfELJEVGE36aiBW8M/isovkz8cDcyTunmgCYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSYQWCwIu4zAyP2CLKXqXqOT028etxufeVa/SPRra7uwUIcKXxo2m2fKSmHTLTv6e
         chwdUooQArXWlQaMOFICxYXAwhutczrPgdiVEQSA0S3aVfOQjJXa0dT4PcA0O1G29G
         aDF7+dCdH5Nwh/7+9lY8YZ2C0/9qwbQFdSl5POYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 1073/1126] KVM: x86: SVM: fix avic spec based definitions again
Date:   Tue,  5 Apr 2022 09:30:20 +0200
Message-Id: <20220405070438.950343009@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 0dacc3df898e219fa774f39e5e10d686364e0a27 upstream.

Due to wrong rebase, commit
4a204f7895878 ("KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255")

moved avic spec #defines back to avic.c.

Move them back, and while at it extend AVIC_DOORBELL_PHYSICAL_ID_MASK to 12
bits as well (it will be used in nested avic)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220322172449.235575-5-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/svm.h |    8 +++++---
 arch/x86/kvm/svm/svm.h     |   11 -----------
 2 files changed, 5 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -222,7 +222,7 @@ struct __attribute__ ((__packed__)) vmcb
 
 
 /* AVIC */
-#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
+#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFFULL)
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
@@ -230,9 +230,11 @@ struct __attribute__ ((__packed__)) vmcb
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-#define AVIC_PHYSICAL_ID_TABLE_SIZE_MASK		(0xFF)
+#define AVIC_PHYSICAL_ID_TABLE_SIZE_MASK		(0xFFULL)
 
-#define AVIC_DOORBELL_PHYSICAL_ID_MASK			(0xFF)
+#define AVIC_DOORBELL_PHYSICAL_ID_MASK			GENMASK_ULL(11, 0)
+
+#define VMCB_AVIC_APIC_BAR_MASK				0xFFFFFFFFFF000ULL
 
 #define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
 #define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -558,17 +558,6 @@ extern struct kvm_x86_nested_ops svm_nes
 
 /* avic.c */
 
-#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
-#define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
-#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
-
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
-#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
-#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
-#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-
-#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
-
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);


