Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159A46AF542
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbjCGTXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbjCGTXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:23:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C3A9545D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90660B817C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54A4C433EF;
        Tue,  7 Mar 2023 19:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216128;
        bh=A4Kh/7tR0RgONg0Vpt9u7urjVgyYEX6ZUOZWZCtrc5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2G86/zjzWCsjuJmlgyo0HwFMZmGM4QKryLcdoWVIxct0ZwahwNOehqyzFHNbrrHC
         MrkgDzzh80l2F4NBJfxu/cvhfxMn/tmD2t4CUhJ7l+5iU9/5IwAf9a/xfZHeqpfsLO
         AQYpx8SsHgssH03XVLGcGwwVNCrEJ0W+uzwvBlhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Orr <marcorr@google.com>,
        Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 467/567] KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI
Date:   Tue,  7 Mar 2023 18:03:23 +0100
Message-Id: <20230307165926.118175386@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit ba5838abb05334e4abfdff1490585c7f365e0424 upstream.

Inject a #GP if the guest attempts to set reserved bits in the x2APIC-only
Self-IPI register.  Bits 7:0 hold the vector, all other bits are reserved.

Reported-by: Marc Orr <marcorr@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20230107011025.565472-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2127,10 +2127,14 @@ int kvm_lapic_reg_write(struct kvm_lapic
 		break;
 
 	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic))
-			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
-		else
+		/*
+		 * Self-IPI exists only when x2APIC is enabled.  Bits 7:0 hold
+		 * the vector, everything else is reserved.
+		 */
+		if (!apic_x2apic_mode(apic) || (val & ~APIC_VECTOR_MASK))
 			ret = 1;
+		else
+			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
 		break;
 	default:
 		ret = 1;


