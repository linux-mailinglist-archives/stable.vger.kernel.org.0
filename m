Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58001541D14
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383700AbiFGWHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352519AbiFGWGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17F2252C19;
        Tue,  7 Jun 2022 12:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DD2BB82368;
        Tue,  7 Jun 2022 19:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74C4C385A2;
        Tue,  7 Jun 2022 19:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629337;
        bh=9gkjTA76dgs24GcEIjC4D42xCNupGf2beWLw9aticJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl0B1ZjVAjnQPhFgd6fB7hkrsTaqHgF+GmB9HGfhHVVlYTNaym+EalvlwZcaRpoEy
         aePNK6/SSlNWokLHep9J2mx4kDjoWEODvUHQ3isEzCXv2ipXMpaFf2W6G7W5P+O4TO
         mcMkNQeQJEOJyLUIMOTG4vq2SOsVOJa095VqNik8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 655/879] KVM: LAPIC: Drop pending LAPIC timer injection when canceling the timer
Date:   Tue,  7 Jun 2022 19:02:53 +0200
Message-Id: <20220607165021.857886722@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 66b0eb0bda94..6268880c8eed 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1548,6 +1548,7 @@ static void cancel_apic_timer(struct kvm_lapic *apic)
 	if (apic->lapic_timer.hv_timer_in_use)
 		cancel_hv_timer(apic);
 	preempt_enable();
+	atomic_set(&apic->lapic_timer.pending, 0);
 }
 
 static void apic_update_lvtt(struct kvm_lapic *apic)
-- 
2.35.1



