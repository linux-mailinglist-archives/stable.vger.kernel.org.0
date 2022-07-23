Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA0757EE14
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238574AbiGWKG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238430AbiGWKGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:06:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A496BE9CC;
        Sat, 23 Jul 2022 03:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DCB9611BF;
        Sat, 23 Jul 2022 10:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982B2C341C0;
        Sat, 23 Jul 2022 10:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570459;
        bh=oAN6Q4dQiIIJu3yvwAyYImnSQUKBxZrz7e4pEBocnjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vv5QUkoDaMtURlGC8rSwUr9mlNQd2F4RcpkDJVee6gohyzjZtF4iHg9cmeTASUfH
         e7N7bUjxQPxp/8wuYXYUf3gRUiEHMnucK4kb9PrZLSTz/msJKaOKazfcDp9rm9DQis
         F1cRLg9vSMIXPWXxLUMSE13ilCSGH4ps53YOhiHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 094/148] objtool: Treat .text.__x86.* as noinstr
Date:   Sat, 23 Jul 2022 11:55:06 +0200
Message-Id: <20220723095250.747563428@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -366,7 +366,8 @@ static int decode_instructions(struct ob
 			sec->text = true;
 
 		if (!strcmp(sec->name, ".noinstr.text") ||
-		    !strcmp(sec->name, ".entry.text"))
+		    !strcmp(sec->name, ".entry.text") ||
+		    !strncmp(sec->name, ".text.__x86.", 12))
 			sec->noinstr = true;
 
 		for (offset = 0; offset < sec->len; offset += insn->len) {


