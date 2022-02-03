Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02304A8D6B
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240051AbiBCUao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:30:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35590 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354115AbiBCUaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:30:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 695F361A56;
        Thu,  3 Feb 2022 20:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0C1C36AE3;
        Thu,  3 Feb 2022 20:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920213;
        bh=PKFm0sE3iMB94aMb4kUoSynBy19rolL5hhSmfs8lpww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUNn9bLH8sYTQjGjLwWYClKYvCUIKOCMqtctHvBSrwIkdX+bwyqecCXcLJpiyA5Ww
         fdp5OKa4yFOSG1edrjyhDXtJKmIbjI7DwCd9rxlSx6BkM8/vnuJodPeDkUGb0mpHip
         iz80Wpl5mzrz2pnHYtFvl+cmEd8T7zZ4Ca6xt68P2orZaLq8AmdarJCzlVxgVG7pW9
         OkqY9lzf5iGEkTOzRcuaT0AfWEwnZisujSh3q6L5/941Iwk49i55wuxvy98+/Vtg+k
         8vdr7ghBCnW7OqunV6V9Zfs6NeTw//C7NIsIoicldBQa5M93NvpEzm0imSjp/XhvY2
         0KWqd2rat0ZRA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 16/52] x86/perf: Avoid warning for Arch LBR without XSAVE
Date:   Thu,  3 Feb 2022 15:29:10 -0500
Message-Id: <20220203202947.2304-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[ Upstream commit 8c16dc047b5dd8f7b3bf4584fa75733ea0dde7dc ]

Some hypervisors support Arch LBR, but without the LBR XSAVE support.
The current Arch LBR init code prints a warning when the xsave size (0) is
unexpected. Avoid printing the warning for the "no LBR XSAVE" case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20211215204029.150686-1-ak@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/lbr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 8043213b75a52..fa947c4fbd1f8 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1726,6 +1726,9 @@ static bool is_arch_lbr_xsave_available(void)
 	 * Check the LBR state with the corresponding software structure.
 	 * Disable LBR XSAVES support if the size doesn't match.
 	 */
+	if (xfeature_size(XFEATURE_LBR) == 0)
+		return false;
+
 	if (WARN_ON(xfeature_size(XFEATURE_LBR) != get_lbr_state_size()))
 		return false;
 
-- 
2.34.1

