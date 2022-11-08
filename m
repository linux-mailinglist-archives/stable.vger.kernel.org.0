Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B097A6215E8
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiKHOQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiKHOQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDD670541
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E014615C0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2471C433D6;
        Tue,  8 Nov 2022 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667917001;
        bh=XIwVFJZUlGAhxk6uVss/Xf7t+pPTVXYx4EAvps/w06o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jXIfrOAOi7y1G8cpRzMDtkZQqfMcPRq2swmzaGYE4Ls6nnoK6HiIJoYI5aLbTW5wN
         XmTeY9GLIDlNUQjKw7KVWobm1h+Vz5Vs6H0BuTH1OvpJmU+z+j85QX04Gwy1BOrYHI
         /88hpXlKENPSRLsITPWsJfc7mfslSOH8EEbNyvyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 186/197] KVM: x86: emulator: update the emulation mode after rsm
Date:   Tue,  8 Nov 2022 14:40:24 +0100
Message-Id: <20221108133403.349266347@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

commit 055f37f84e304e59c046d1accfd8f08462f52c4c upstream.

Update the emulation mode after RSM so that RIP will be correctly
written back, because the RSM instruction can switch the CPU mode from
32 bit (or less) to 64 bit.

This fixes a guest crash in case the #SMI is received while the guest
runs a code from an address > 32 bit.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-13-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2660,7 +2660,7 @@ static int em_rsm(struct x86_emulate_ctx
 	 * those side effects need to be explicitly handled for both success
 	 * and shutdown.
 	 */
-	return X86EMUL_CONTINUE;
+	return emulator_recalc_and_set_mode(ctxt);
 
 emulate_shutdown:
 	ctxt->ops->triple_fault(ctxt);


