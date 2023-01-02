Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D6865B09F
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjABL1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjABL0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:26:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FCA5F54
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:24:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 633D0B80D1A
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69A5C433D2;
        Mon,  2 Jan 2023 11:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658693;
        bh=R3xd0iOQ9PqLaoTc61j078SgU9cnRJs8lym2J15gr4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxeulZlOCLOnBb8TwBv+/NELfARXuj8ODyPk/oBD4CXjqFShqAe3tmhs1v+VZ6dNp
         IsjNlf5X+ByVKU9SXJZY7rVlGhksKgEs7wPPXp2X66UoO4WZ7sdc6kz8nXWdCUqvoe
         UZOrKm+/DsOZXL1Z+TJgNScEIIewd++uKmoGeLRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/71] objtool: Fix SEGFAULT
Date:   Mon,  2 Jan 2023 12:21:58 +0100
Message-Id: <20230102110552.845028725@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit efb11fdb3e1a9f694fa12b70b21e69e55ec59c36 ]

find_insn() will return NULL in case of failure. Check insn in order
to avoid a kernel Oops for NULL pointer dereference.

Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221114175754.1131267-9-sv@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index a7f1e6c8bb0a..51494c3002d9 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -207,7 +207,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		return false;
 
 	insn = find_insn(file, func->sec, func->offset);
-	if (!insn->func)
+	if (!insn || !insn->func)
 		return false;
 
 	func_for_each_insn(file, func, insn) {
-- 
2.35.1



