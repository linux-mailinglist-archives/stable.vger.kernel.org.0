Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020D35723C9
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbiGLSwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiGLSvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD54E5862;
        Tue, 12 Jul 2022 11:44:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D0256090C;
        Tue, 12 Jul 2022 18:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42950C3411C;
        Tue, 12 Jul 2022 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651469;
        bh=0A1ecswK9RXwOpzgxQteXqxtREg2wIgo60mGWUG+KJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBk1unAC49UleUX2MXGaH7n5/aCFT76zSyhiBBGlgfbfU5Pr/iseZiq2Ek4L/pvax
         FG6NEGvnHmHArBwr04ag2ww7HM627h7uMi9z8t/dSBf16bmciELJP+rY0a7kkhTxq0
         t42eVoeF2jDp4tJLIj6MCmOTmq0LWRaSlIjnkfqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 086/130] objtool: skip non-text sections when adding return-thunk sites
Date:   Tue, 12 Jul 2022 20:38:52 +0200
Message-Id: <20220712183250.428122574@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

The .discard.text section is added in order to reserve BRK, with a
temporary function just so it can give it a size. This adds a relocation to
the return thunk, which objtool will add to the .return_sites section.
Linking will then fail as there are references to the .discard.text
section.

Do not add instructions from non-text sections to the list of return thunk
calls, avoiding the reference to .discard.text.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1090,7 +1090,9 @@ static void add_return_call(struct objto
 	insn->type = INSN_RETURN;
 	insn->retpoline_safe = true;
 
-	list_add_tail(&insn->call_node, &file->return_thunk_list);
+	/* Skip the non-text sections, specially .discard ones */
+	if (insn->sec->text)
+		list_add_tail(&insn->call_node, &file->return_thunk_list);
 }
 
 /*


