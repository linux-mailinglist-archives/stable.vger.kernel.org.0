Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94B75724F2
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235633AbiGLTKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiGLTIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:08:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F4AFD537;
        Tue, 12 Jul 2022 11:51:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B576FB81BBC;
        Tue, 12 Jul 2022 18:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19369C3411C;
        Tue, 12 Jul 2022 18:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651916;
        bh=c7cT0pGJvYgrreCApbBPIWLaruKPYpFkqKQ21dEuQZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U19wlParvmSKrHdqJA48UsKe91RpdWpPnTkXgFEtCDIJ5vBIiDVhF3/WObfouTs6b
         voH1LsmJjzxzpF4B8UzbilAfJ4qwAlTipZn9wJYkAnQZfLCXzFB27vBOl5O45A/a4/
         wv5+OUYLSRMUpwarZWPJ8isU1iPFzRlfSdfcXKVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 22/61] objtool: Treat .text.__x86.* as noinstr
Date:   Tue, 12 Jul 2022 20:39:19 +0200
Message-Id: <20220712183237.837418060@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 951ddecf435659553ed15a9214e153a3af43a9a1 upstream.

Needed because zen_untrain_ret() will be called from noinstr code.

Also makes sense since the thunks MUST NOT contain instrumentation nor
be poked with dynamic instrumentation.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -374,7 +374,8 @@ static int decode_instructions(struct ob
 			sec->text = true;
 
 		if (!strcmp(sec->name, ".noinstr.text") ||
-		    !strcmp(sec->name, ".entry.text"))
+		    !strcmp(sec->name, ".entry.text") ||
+		    !strncmp(sec->name, ".text.__x86.", 12))
 			sec->noinstr = true;
 
 		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {


