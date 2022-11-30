Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D53E63DDC6
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiK3SaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiK3SaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:30:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8349F8DBED
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 232CDB81B41
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DE1C433D6;
        Wed, 30 Nov 2022 18:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833008;
        bh=9laoublTZwXPOpx4i8qgiZZcYzr2CpBZc1dUrUyOgk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XC7ETxameDmp9uO8TDRPOdy5thDWWt2jVz9z7omBNoZaYIGgVDFLWy7VPsZewLOVe
         LlemfdFHgu4SXvC+dpgv2f9gaEU5wjlkxYZM19tSzHWA6bO7k7K7hv2xqIV3BMAwcd
         GKzNcY1kYmINWcMD64MU4JZI8cpJCMtFIbx7j73o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/162] KVM: x86: emulator: update the emulation mode after rsm
Date:   Wed, 30 Nov 2022 19:23:02 +0100
Message-Id: <20221130180531.230294812@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 055f37f84e304e59c046d1accfd8f08462f52c4c ]

Update the emulation mode after RSM so that RIP will be correctly
written back, because the RSM instruction can switch the CPU mode from
32 bit (or less) to 64 bit.

This fixes a guest crash in case the #SMI is received while the guest
runs a code from an address > 32 bit.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-13-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 63efccc8f429..716d54b624e0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2746,6 +2746,15 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 
 	ctxt->ops->post_leave_smm(ctxt);
 
+	/*
+	 * Note, the ctxt->ops callbacks are responsible for handling side
+	 * effects when writing MSRs and CRs, e.g. MMU context resets, CPUID
+	 * runtime updates, etc...  If that changes, e.g. this flow is moved
+	 * out of the emulator to make it look more like enter_smm(), then
+	 * those side effects need to be explicitly handled for both success
+	 * and shutdown.
+	 */
+
 	return X86EMUL_CONTINUE;
 }
 
-- 
2.35.1



