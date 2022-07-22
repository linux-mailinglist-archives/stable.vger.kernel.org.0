Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29D057DE83
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235654AbiGVJXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbiGVJXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:23:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437C0C0B66;
        Fri, 22 Jul 2022 02:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBEB61FE8;
        Fri, 22 Jul 2022 09:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536A1C341C7;
        Fri, 22 Jul 2022 09:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481288;
        bh=VEwD7HDK+GCawLa0c4jmzeQJ+ECieF4S2F7mT7L5NVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIjnOfk4j7l2O+s5RV6X0SCRgI6zLyGpCP56sRgYgOdnXxYtQvIfNRuBP/3Am4jNy
         kJ8lwdLqXDTGR6eIKe6tdzER2zhpvag/HH7ktPAcjOp7l4TKg3hmmoXbyIuLKH9TFJ
         qtRYVMun4Y7z2Ek1ra0PtF42v0tOFcK/1TTaIkuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 40/89] objtool: Treat .text.__x86.* as noinstr
Date:   Fri, 22 Jul 2022 11:11:14 +0200
Message-Id: <20220722091135.609921357@linuxfoundation.org>
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
@@ -367,7 +367,8 @@ static int decode_instructions(struct ob
 			sec->text = true;
 
 		if (!strcmp(sec->name, ".noinstr.text") ||
-		    !strcmp(sec->name, ".entry.text"))
+		    !strcmp(sec->name, ".entry.text") ||
+		    !strncmp(sec->name, ".text.__x86.", 12))
 			sec->noinstr = true;
 
 		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {


