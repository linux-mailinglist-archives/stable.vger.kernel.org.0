Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86CA483317
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbiACOdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234624AbiACObW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:31:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159F7C0617A1;
        Mon,  3 Jan 2022 06:31:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5AACB80F03;
        Mon,  3 Jan 2022 14:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16857C36AFF;
        Mon,  3 Jan 2022 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220258;
        bh=AicelTekhKQs7HjX2xn6r5Y5BecgrtTsjiw0hp7Mca4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rz564MYmLFy0WVySpffq9oYzS4NgJR8Namw3AGMwhCRq5jypFSpRaujAzEbj3uRoG
         xHASoxagH55f7W9FfbKStk3sQd3HPWrRt31rwrsOCdCGFTzZzlXDQbgHSXp7yN77j+
         56e0unbA6lZUeBPZAwWl0AuKiBLgrtrzMRtLdjwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 5.15 13/73] powerpc/ptdump: Fix DEBUG_WX since generic ptdump conversion
Date:   Mon,  3 Jan 2022 15:23:34 +0100
Message-Id: <20220103142057.342309761@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 8d84fca4375e3c35dadc16b8c7eee6821b2a575c upstream.

In note_prot_wx() we bail out without reporting anything if
CONFIG_PPC_DEBUG_WX is disabled.

But CONFIG_PPC_DEBUG_WX was removed in the conversion to generic ptdump,
we now need to use CONFIG_DEBUG_WX instead.

Fixes: e084728393a5 ("powerpc/ptdump: Convert powerpc to GENERIC_PTDUMP")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20211203124112.2912562-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/ptdump/ptdump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/ptdump/ptdump.c
+++ b/arch/powerpc/mm/ptdump/ptdump.c
@@ -183,7 +183,7 @@ static void note_prot_wx(struct pg_state
 {
 	pte_t pte = __pte(st->current_flags);
 
-	if (!IS_ENABLED(CONFIG_PPC_DEBUG_WX) || !st->check_wx)
+	if (!IS_ENABLED(CONFIG_DEBUG_WX) || !st->check_wx)
 		return;
 
 	if (!pte_write(pte) || !pte_exec(pte))


