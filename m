Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BB55934C3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiHOSQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbiHOSPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:15:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323082A403;
        Mon, 15 Aug 2022 11:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADD2D6126D;
        Mon, 15 Aug 2022 18:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E99C433C1;
        Mon, 15 Aug 2022 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587264;
        bh=KbymLyEDXrB6u8TOCJnLlIv9TZMKZR8179uzCYGH6Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKUsJ9DDXdf3Pbs36nQDdLBBgQJZbI/1EjtvulZT5KwwKv8hmG547sQVDfNGEA0CS
         4qeNqQQTj9lRI3z/9XX5iTSWowh1qgGj1dM8n6ZLlF5+1+a4sEf4Y1/BIUDHMTNP+L
         365q2uNud2dXX6gN6ppcaCLr2s2vSEtusnJPzoQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 030/779] KVM: nVMX: Always enable TSC scaling for L2 when it was enabled for L1
Date:   Mon, 15 Aug 2022 19:54:34 +0200
Message-Id: <20220815180338.515451628@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 156b9d76e8822f2956c15029acf2d4b171502f3a upstream.

Windows 10/11 guests with Hyper-V role (WSL2) enabled are observed to
hang upon boot or shortly after when a non-default TSC frequency was
set for L1. The issue is observed on a host where TSC scaling is
supported. The problem appears to be that Windows doesn't use TSC
scaling for its guests, even when the feature is advertised, and KVM
filters SECONDARY_EXEC_TSC_SCALING out when creating L2 controls from
L1's VMCS. This leads to L2 running with the default frequency (matching
host's) while L1 is running with an altered one.

Keep SECONDARY_EXEC_TSC_SCALING in secondary exec controls for L2 when
it was set for L1. TSC_MULTIPLIER is already correctly computed and
written by prepare_vmcs02().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Fixes: d041b5ea93352b ("KVM: nVMX: Enable nested TSC scaling")
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20220712135009.952805-1-vkuznets@redhat.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2273,7 +2273,6 @@ static void prepare_vmcs02_early(struct
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
 				  SECONDARY_EXEC_ENABLE_VMFUNC |
-				  SECONDARY_EXEC_TSC_SCALING |
 				  SECONDARY_EXEC_DESC);
 
 		if (nested_cpu_has(vmcs12,


