Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED32540E5F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353583AbiFGSyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354330AbiFGSqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA841269BB;
        Tue,  7 Jun 2022 11:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF34961866;
        Tue,  7 Jun 2022 18:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8CFC34119;
        Tue,  7 Jun 2022 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624848;
        bh=wdQGO9eLxa3Y/y6/4wgsDECPmW9qIK+ZMU2S3wju6Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aH9+dXCSHICKEB07GN5D7ZUoumAHv9uwYijdSrTjyKj+wE+oMJC3AALoH2GafpH1R
         7S5IzZPCEYNdwNLGA3l2zSjcm6F4fqlegw/0tmideEHAcizv1y2ZiJXyKawVPrHka0
         7wBMbb4fSsWOhvUMTEQRk1zx0ouXKg3sy4DiqDvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 474/667] KVM: LAPIC: Drop pending LAPIC timer injection when canceling the timer
Date:   Tue,  7 Jun 2022 19:02:19 +0200
Message-Id: <20220607164948.920660980@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

[ Upstream commit 619f51da097952194a5d4d6a6c5f9ef3b9d1b25a ]

The timer is disarmed when switching between TSC deadline and other modes;
however, the pending timer is still in-flight, so let's accurately remove
any traces of the previous mode.

Fixes: 4427593258 ("KVM: x86: thoroughly disarm LAPIC timer around TSC deadline switch")
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 493d636e6231..8ea4658f48ef 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1506,6 +1506,7 @@ static void cancel_apic_timer(struct kvm_lapic *apic)
 	if (apic->lapic_timer.hv_timer_in_use)
 		cancel_hv_timer(apic);
 	preempt_enable();
+	atomic_set(&apic->lapic_timer.pending, 0);
 }
 
 static void apic_update_lvtt(struct kvm_lapic *apic)
-- 
2.35.1



