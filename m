Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5118660AFC9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 17:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJXP5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiJXP5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:57:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD215104D0C;
        Mon, 24 Oct 2022 07:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE520B819F0;
        Mon, 24 Oct 2022 12:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA4FC433D7;
        Mon, 24 Oct 2022 12:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615745;
        bh=wCTQ1FbgIlRW/5a+475F/THBy/d7TlzgYuS+JRvswZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOIwPBg62O2vyS1QpimbWfk7Pe3le2OtMgTpBb+8pRkQe18mR7ymk5jLAGLkdwIIj
         wO2e5ybsPjYkhQEbsM+nv1WElHc0mhlRgk8kHzGt/qtnFkiHxRJJsGgyR0/31kAFY+
         UMfCTqOYc/M7MAJ5WKXo/atn0r7bViOOZqIy4Ylc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/530] x86/hyperv: Fix struct hv_enlightened_vmcs definition
Date:   Mon, 24 Oct 2022 13:31:52 +0200
Message-Id: <20221024113101.687963053@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit ea9da788a61e47e7ab9cbad397453e51cd82ac0d ]

Section 1.9 of TLFS v6.0b says:

"All structures are padded in such a way that fields are aligned
naturally (that is, an 8-byte field is aligned to an offset of 8 bytes
and so on)".

'struct enlightened_vmcs' has a glitch:

...
        struct {
                u32                nested_flush_hypercall:1; /*   836: 0  4 */
                u32                msr_bitmap:1;         /*   836: 1  4 */
                u32                reserved:30;          /*   836: 2  4 */
        } hv_enlightenments_control;                     /*   836     4 */
        u32                        hv_vp_id;             /*   840     4 */
        u64                        hv_vm_id;             /*   844     8 */
        u64                        partition_assist_page; /*   852     8 */
...

And the observed values in 'partition_assist_page' make no sense at
all. Fix the layout by padding the structure properly.

Fixes: 68d1eb72ee99 ("x86/hyper-v: define struct hv_enlightened_vmcs and clean field bits")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20220830133737.1539624-2-vkuznets@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 2322d6bd5883..b54b3e18d94b 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -529,7 +529,7 @@ struct hv_enlightened_vmcs {
 	u64 guest_rip;
 
 	u32 hv_clean_fields;
-	u32 hv_padding_32;
+	u32 padding32_1;
 	u32 hv_synthetic_controls;
 	struct {
 		u32 nested_flush_hypercall:1;
@@ -537,7 +537,7 @@ struct hv_enlightened_vmcs {
 		u32 reserved:30;
 	}  __packed hv_enlightenments_control;
 	u32 hv_vp_id;
-
+	u32 padding32_2;
 	u64 hv_vm_id;
 	u64 partition_assist_page;
 	u64 padding64_4[4];
-- 
2.35.1



