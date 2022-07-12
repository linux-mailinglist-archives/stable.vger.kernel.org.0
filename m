Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24AE57246C
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbiGLTBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbiGLS7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:59:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764BE3B7;
        Tue, 12 Jul 2022 11:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58A87B81B96;
        Tue, 12 Jul 2022 18:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D64C3411C;
        Tue, 12 Jul 2022 18:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651709;
        bh=liVXXChksvrzl85Y56eAicmJuykdBacUVAvbgXO7fec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqg8DpsUmLJQIHjZ+1C+YE6x1CPgHDyN4xMC72q9MSPTwHBgZBtbpPbZoMa2pgclm
         JdFhDEIZuM/JuGRzNt0U2S/j9uauXM3w9KHqp2Dk3yxtGtogq+lTL7e0IeHuo1q+Y1
         YtuXpOI6lblCaHAW+3xmooMbqmBGYfocI4qTFXwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 5.15 31/78] objtool: skip non-text sections when adding return-thunk sites
Date:   Tue, 12 Jul 2022 20:39:01 +0200
Message-Id: <20220712183240.046055223@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
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
@@ -1153,7 +1153,9 @@ static void add_return_call(struct objto
 	insn->type = INSN_RETURN;
 	insn->retpoline_safe = true;
 
-	list_add_tail(&insn->call_node, &file->return_thunk_list);
+	/* Skip the non-text sections, specially .discard ones */
+	if (insn->sec->text)
+		list_add_tail(&insn->call_node, &file->return_thunk_list);
 }
 
 /*


