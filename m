Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0E16AEAD7
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbjCGRht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjCGRhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:37:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4AF574FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:33:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88BBDB819B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9454C433EF;
        Tue,  7 Mar 2023 17:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210399;
        bh=RpOFDwS1FLwwrPDDS3IFCZUaXPah1Rlrdyj83QhuShw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdDioAa6r4tGqz2wKeH9f5RwhqBfdmHc3aGekWtvcEhscse6U6DorpIkccdKItA5b
         sEFBKsxaRJdjh5v6mM6X6X/UpZMuFJ5MnUWMYtBz085xykPS/RIqp4osW4WOaobvc3
         Lnsi0mvrlwXM64OQpCpi80oHPoUUWPoe4r1bVIbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0497/1001] alpha/boot/tools/objstrip: fix the check for ELF header
Date:   Tue,  7 Mar 2023 17:54:29 +0100
Message-Id: <20230307170042.949336429@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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



