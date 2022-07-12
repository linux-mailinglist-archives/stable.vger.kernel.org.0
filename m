Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861A15722D9
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiGLSkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiGLSkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:40:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F23C1779;
        Tue, 12 Jul 2022 11:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EBB361ACE;
        Tue, 12 Jul 2022 18:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C17C3411C;
        Tue, 12 Jul 2022 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651232;
        bh=7XZ89n0r+YQreOjHqIUzWGHyoEFUcZJ1T7G3vKlv2/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkhkjcGyXQ0bUA+Y2MQqoap0+Gbd0I2Uw3D9zCBeA5ikgI99DAW8Zo8w3BJPfR5e7
         FaJ0qTNvanwrHVC34hhvwUgYZCPDIaUP4pvl40uT2JAppWZ0hHd2PU7ZmxqLX8RgTB
         wqlm85rwrKFRiHoy2FBj+x+djYPSuAGsIEQB2Q/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 006/130] objtool: Support retpoline jump detection for vmlinux.o
Date:   Tue, 12 Jul 2022 20:37:32 +0200
Message-Id: <20220712183246.677303877@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 31a7424bc58063a8e0466c3c10f31a52ec2be4f6 upstream.

Objtool converts direct retpoline jumps to type INSN_JUMP_DYNAMIC, since
that's what they are semantically.

That conversion doesn't work in vmlinux.o validation because the
indirect thunk function is present in the object, so the intra-object
jump check succeeds before the retpoline jump check gets a chance.

Rearrange the checks: check for a retpoline jump before checking for an
intra-object jump.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/4302893513770dde68ddc22a9d6a2a04aca491dd.1611263461.git.jpoimboe@redhat.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/objtool/check.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -795,10 +795,6 @@ static int add_jump_destinations(struct
 		} else if (reloc->sym->type == STT_SECTION) {
 			dest_sec = reloc->sym->sec;
 			dest_off = arch_dest_reloc_offset(reloc->addend);
-		} else if (reloc->sym->sec->idx) {
-			dest_sec = reloc->sym->sec;
-			dest_off = reloc->sym->sym.st_value +
-				   arch_dest_reloc_offset(reloc->addend);
 		} else if (!strncmp(reloc->sym->name, "__x86_indirect_thunk_", 21) ||
 			   !strncmp(reloc->sym->name, "__x86_retpoline_", 16)) {
 			/*
@@ -812,6 +808,10 @@ static int add_jump_destinations(struct
 
 			insn->retpoline_safe = true;
 			continue;
+		} else if (reloc->sym->sec->idx) {
+			dest_sec = reloc->sym->sec;
+			dest_off = reloc->sym->sym.st_value +
+				   arch_dest_reloc_offset(reloc->addend);
 		} else {
 			/* external sibling call */
 			insn->call_dest = reloc->sym;


