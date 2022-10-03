Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508265F2A99
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiJCHiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiJCHgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:36:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21A5543D4;
        Mon,  3 Oct 2022 00:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36DD7B80E79;
        Mon,  3 Oct 2022 07:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8773BC433D6;
        Mon,  3 Oct 2022 07:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781375;
        bh=sdAyOR43AqkiXWVdDbIOamPiQM5FRcgzb6Smj1jPIlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yf/rXBxIyvgjqEgUoXtmJM4ZxlZAOkFV7FwBRkmYo52kX3Gvrty15k5vDD5vdCE7j
         kvj39Mb+aiR5souHyNLqSTsrQ4tftNF25me+tRC/QOQJk8PXMuxc93eUsdHF7bwR+l
         60OnQ+D7LFHnC4V8Rw0rZqD+h0e3ZKEhfFbPF19U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 098/101] KVM: x86: Hide IA32_PLATFORM_DCA_CAP[31:0] from the guest
Date:   Mon,  3 Oct 2022 09:11:34 +0200
Message-Id: <20221003070726.867663707@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit aae2e72229cdb21f90df2dbe4244c977e5d3265b ]

The only thing reported by CPUID.9 is the value of
IA32_PLATFORM_DCA_CAP[31:0] in EAX. This MSR doesn't even exist in the
guest, since CPUID.1:ECX.DCA[bit 18] is clear in the guest.

Clear CPUID.9 in KVM_GET_SUPPORTED_CPUID.

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220922231854.249383-1-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/cpuid.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3ab498165639..cb14441cee37 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -870,8 +870,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->edx = 0;
 		}
 		break;
-	case 9:
-		break;
 	case 0xa: { /* Architectural Performance Monitoring */
 		struct x86_pmu_capability cap;
 		union cpuid10_eax eax;
-- 
2.35.1



