Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A595C57DE5B
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbiGVJSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiGVJSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:18:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15A6B87AF;
        Fri, 22 Jul 2022 02:12:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E82561F65;
        Fri, 22 Jul 2022 09:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A085C341C6;
        Fri, 22 Jul 2022 09:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481172;
        bh=WK8DbHid5KLbLdiibt9WMsu16ETa4CTZT9zNegHjyDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuvVGmg2R14P3UwH3O0cMV7ALRHSRkvUrv1IraJ94Fjr0e5sJvz0LbAK1uc7carg1
         FPnH/B1grgJxnF0BR9RkjfFnDm2r/abgS5oXH7sIQh3VLCVnS/E3iDB27bM+HZgKgt
         ovO+XHxMAwNhQ7BpIMOaTRsuc+UFy/mTOhTA8atc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 07/89] objtool: Shrink struct instruction
Date:   Fri, 22 Jul 2022 11:10:41 +0200
Message-Id: <20220722091133.784963422@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit c509331b41b7365e17396c246e8c5797bccc8074 upstream.

Any one instruction can only ever call a single function, therefore
insn->mcount_loc_node is superfluous and can use insn->call_node.

This shrinks struct instruction, which is by far the most numerous
structure objtool creates.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120309.785456706@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c                 |    6 +++---
 tools/objtool/include/objtool/check.h |    1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -551,7 +551,7 @@ static int create_mcount_loc_sections(st
 		return 0;
 
 	idx = 0;
-	list_for_each_entry(insn, &file->mcount_loc_list, mcount_loc_node)
+	list_for_each_entry(insn, &file->mcount_loc_list, call_node)
 		idx++;
 
 	sec = elf_create_section(file->elf, "__mcount_loc", 0, sizeof(unsigned long), idx);
@@ -559,7 +559,7 @@ static int create_mcount_loc_sections(st
 		return -1;
 
 	idx = 0;
-	list_for_each_entry(insn, &file->mcount_loc_list, mcount_loc_node) {
+	list_for_each_entry(insn, &file->mcount_loc_list, call_node) {
 
 		loc = (unsigned long *)sec->data->d_buf + idx;
 		memset(loc, 0, sizeof(unsigned long));
@@ -909,7 +909,7 @@ static void annotate_call_site(struct ob
 
 		insn->type = INSN_NOP;
 
-		list_add_tail(&insn->mcount_loc_node, &file->mcount_loc_list);
+		list_add_tail(&insn->call_node, &file->mcount_loc_list);
 		return;
 	}
 }
--- a/tools/objtool/include/objtool/check.h
+++ b/tools/objtool/include/objtool/check.h
@@ -40,7 +40,6 @@ struct instruction {
 	struct list_head list;
 	struct hlist_node hash;
 	struct list_head call_node;
-	struct list_head mcount_loc_node;
 	struct section *sec;
 	unsigned long offset;
 	unsigned int len;


