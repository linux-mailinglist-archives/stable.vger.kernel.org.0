Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBD256B489A
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbjCJPEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbjCJPEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:04:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4A15A93E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:57:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 446D161A21
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39278C433D2;
        Fri, 10 Mar 2023 14:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460213;
        bh=RpOFDwS1FLwwrPDDS3IFCZUaXPah1Rlrdyj83QhuShw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBYK8CfV3iAgqe/dJKA4iTyWSictC6Xl9HfI/YfUVSOBZIVpI/z1+Rzape+Gta3w0
         qhPSsS/MMJiFWFiS/w+oi7B/oVzfUE0g/AfiUTjwC6tcSg42e07JwczFFcwjkgROPB
         tTm8ePmjTkd/id36aerI7piWoXg68iKWa3fHxgzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/529] alpha/boot/tools/objstrip: fix the check for ELF header
Date:   Fri, 10 Mar 2023 14:36:44 +0100
Message-Id: <20230310133817.053496022@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 1878787797cbb019eeefe6f905514dcd557302b6 ]

Just memcmp() with ELFMAG - that's the normal way to do it in userland
code, which that thing is.  Besides, that has the benefit of actually
building - str_has_prefix() is *NOT* present in <string.h>.

Fixes: 5f14596e55de "alpha: Replace strncmp with str_has_prefix"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/boot/tools/objstrip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/boot/tools/objstrip.c b/arch/alpha/boot/tools/objstrip.c
index 08b430d25a315..7cf92d172dce9 100644
--- a/arch/alpha/boot/tools/objstrip.c
+++ b/arch/alpha/boot/tools/objstrip.c
@@ -148,7 +148,7 @@ main (int argc, char *argv[])
 #ifdef __ELF__
     elf = (struct elfhdr *) buf;
 
-    if (elf->e_ident[0] == 0x7f && str_has_prefix((char *)elf->e_ident + 1, "ELF")) {
+    if (memcmp(&elf->e_ident[EI_MAG0], ELFMAG, SELFMAG) == 0) {
 	if (elf->e_type != ET_EXEC) {
 	    fprintf(stderr, "%s: %s is not an ELF executable\n",
 		    prog_name, inname);
-- 
2.39.2



