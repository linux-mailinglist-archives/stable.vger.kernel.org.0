Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73BC5010C6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244688AbiDNNhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244765AbiDNN2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359A7A5EA2;
        Thu, 14 Apr 2022 06:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1B756125A;
        Thu, 14 Apr 2022 13:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC330C385A5;
        Thu, 14 Apr 2022 13:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942452;
        bh=M17IKYJWhPg4SFCSQnJGvSE2qWIo5R3jjaDEMUuAmuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jmq2h6g8hjBkv//V6hW/Qy/4KYvlhay1EwhH4myl0DxVPTytJ08gdGdnO3g91jUqY
         Nqolv/LVgiEEkZqXuOch1Tlq31GV1f634eCHUME18U7zKZofQW4RAJyU/L4wR4BX+8
         2G7MNMeqOwY/j2D7UJiX6hl3eUVbJdG5NgXJCPpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 140/338] KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()
Date:   Thu, 14 Apr 2022 15:10:43 +0200
Message-Id: <20220414110842.889901588@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 3e182c7ae771..63754d248dfb 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1669,11 +1669,6 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		goto exception;
 	}
 
-	if (!seg_desc.p) {
-		err_vec = (seg == VCPU_SREG_SS) ? SS_VECTOR : NP_VECTOR;
-		goto exception;
-	}
-
 	dpl = seg_desc.dpl;
 
 	switch (seg) {
@@ -1713,6 +1708,10 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
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
@@ -1737,6 +1736,11 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
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



