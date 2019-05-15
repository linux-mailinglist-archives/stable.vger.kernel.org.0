Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0FB41ED7C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfEOLJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbfEOLJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E08E20862;
        Wed, 15 May 2019 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918594;
        bh=Jz9Qd95EASPYMKe7kvk/pqXF6X102gSFsEGbQLd1EkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eciQlGLNbqxH8juHyIP3qZa1M3fTHtlBBk0Bh1Y4+EZbnrGyyBWiP/W3OvU14j2iz
         E4Xdy7hcYbw8P7R5Xche9KZnuZGt2WXrNHKq8+El8MQzWOhvW1kl4zfz84mjeW+WqD
         uymjxtia7N0W7vc87M8Y+RQXeJ/4gLzf4eMATmB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bpetkov@suse.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 191/266] x86/bugs: Fix the AMD SSBD usage of the SPEC_CTRL MSR
Date:   Wed, 15 May 2019 12:54:58 +0200
Message-Id: <20190515090729.403842435@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit 612bc3b3d4be749f73a513a17d9b3ee1330d3487 upstream.

On AMD, the presence of the MSR_SPEC_CTRL feature does not imply that the
SSBD mitigation support should use the SPEC_CTRL MSR. Other features could
have caused the MSR_SPEC_CTRL feature to be set, while a different SSBD
mitigation option is in place.

Update the SSBD support to check for the actual SSBD features that will
use the SPEC_CTRL MSR.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Borislav Petkov <bpetkov@suse.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 6ac2f49edb1e ("x86/bugs: Add AMD's SPEC_CTRL MSR usage")
Link: http://lkml.kernel.org/r/20180702213602.29202.33151.stgit@tlendack-t1.amdoffice.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -157,7 +157,8 @@ x86_virt_spec_ctrl(u64 guest_spec_ctrl,
 		guestval |= guest_spec_ctrl & x86_spec_ctrl_mask;
 
 		/* SSBD controlled in MSR_SPEC_CTRL */
-		if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
+		if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
+		    static_cpu_has(X86_FEATURE_AMD_SSBD))
 			hostval |= ssbd_tif_to_spec_ctrl(ti->flags);
 
 		if (hostval != guestval) {
@@ -526,9 +527,10 @@ static enum ssb_mitigation __init __ssb_
 		 * Intel uses the SPEC CTRL MSR Bit(2) for this, while AMD may
 		 * use a completely different MSR and bit dependent on family.
 		 */
-		if (!static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
+		if (!static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
+		    !static_cpu_has(X86_FEATURE_AMD_SSBD)) {
 			x86_amd_ssb_disable();
-		else {
+		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
 			x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
 			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);


