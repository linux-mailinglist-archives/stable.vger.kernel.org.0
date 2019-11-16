Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E5FFF07D
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbfKPQF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730672AbfKPPvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:09 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 239D9208CE;
        Sat, 16 Nov 2019 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919468;
        bh=jPgVZdWq1uxqLuuFB4zn5NW/loTd09gJehXLV22OFX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+FwkJW7PJsxsSVuqnUaA8qk3ZmlKGUW8VvFZqgbCRf+7nAg2nfQELpPXNYl+MVGT
         +VxLP1O1ROsGL25ahZzq60cxv4qON5Pr8gsnsQnjMOMu7D4EJzSezaI11d90/jvai2
         2wc1zKbYjSqE2Px2Zny7ESQ57EMvUJ8pePNAxtoY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 06/99] powerpc/eeh: Fix use of EEH_PE_KEEP on wrong field
Date:   Sat, 16 Nov 2019 10:49:29 -0500
Message-Id: <20191116155103.10971-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit 473af09b56dc4be68e4af33220ceca6be67aa60d ]

eeh_add_to_parent_pe() sometimes removes the EEH_PE_KEEP flag, but it
incorrectly removes it from pe->type, instead of pe->state.

However, rather than clearing it from the correct field, remove it.
Inspection of the code shows that it can't ever have had any effect
(even if it had been cleared from the correct field), because the
field is never tested after it is cleared by the statement in
question.

The clear statement was added by commit 807a827d4e74 ("powerpc/eeh:
Keep PE during hotplug"), but it didn't explain why it was necessary.

Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_pe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/eeh_pe.c b/arch/powerpc/kernel/eeh_pe.c
index 1abd8dd77ec13..eee2131a97e61 100644
--- a/arch/powerpc/kernel/eeh_pe.c
+++ b/arch/powerpc/kernel/eeh_pe.c
@@ -370,7 +370,7 @@ int eeh_add_to_parent_pe(struct eeh_dev *edev)
 		while (parent) {
 			if (!(parent->type & EEH_PE_INVALID))
 				break;
-			parent->type &= ~(EEH_PE_INVALID | EEH_PE_KEEP);
+			parent->type &= ~EEH_PE_INVALID;
 			parent = parent->parent;
 		}
 
-- 
2.20.1

