Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E128133B80F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhCOOCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232377AbhCON7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72B8964F22;
        Mon, 15 Mar 2021 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816748;
        bh=gx7uBT8U4+i8w5exb3WkcPRwRM2B1g9/JyoAWrlpxwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atCD9O7j0SvyInEkCgyFq8lLE6JYAuMLksAl+rRSFb4nW4f4WyZisSYOir5Zua8k/
         oXJpccIbJlhBEHVD+q5ltNZuOfKOKwNYqAP81wOcQdu/IPcGdQDxkiNMi+eS5Piyw5
         oAfLLoW5yPERsJrfHHQzAoPNWo84+7zbwTVzfKmA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/95] powerpc: improve handling of unrecoverable system reset
Date:   Mon, 15 Mar 2021 14:57:05 +0100
Message-Id: <20210315135741.425402077@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 11cb0a25f71818ca7ab4856548ecfd83c169aa4d ]

If an unrecoverable system reset hits in process context, the system
does not have to panic. Similar to machine check, call nmi_exit()
before die().

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210130130852.2952424-26-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 0f1a888c04a8..05c1aabad01c 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -360,8 +360,11 @@ void system_reset_exception(struct pt_regs *regs)
 		die("Unrecoverable nested System Reset", regs, SIGABRT);
 #endif
 	/* Must die if the interrupt is not recoverable */
-	if (!(regs->msr & MSR_RI))
+	if (!(regs->msr & MSR_RI)) {
+		/* For the reason explained in die_mce, nmi_exit before die */
+		nmi_exit();
 		die("Unrecoverable System Reset", regs, SIGABRT);
+	}
 
 	if (!nested)
 		nmi_exit();
-- 
2.30.1



