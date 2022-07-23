Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FE957ED89
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 11:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237641AbiGWJ65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 05:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237640AbiGWJ60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 05:58:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B97D66AE5;
        Sat, 23 Jul 2022 02:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 837EF611BD;
        Sat, 23 Jul 2022 09:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B84AC341C0;
        Sat, 23 Jul 2022 09:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570246;
        bh=5boINS1JazQ7nJt1mdx/fzP/a/m8Nko02sPbWZvm4I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSJsm8rR5INQVlioTM8WdjZyPV8m3gX7RD2fuWAPwQwGnrdaDdY8T235tB7wLyDct
         yfeT5A0EPDfK6eD9Zan+j/qySdkPpwppadw4EAhMNn8Nvd+iMsat3JvLskDIZYndWl
         lrXocwh+nT6NeWfv9a26YRPsfrw9a1Q/OjT5B6r4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 019/148] x86/alternative: Use insn_decode()
Date:   Sat, 23 Jul 2022 11:53:51 +0200
Message-Id: <20220723095229.850848060@linuxfoundation.org>
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

From: Borislav Petkov <bp@suse.de>

commit 63c66cde7bbcc79aac14b25861c5b2495eede57b upstream.

No functional changes, just simplification.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210304174237.31945-10-bp@alien8.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1284,15 +1284,15 @@ static void text_poke_loc_init(struct te
 			       const void *opcode, size_t len, const void *emulate)
 {
 	struct insn insn;
+	int ret;
 
 	memcpy((void *)tp->text, opcode, len);
 	if (!emulate)
 		emulate = opcode;
 
-	kernel_insn_init(&insn, emulate, MAX_INSN_SIZE);
-	insn_get_length(&insn);
+	ret = insn_decode(&insn, emulate, MAX_INSN_SIZE, INSN_MODE_KERN);
 
-	BUG_ON(!insn_complete(&insn));
+	BUG_ON(ret < 0);
 	BUG_ON(len != insn.length);
 
 	tp->rel_addr = addr - (void *)_stext;


