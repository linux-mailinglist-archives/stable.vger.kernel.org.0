Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661985722F4
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiGLSle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiGLSlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:41:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44ADD6CCF;
        Tue, 12 Jul 2022 11:40:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 201F961AD1;
        Tue, 12 Jul 2022 18:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7C7C341D3;
        Tue, 12 Jul 2022 18:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651251;
        bh=aXeY+HDy7y5ZCMPBdTis/j+MlUbP49bXjsG5jcTgf60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EoYwEs7yUZNBztLTokrlQT3MOHwA9K5HsJO7G9eKqmUIwX6aRu9Ht5z4IDBilVWi2
         uMTi6EnIgyAVc0Jr0KeJemfxYzw5ZoIXaCjm1Z4fh6iihhrK5flCvkLT9bNs8L078n
         s7lZaNZtgCF1l+r6+PNisirKu6+N3nl7rBWdG/0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 020/130] x86: Add insn_decode_kernel()
Date:   Tue, 12 Jul 2022 20:37:46 +0200
Message-Id: <20220712183247.336409002@linuxfoundation.org>
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

From: Ben Hutchings <ben@decadent.org.uk>

This was done by commit 52fa82c21f64e900a72437269a5cc9e0034b424e
upstream, but this backport avoids changing all callers of the
old decoder API.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/insn.h       |    2 ++
 arch/x86/kernel/alternative.c     |    2 +-
 tools/arch/x86/include/asm/insn.h |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -105,6 +105,8 @@ enum insn_mode {
 
 extern int insn_decode(struct insn *insn, const void *kaddr, int buf_len, enum insn_mode m);
 
+#define insn_decode_kernel(_insn, _ptr) insn_decode((_insn), (_ptr), MAX_INSN_SIZE, INSN_MODE_KERN)
+
 /* Attribute will be determined after getting ModRM (for opcode groups) */
 static inline void insn_get_attribute(struct insn *insn)
 {
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1290,7 +1290,7 @@ static void text_poke_loc_init(struct te
 	if (!emulate)
 		emulate = opcode;
 
-	ret = insn_decode(&insn, emulate, MAX_INSN_SIZE, INSN_MODE_KERN);
+	ret = insn_decode_kernel(&insn, emulate);
 
 	BUG_ON(ret < 0);
 	BUG_ON(len != insn.length);
--- a/tools/arch/x86/include/asm/insn.h
+++ b/tools/arch/x86/include/asm/insn.h
@@ -105,6 +105,8 @@ enum insn_mode {
 
 extern int insn_decode(struct insn *insn, const void *kaddr, int buf_len, enum insn_mode m);
 
+#define insn_decode_kernel(_insn, _ptr) insn_decode((_insn), (_ptr), MAX_INSN_SIZE, INSN_MODE_KERN)
+
 /* Attribute will be determined after getting ModRM (for opcode groups) */
 static inline void insn_get_attribute(struct insn *insn)
 {


