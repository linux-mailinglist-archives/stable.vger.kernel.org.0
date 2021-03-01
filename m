Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4665328750
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbhCARWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235811AbhCAROC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DDCD65042;
        Mon,  1 Mar 2021 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617137;
        bh=gXbvBo7gC3gwCUnskLruRZA2ZXWf8pL0VuSO9q3H7kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pu0+jh+sudVj3tCP5KQVHrV3CgY/k08dT1158S6oemOXzq8xYyCNjRTByeIZQfsaR
         d/Kp4+So5sCS8tEbFKl90qrFEWyrnEka6ufyS7Oi+advwxA2d2WhYe53oUp43y2NcN
         AkYtpPwDzaRiOKQKsHRMJa/F4qSWDqCj/xADW8h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Zhe <zhe.he@windriver.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 215/247] arm64: uprobe: Return EOPNOTSUPP for AARCH32 instruction probing
Date:   Mon,  1 Mar 2021 17:13:55 +0100
Message-Id: <20210301161042.196645943@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

commit d47422d953e258ad587b5edf2274eb95d08bdc7d upstream.

As stated in linux/errno.h, ENOTSUPP should never be seen by user programs.
When we set up uprobe with 32-bit perf and arm64 kernel, we would see the
following vague error without useful hint.

The sys_perf_event_open() syscall returned with 524 (INTERNAL ERROR:
strerror_r(524, [buf], 128)=22)

Use EOPNOTSUPP instead to indicate such cases.

Signed-off-by: He Zhe <zhe.he@windriver.com>
Link: https://lore.kernel.org/r/20210223082535.48730-1-zhe.he@windriver.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/probes/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/probes/uprobes.c
+++ b/arch/arm64/kernel/probes/uprobes.c
@@ -41,7 +41,7 @@ int arch_uprobe_analyze_insn(struct arch
 
 	/* TODO: Currently we do not support AARCH32 instruction probing */
 	if (mm->context.flags & MMCF_AARCH32)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	else if (!IS_ALIGNED(addr, AARCH64_INSN_SIZE))
 		return -EINVAL;
 


