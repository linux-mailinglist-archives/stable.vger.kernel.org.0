Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D3B4ABD99
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388800AbiBGLpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385372AbiBGLbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA95C03FEE4;
        Mon,  7 Feb 2022 03:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27B58B80EBD;
        Mon,  7 Feb 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A0BC004E1;
        Mon,  7 Feb 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233411;
        bh=rG2zIR8em5dhqg9au0dA4l5hkYO7yd8NVH3Wp/6VZIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFppwJmxWItrmpyQ0yZNqiEJLC7nN/SNr0E+HEuzg0rDSouPXvFuPCXMG6ssvAPg/
         RL9+IBt1Yf4TZVwFoBncU471mxP45CbFO8Wzf2PqJcX/CbJK1kCXbaBC8Gbm42P+uW
         kF1sVjG+VCKSEuc6Q3xkzXmxdVouFixlq5q11Zbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 089/110] tools/resolve_btfids: Do not print any commands when building silently
Date:   Mon,  7 Feb 2022 12:07:02 +0100
Message-Id: <20220207103805.420581720@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 7f3bdbc3f13146eb9d07de81ea71f551587a384b upstream.

When building with 'make -s', there is some output from resolve_btfids:

$ make -sj"$(nproc)" oldconfig prepare
  MKDIR     .../tools/bpf/resolve_btfids/libbpf/
  MKDIR     .../tools/bpf/resolve_btfids//libsubcmd
  LINK     resolve_btfids

Silent mode means that no information should be emitted about what is
currently being done. Use the $(silent) variable from Makefile.include
to avoid defining the msg macro so that there is no information printed.

Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220201212503.731732-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/resolve_btfids/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -9,7 +9,11 @@ ifeq ($(V),1)
   msg =
 else
   Q = @
-  msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
+  ifeq ($(silent),1)
+    msg =
+  else
+    msg = @printf '  %-8s %s%s\n' "$(1)" "$(notdir $(2))" "$(if $(3), $(3))";
+  endif
   MAKEFLAGS=--no-print-directory
 endif
 


