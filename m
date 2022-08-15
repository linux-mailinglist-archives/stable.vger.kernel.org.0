Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775555950AC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiHPEoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiHPEnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:43:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE4B18C455;
        Mon, 15 Aug 2022 13:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 701BFB80EA8;
        Mon, 15 Aug 2022 20:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA653C433C1;
        Mon, 15 Aug 2022 20:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595907;
        bh=ghh78jSw0lSzoGfYO6TqYjLTNXQCsN5z2aW1GR4J0nY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heeoiCpl/O0X2yCZ7eJE6+X8GKtWl5jeTKwF5V0QEMzJUppMppCwWRfpVa32pZt9E
         JnVTdzCOOI/3ADLD5Wn0EYiq27+KoW+uVECj9+L/eMvZQn7QPsHTRTU7M8QQTB7v8F
         t0t59i77Lzv2A9+sgCWgSOWk6Iblcia/YhwCE+xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Greg Kurz <groug@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0913/1157] KVM: PPC: Book3s: Fix warning about xics_rm_h_xirr_x
Date:   Mon, 15 Aug 2022 20:04:29 +0200
Message-Id: <20220815180515.976365600@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit a784101f77b1bef4b40f4ad68af3f54fcfa5321b ]

This fixes "no previous prototype":

arch/powerpc/kvm/book3s_hv_rm_xics.c:482:15:
warning: no previous prototype for 'xics_rm_h_xirr_x' [-Wmissing-prototypes]

Reported by the kernel test robot.

Fixes: b22af9041927 ("KVM: PPC: Book3s: Remove real mode interrupt controller hcalls handlers")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220622055235.1139204-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_xics.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_xics.h b/arch/powerpc/kvm/book3s_xics.h
index 8e4c79e2fcd8..08fb0843faf5 100644
--- a/arch/powerpc/kvm/book3s_xics.h
+++ b/arch/powerpc/kvm/book3s_xics.h
@@ -143,6 +143,7 @@ static inline struct kvmppc_ics *kvmppc_xics_find_ics(struct kvmppc_xics *xics,
 }
 
 extern unsigned long xics_rm_h_xirr(struct kvm_vcpu *vcpu);
+extern unsigned long xics_rm_h_xirr_x(struct kvm_vcpu *vcpu);
 extern int xics_rm_h_ipi(struct kvm_vcpu *vcpu, unsigned long server,
 			 unsigned long mfrr);
 extern int xics_rm_h_cppr(struct kvm_vcpu *vcpu, unsigned long cppr);
-- 
2.35.1



