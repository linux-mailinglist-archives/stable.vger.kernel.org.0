Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E89332919A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243367AbhCAU2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:45760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243220AbhCAUXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74E39651E0;
        Mon,  1 Mar 2021 18:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621904;
        bh=v9F3rPspb0CiLc1VvoNlM9/+8X8I7v7LA5L/pB1Kkr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=werYVk8OSZvF5OCQ+zsp8HJx7TvQPC9pbZN6xELzMcQHbcjpFdhSmWDX1xcA21Tta
         /7HjBBeMHnd0R8pqgr+B2rMFzac9gxYe8nWWNiS5SC5frGoMjoxPOhAcAf3RUEHTHj
         qjlI4jaBpIUUomDJSonc2SI+DFxfcHHwWaqG7yj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Zhe <zhe.he@windriver.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.11 686/775] arm64: uprobe: Return EOPNOTSUPP for AARCH32 instruction probing
Date:   Mon,  1 Mar 2021 17:14:14 +0100
Message-Id: <20210301161235.283315612@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
@@ -38,7 +38,7 @@ int arch_uprobe_analyze_insn(struct arch
 
 	/* TODO: Currently we do not support AARCH32 instruction probing */
 	if (mm->context.flags & MMCF_AARCH32)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	else if (!IS_ALIGNED(addr, AARCH64_INSN_SIZE))
 		return -EINVAL;
 


