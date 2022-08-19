Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CDE59A515
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353888AbiHSQqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353994AbiHSQph (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B150012A541;
        Fri, 19 Aug 2022 09:11:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87032B8281F;
        Fri, 19 Aug 2022 16:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8361C43140;
        Fri, 19 Aug 2022 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925500;
        bh=WvyG+94LYEo2znHh2hcujvdWIRJskdaodJa1c98wPh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVdj30jkozDcgU1hbu4Om8H+w3qBHp4Apv6MfQ/6+tioqT7rafQwR6kspT4ZZ7zjn
         GwQsIEvsNPxpJ5g3SheKkayFNS9Vzy0QHAsBB4JhEK1jQmupoNZFeWcxn1FVd/xsjb
         q9farQpf5TpmtyZNy4YHYE3HKfc/nao2IMIePvwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lev Kujawski <lkujaw@member.fsf.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 470/545] KVM: set_msr_mce: Permit guests to ignore single-bit ECC errors
Date:   Fri, 19 Aug 2022 17:44:00 +0200
Message-Id: <20220819153850.434906502@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Lev Kujawski <lkujaw@member.fsf.org>

[ Upstream commit 0471a7bd1bca2a47a5f378f2222c5cf39ce94152 ]

Certain guest operating systems (e.g., UNIXWARE) clear bit 0 of
MC1_CTL to ignore single-bit ECC data errors.  Single-bit ECC data
errors are always correctable and thus are safe to ignore because they
are informational in nature rather than signaling a loss of data
integrity.

Prior to this patch, these guests would crash upon writing MC1_CTL,
with resultant error messages like the following:

error: kvm run failed Operation not permitted
EAX=fffffffe EBX=fffffffe ECX=00000404 EDX=ffffffff
ESI=ffffffff EDI=00000001 EBP=fffdaba4 ESP=fffdab20
EIP=c01333a5 EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
CS =0100 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
SS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0108 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
FS =0000 00000000 ffffffff 00c00000
GS =0000 00000000 ffffffff 00c00000
LDT=0118 c1026390 00000047 00008200 DPL=0 LDT
TR =0110 ffff5af0 00000067 00008b00 DPL=0 TSS32-busy
GDT=     ffff5020 000002cf
IDT=     ffff52f0 000007ff
CR0=8001003b CR2=00000000 CR3=0100a000 CR4=00000230
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
DR6=ffff0ff0 DR7=00000400
EFER=0000000000000000
Code=08 89 01 89 51 04 c3 8b 4c 24 08 8b 01 8b 51 04 8b 4c 24 04 <0f>
30 c3 f7 05 a4 6d ff ff 10 00 00 00 74 03 0f 31 c3 33 c0 33 d2 c3 8d
74 26 00 0f 31 c3

Signed-off-by: Lev Kujawski <lkujaw@member.fsf.org>
Message-Id: <20220521081511.187388-1-lkujaw@member.fsf.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 29a8ca95c581..23a5e5880615 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2862,10 +2862,13 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			/* only 0 or all 1s can be written to IA32_MCi_CTL
 			 * some Linux kernels though clear bit 10 in bank 4 to
 			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
-			 * this to avoid an uncatched #GP in the guest
+			 * this to avoid an uncatched #GP in the guest.
+			 *
+			 * UNIXWARE clears bit 0 of MC1_CTL to ignore
+			 * correctable, single-bit ECC data errors.
 			 */
 			if ((offset & 0x3) == 0 &&
-			    data != 0 && (data | (1 << 10)) != ~(u64)0)
+			    data != 0 && (data | (1 << 10) | 1) != ~(u64)0)
 				return -1;
 
 			/* MCi_STATUS */
-- 
2.35.1



