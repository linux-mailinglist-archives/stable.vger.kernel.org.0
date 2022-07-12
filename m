Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E06F5722ED
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiGLSle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiGLSlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:41:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B92C08C1;
        Tue, 12 Jul 2022 11:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA39BB81BB4;
        Tue, 12 Jul 2022 18:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0785C3411C;
        Tue, 12 Jul 2022 18:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651248;
        bh=5boINS1JazQ7nJt1mdx/fzP/a/m8Nko02sPbWZvm4I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCTFI5K2qKsSWbTPXr8IPJJSMsv03ax78J91vrLQa3yrtNfu24ucRFjq+qG8LV4SF
         EeFCJz6ydWcGpLi9lHr1rB3vi7i1M7WaH4BlXWNS0d/ONArgzes94I1ouhmTAo+L9i
         gAbuOlyUYPHAbvCXD7eMn6f+4n56ZYDrej+CAnNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 019/130] x86/alternative: Use insn_decode()
Date:   Tue, 12 Jul 2022 20:37:45 +0200
Message-Id: <20220712183247.281867457@linuxfoundation.org>
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


