Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1586214DD
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbiKHOGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiKHOFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5457055E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:05:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 811FDB816DD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D86C433C1;
        Tue,  8 Nov 2022 14:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916346;
        bh=go3UbA7rvhJWmOY4cnSyTvr38d1OkzjIaoZZ4vAf6Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2gJ7u1sy7M7Dmw+8B7EQftv62GYpxcE52FR+kEPBHYlI7JUc/fuaRDPanLUB5Ri7Q
         G4tjPd4PoN1n1EZR0B9d7bRgnUvD2gXrF0tQWMgRcKYfzZYG+YnraeA1TLfFB87ioT
         8okauuoDG5xm0UtvAyAj3/xsm8zvoDoi7cswFblM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 135/144] KVM: x86: emulator: update the emulation mode after rsm
Date:   Tue,  8 Nov 2022 14:40:12 +0100
Message-Id: <20221108133351.003451096@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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
@@ -2646,7 +2646,7 @@ static int em_rsm(struct x86_emulate_ctx
 	 * those side effects need to be explicitly handled for both success
 	 * and shutdown.
 	 */
-	return X86EMUL_CONTINUE;
+	return emulator_recalc_and_set_mode(ctxt);
 
 emulate_shutdown:
 	ctxt->ops->triple_fault(ctxt);


