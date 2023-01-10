Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC52664A0D
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbjAJS3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239376AbjAJS2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:28:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A0B4D48C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:24:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 547DE6183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6163CC433D2;
        Tue, 10 Jan 2023 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375041;
        bh=nkNY/YWi3BOdsEN6IBFEr4lJ+T5eCmX4rClZNjm0SkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+PKxXU3uWNbHVXHNDoOl+zPMaJfc3twA2TkcVDlvo+NFk0wtZe6XszJNNP54jtnL
         5usHtRv/c6ag+bfqLdEu5qvy5uu0P1DT+GgaeIpGaaRHsrZ44hGW8x5BHgpC2sOzbB
         pqqapWxE/fEUb/l9PuhicP+vbGB+zr1CFv5tYdlk=
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
Subject: [PATCH 5.15 031/290] objtool: Fix SEGFAULT
Date:   Tue, 10 Jan 2023 19:02:03 +0100
Message-Id: <20230110180032.660713488@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
index edac5aaa2802..308c8806ad94 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -197,7 +197,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		return false;
 
 	insn = find_insn(file, func->sec, func->offset);
-	if (!insn->func)
+	if (!insn || !insn->func)
 		return false;
 
 	func_for_each_insn(file, func, insn) {
-- 
2.35.1



