Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F1B57EE0D
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiGWKGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbiGWKFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2EBA0273;
        Sat, 23 Jul 2022 03:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07FE4611D4;
        Sat, 23 Jul 2022 10:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA36C341C7;
        Sat, 23 Jul 2022 10:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570430;
        bh=0A1ecswK9RXwOpzgxQteXqxtREg2wIgo60mGWUG+KJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbrzQCquYevCfV4MN2H93gXuVrji3QjFfqsGj2tOnZu0+SxoHZz+JeZRmDU34zO8P
         /EnOyv7jGVSeRoDymp+4OTI9CPoQjxlKJbs/p4nsnqGhAnHWO4p1aUq/dI2CLTDNvI
         wL9jmyhOr1oHwB5SEweXM3MXf2Z800NXnN9xYq0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 086/148] objtool: skip non-text sections when adding return-thunk sites
Date:   Sat, 23 Jul 2022 11:54:58 +0200
Message-Id: <20220723095248.478393950@linuxfoundation.org>
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


