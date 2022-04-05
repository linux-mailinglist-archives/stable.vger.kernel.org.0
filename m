Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A65F4F3546
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbiDEInU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241092AbiDEIcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F27F140E9;
        Tue,  5 Apr 2022 01:27:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BE1D6117A;
        Tue,  5 Apr 2022 08:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF32C385A1;
        Tue,  5 Apr 2022 08:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147234;
        bh=N4rx6pWwLPSG5htHGfFAx9Yk8l70kV+U477qUVm/Oh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEgkqWOOuLzdb+RCTmca93e6VakHikx5MuTnQ88Czayf6DljRaPgY1LmlBxjfbVj6
         A+9x/s/T50v3g0c5XiCGJUJ9vrjJuo1d0Hed/C6MZmk/7Svb1IubExZcR7xwBxxoXZ
         53me2lL5y1ION1WdFZ7VN3ocOR4z29wX9JDU01wQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 1001/1126] KVM: x86: fix sending PV IPI
Date:   Tue,  5 Apr 2022 09:29:08 +0200
Message-Id: <20220405070436.873241661@linuxfoundation.org>
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
@@ -517,7 +517,7 @@ static void __send_ipi_mask(const struct
 		} else if (apic_id < min && max - apic_id < KVM_IPI_CLUSTER_SIZE) {
 			ipi_bitmap <<= min - apic_id;
 			min = apic_id;
-		} else if (apic_id < min + KVM_IPI_CLUSTER_SIZE) {
+		} else if (apic_id > min && apic_id < min + KVM_IPI_CLUSTER_SIZE) {
 			max = apic_id < max ? max : apic_id;
 		} else {
 			ret = kvm_hypercall4(KVM_HC_SEND_IPI, (unsigned long)ipi_bitmap,


