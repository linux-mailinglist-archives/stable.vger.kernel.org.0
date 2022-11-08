Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D6C6212B4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiKHNmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbiKHNlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:41:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97519554D9
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:41:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E62B161568
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0133DC433D6;
        Tue,  8 Nov 2022 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914913;
        bh=H+rVnxmU+trcU01as69I63fyM9p2ifgjN9GvIGHw59A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5aPiC22652UIXQBfDcCmCCmPqf3U6t0AdH+j6c+qTVE/ag7NobKFcViN4rjVnXUs
         PspGf9Rd8UWnVw3AuOZ7KF2dA+5QOacYhmNLe/a2E0Z6YdgdYVO4jAzOWHZYk3Lf3B
         ni9clB7ayqM6iSFCts/10bbBQkE8ylYfH10G23pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 26/30] KVM: x86: Mask off reserved bits in CPUID.80000008H
Date:   Tue,  8 Nov 2022 14:39:14 +0100
Message-Id: <20221108133327.719386306@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
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

From: Jim Mattson <jmattson@google.com>

commit 7030d8530e533844e2f4b0e7476498afcd324634 upstream.

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. The following ranges of CPUID.80000008H are reserved
and should be masked off:
    ECX[31:18]
    ECX[11:8]

In addition, the PerfTscSize field at ECX[17:16] should also be zero
because KVM does not set the PERFTSC bit at CPUID.80000001H.ECX[27].

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220929225203.2234702-3-jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -647,6 +647,7 @@ static inline int __do_cpuid_ent(struct
 			g_phys_as = phys_as;
 
 		entry->eax = g_phys_as | (virt_as << 8);
+		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		/*
 		 * IBRS, IBPB and VIRT_SSBD aren't necessarily present in


