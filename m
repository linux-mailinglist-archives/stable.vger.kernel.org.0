Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133EA6ECE89
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbjDXNd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbjDXNdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A67D5FE0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C7E16237C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA85C433EF;
        Mon, 24 Apr 2023 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343148;
        bh=PcoHRoJfi7YMaCtwYswy2Dnjzk/YQsFLh9YTS2nO194=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIXJsiKDnrUFUGOrEAwCc+zzUhGbjt7XaSx4fhqjew+8i3hx2WRYsJN7x1/Z3U37f
         UM4qOJFxTsquRca9ftyB63gqgirOzWuZC+RY9I3w9FtKAe5qos7lmbiOINd2zBQXeZ
         J+TJ/5YQjyqwPeJHQ4in8FRNkTAUgBkDF8ZI2T4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mostafa Saleh <smostafa@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.2 094/110] KVM: arm64: Make vcpu flag updates non-preemptible
Date:   Mon, 24 Apr 2023 15:17:56 +0200
Message-Id: <20230424131140.065930247@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 35dcb3ac663a16510afc27ba2725d70c15e012a5 upstream.

Per-vcpu flags are updated using a non-atomic RMW operation.
Which means it is possible to get preempted between the read and
write operations.

Another interesting thing to note is that preemption also updates
flags, as we have some flag manipulation in both the load and put
operations.

It is thus possible to lose information communicated by either
load or put, as the preempted flag update will overwrite the flags
when the thread is resumed. This is specially critical if either
load or put has stored information which depends on the physical
CPU the vcpu runs on.

This results in really elusive bugs, and kudos must be given to
Mostafa for the long hours of debugging, and finally spotting
the problem.

Fix it by disabling preemption during the RMW operation, which
ensures that the state stays consistent. Also upgrade vcpu_get_flag
path to use READ_ONCE() to make sure the field is always atomically
accessed.

Fixes: e87abb73e594 ("KVM: arm64: Add helpers to manipulate vcpu flags among a set")
Reported-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230418125737.2327972-1-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -533,9 +533,22 @@ struct kvm_vcpu_arch {
 	({							\
 		__build_check_flag(v, flagset, f, m);		\
 								\
-		v->arch.flagset & (m);				\
+		READ_ONCE(v->arch.flagset) & (m);		\
 	})
 
+/*
+ * Note that the set/clear accessors must be preempt-safe in order to
+ * avoid nesting them with load/put which also manipulate flags...
+ */
+#ifdef __KVM_NVHE_HYPERVISOR__
+/* the nVHE hypervisor is always non-preemptible */
+#define __vcpu_flags_preempt_disable()
+#define __vcpu_flags_preempt_enable()
+#else
+#define __vcpu_flags_preempt_disable()	preempt_disable()
+#define __vcpu_flags_preempt_enable()	preempt_enable()
+#endif
+
 #define __vcpu_set_flag(v, flagset, f, m)			\
 	do {							\
 		typeof(v->arch.flagset) *fset;			\
@@ -543,9 +556,11 @@ struct kvm_vcpu_arch {
 		__build_check_flag(v, flagset, f, m);		\
 								\
 		fset = &v->arch.flagset;			\
+		__vcpu_flags_preempt_disable();			\
 		if (HWEIGHT(m) > 1)				\
 			*fset &= ~(m);				\
 		*fset |= (f);					\
+		__vcpu_flags_preempt_enable();			\
 	} while (0)
 
 #define __vcpu_clear_flag(v, flagset, f, m)			\
@@ -555,7 +570,9 @@ struct kvm_vcpu_arch {
 		__build_check_flag(v, flagset, f, m);		\
 								\
 		fset = &v->arch.flagset;			\
+		__vcpu_flags_preempt_disable();			\
 		*fset &= ~(m);					\
+		__vcpu_flags_preempt_enable();			\
 	} while (0)
 
 #define vcpu_get_flag(v, ...)	__vcpu_get_flag((v), __VA_ARGS__)


