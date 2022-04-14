Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C1950108E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344582AbiDNODh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345935AbiDNNy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:54:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE7839158;
        Thu, 14 Apr 2022 06:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90D52B828F4;
        Thu, 14 Apr 2022 13:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E77C385A1;
        Thu, 14 Apr 2022 13:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943920;
        bh=OXQboSLCCc6ekno63Z+vQjWUAYh0Kr1qx8wjAgRTReI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4ciQ2dem09PmfOeAQI309aKhlWFvXYxWPj9RInUfvquHcNhcJDw4fIq1nw3UeYWY
         9uODAPQwfXc7UytHzciNmx80KalGqoLqFcrvfyQtzchFAQKgek9l0HExNJxcK+ODwl
         lvT01m60D5ijsiHxotnXhzSf1gUHBnEd1sbPWdSw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 329/475] KVM: x86: fix sending PV IPI
Date:   Thu, 14 Apr 2022 15:11:54 +0200
Message-Id: <20220414110904.293423623@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

commit c15e0ae42c8e5a61e9aca8aac920517cf7b3e94e upstream.

If apic_id is less than min, and (max - apic_id) is greater than
KVM_IPI_CLUSTER_SIZE, then the third check condition is satisfied but
the new apic_id does not fit the bitmask.  In this case __send_ipi_mask
should send the IPI.

This is mostly theoretical, but it can happen if the apic_ids on three
iterations of the loop are for example 1, KVM_IPI_CLUSTER_SIZE, 0.

Fixes: aaffcfd1e82 ("KVM: X86: Implement PV IPIs in linux guest")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Message-Id: <1646814944-51801-1-git-send-email-lirongqing@baidu.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -487,7 +487,7 @@ static void __send_ipi_mask(const struct
 		} else if (apic_id < min && max - apic_id < KVM_IPI_CLUSTER_SIZE) {
 			ipi_bitmap <<= min - apic_id;
 			min = apic_id;
-		} else if (apic_id < min + KVM_IPI_CLUSTER_SIZE) {
+		} else if (apic_id > min && apic_id < min + KVM_IPI_CLUSTER_SIZE) {
 			max = apic_id < max ? max : apic_id;
 		} else {
 			ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,


