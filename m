Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3286B61FA51
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbiKGQru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiKGQrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:47:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF341F2C9
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76F32611C1
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C18C433D7;
        Mon,  7 Nov 2022 16:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839667;
        bh=DwlEp+fpLnUCANQb7Znu9lrTiw4MA0u6wlx+avoG78Q=;
        h=Subject:To:Cc:From:Date:From;
        b=av4mI8qBKwR+5hZfZlQ4maSYuMqo/qLaWb+TfKihknMrFcCgLnvDDqrAoFwBIQslJ
         E5NMxC8Krf9TxLvQsxB2GZlBhmSF1mzAdz7lPORGz1fv/f2TRBWyvS3fmHTXuuNdji
         DrmoBxHyP+Wj8kgbRGcLGqufLFinsFJbJ2eJZqMs=
Subject: FAILED: patch "[PATCH] KVM: x86: Mask off reserved bits in CPUID.8000001AH" failed to apply to 4.14-stable tree
To:     jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:47:36 +0100
Message-ID: <1667839656176141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

079f6889818d ("KVM: x86: Mask off reserved bits in CPUID.8000001AH")
382409b4c43e ("kvm: x86: Include CPUID leaf 0x8000001e in kvm's supported CPUID")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 079f6889818dd07903fb36c252532ab47ebb6d48 Mon Sep 17 00:00:00 2001
From: Jim Mattson <jmattson@google.com>
Date: Thu, 29 Sep 2022 15:52:01 -0700
Subject: [PATCH] KVM: x86: Mask off reserved bits in CPUID.8000001AH

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. In the case of CPUID.8000001AH, only three bits are
currently defined. The 125 reserved bits should be masked off.

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220929225203.2234702-4-jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 489c028859e1..a0292ba650df 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1189,6 +1189,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001a:
+		entry->eax &= GENMASK(2, 0);
+		entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	case 0x8000001e:
 		break;
 	case 0x8000001F:

