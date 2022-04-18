Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99652505808
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiDRN7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244645AbiDRN5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:57:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AECE2AC74;
        Mon, 18 Apr 2022 06:06:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1900260B42;
        Mon, 18 Apr 2022 13:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2039C385A1;
        Mon, 18 Apr 2022 13:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287212;
        bh=v+fV2FTUnMcbAmM9fFyazBBSOL7DKbZIxl4aUYPVLSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwuGn4XdP1KEwCCy0001GJMGMkyT8tDhJ++Z9ly9kkqwciIEfKJFHxBaNW4dYUyuj
         3x0LiC8UJkpLQs9DqvcGHxH3H5Zc/ZE3LaMLVDzAo2W7JXOkLmUmymf79Ort23syNk
         YAcfHr6PuclVJCXL9XpC0MclV88DR2BlnRRENV7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 092/218] KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()
Date:   Mon, 18 Apr 2022 14:12:38 +0200
Message-Id: <20220418121202.239025018@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

[ Upstream commit ca85f002258fdac3762c57d12d5e6e401b6a41af ]

Per Intel's SDM on the "Instruction Set Reference", when
loading segment descriptor, not-present segment check should
be after all type and privilege checks. But the emulator checks
it first, then #NP is triggered instead of #GP if privilege fails
and segment is not present. Put not-present segment check after
type and privilege checks in __load_segment_descriptor().

Fixes: 38ba30ba51a00 (KVM: x86 emulator: Emulate task switch in emulator.c)
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Message-Id: <52573c01d369f506cadcf7233812427cf7db81a7.1644292363.git.houwenlong.hwl@antgroup.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2e5553091f90..3edafdffa687 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1674,11 +1674,6 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		goto exception;
 	}
 
-	if (!seg_desc.p) {
-		err_vec = (seg == VCPU_SREG_SS) ? SS_VECTOR : NP_VECTOR;
-		goto exception;
-	}
-
 	dpl = seg_desc.dpl;
 
 	switch (seg) {
@@ -1718,6 +1713,10 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	case VCPU_SREG_TR:
 		if (seg_desc.s || (seg_desc.type != 1 && seg_desc.type != 9))
 			goto exception;
+		if (!seg_desc.p) {
+			err_vec = NP_VECTOR;
+			goto exception;
+		}
 		old_desc = seg_desc;
 		seg_desc.type |= 2; /* busy */
 		ret = ctxt->ops->cmpxchg_emulated(ctxt, desc_addr, &old_desc, &seg_desc,
@@ -1742,6 +1741,11 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		break;
 	}
 
+	if (!seg_desc.p) {
+		err_vec = (seg == VCPU_SREG_SS) ? SS_VECTOR : NP_VECTOR;
+		goto exception;
+	}
+
 	if (seg_desc.s) {
 		/* mark segment as accessed */
 		if (!(seg_desc.type & 1)) {
-- 
2.34.1



