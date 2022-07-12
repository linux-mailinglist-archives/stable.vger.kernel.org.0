Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A39F572535
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbiGLTMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiGLTLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:11:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1F61020BC;
        Tue, 12 Jul 2022 11:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DBF0B81B96;
        Tue, 12 Jul 2022 18:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36D4C3411C;
        Tue, 12 Jul 2022 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651981;
        bh=aYWEnfUrdNOa/O/Hz1gNm9kJ87MT+55MM125rMDSvKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpYfhLR/M2XRvRnbJylyq621QHpfnU5SvAzoj+YC16ppL7c3hlzjL+B5Pmls8gGab
         My2RX4JWF5tlfcb8Gg+AH4CIh87MJMmdTwy/z80Ibb8OKOPcSSveoqKkx/9+NTJU/o
         Zx1rhtJaYPf8G6CL6AAXI9tESJqEpU568hLOTnhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 5.18 13/61] objtool: skip non-text sections when adding return-thunk sites
Date:   Tue, 12 Jul 2022 20:39:10 +0200
Message-Id: <20220712183237.480998789@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
References: <20220712183236.931648980@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1308,7 +1308,9 @@ static void add_return_call(struct objto
 	insn->type = INSN_RETURN;
 	insn->retpoline_safe = true;
 
-	list_add_tail(&insn->call_node, &file->return_thunk_list);
+	/* Skip the non-text sections, specially .discard ones */
+	if (insn->sec->text)
+		list_add_tail(&insn->call_node, &file->return_thunk_list);
 }
 
 static bool same_function(struct instruction *insn1, struct instruction *insn2)


