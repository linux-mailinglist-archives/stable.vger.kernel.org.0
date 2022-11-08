Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592FD6212F0
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbiKHNog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbiKHNod (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:44:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9368058007
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:44:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51646B81AEE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8968FC4314D;
        Tue,  8 Nov 2022 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915070;
        bh=cn/D4miHMAh3UbaG+RCo2+HezdPgLbeL4bfdIIMI8Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxkzep9E61wqgZdJ+j+0BQ0BJeDg74WOHofdrcMN4QF1+Gt+9KlxKtiPCH+IwzBFV
         3ihxHhw+E1HoPkIsYhgKj2qZ1EpVIpNECg1FRSCqRxrdDAVJD4y3yhfe+XerLyVO+5
         OKOxqYWiWtelfXECMQN+Qb5ocGrNYUReyGJsFZmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 34/40] KVM: x86: emulator: em_sysexit should update ctxt->mode
Date:   Tue,  8 Nov 2022 14:39:19 +0100
Message-Id: <20221108133329.621426523@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
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

commit 5015bb89b58225f97df6ac44383e7e8c8662c8c9 upstream.

SYSEXIT is one of the instructions that can change the
processor mode, thus ctxt->mode should be updated after it.

Note that this is likely a benign bug, because the only problematic
mode change is from 32 bit to 64 bit which can lead to truncation of RIP,
and it is not possible to do with sysexit,
since sysexit running in 32 bit mode will be limited to 32 bit version.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-11-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2889,6 +2889,7 @@ static int em_sysexit(struct x86_emulate
 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
 
 	ctxt->_eip = rdx;
+	ctxt->mode = usermode;
 	*reg_write(ctxt, VCPU_REGS_RSP) = rcx;
 
 	return X86EMUL_CONTINUE;


