Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6EE63B021
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiK1RsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiK1RrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:47:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73AB2D754;
        Mon, 28 Nov 2022 09:41:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78FD0B80D1A;
        Mon, 28 Nov 2022 17:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35D4C433C1;
        Mon, 28 Nov 2022 17:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657307;
        bh=2nnZXA8RaZrSVvCN6ByjHxeIL4WuKWU/gteG+urh8OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtJOrQphtQe+rCBXzJ9fBWElwGLJy0EFEKzyfO8msa2UBLiNSirD095+J/eul6qnh
         nOiNbSMtd8lhTjAgABQ1MIPGJH6aiEN8EF3aBdGPQSqMRyDJFwcZYSDFbo4bgCmwvl
         X9+J2gLaH2spgApl06dUGUHn1xSULGBJdGBozQi0FFl6mdMh8S7z52kpN0DX6sOYqw
         lCWTKrlpIdeBHQj4qLXmh8om5ZBPAK8jVnnVDbsRRytk2R3Rv9HVtukMh3ZgLV7wD3
         xjuKlgDp7SlO3dtmpo/BNEnassv85Ijh3SHk16olEhrGem0oyFrTxr3410uIzGOJMh
         kqPx6+I4ZLu0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, nathan@kernel.org,
        ndesaulniers@google.com, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 12/19] ALSA: seq: Fix function prototype mismatch in snd_seq_expand_var_event
Date:   Mon, 28 Nov 2022 12:41:12 -0500
Message-Id: <20221128174120.1442235-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174120.1442235-1-sashal@kernel.org>
References: <20221128174120.1442235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 05530ef7cf7c7d700f6753f058999b1b5099a026 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed.

seq_copy_in_user() and seq_copy_in_kernel() did not have prototypes
matching snd_seq_dump_func_t. Adjust this and remove the casts. There
are not resulting binary output differences.

This was found as a result of Clang's new -Wcast-function-type-strict
flag, which is more sensitive than the simpler -Wcast-function-type,
which only checks for type width mismatches.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202211041527.HD8TLSE1-lkp@intel.com
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: alsa-devel@alsa-project.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221118232346.never.380-kees@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index 65db1a7c77b7..bb76a2dd0a2f 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -112,15 +112,19 @@ EXPORT_SYMBOL(snd_seq_dump_var_event);
  * expand the variable length event to linear buffer space.
  */
 
-static int seq_copy_in_kernel(char **bufptr, const void *src, int size)
+static int seq_copy_in_kernel(void *ptr, void *src, int size)
 {
+	char **bufptr = ptr;
+
 	memcpy(*bufptr, src, size);
 	*bufptr += size;
 	return 0;
 }
 
-static int seq_copy_in_user(char __user **bufptr, const void *src, int size)
+static int seq_copy_in_user(void *ptr, void *src, int size)
 {
+	char __user **bufptr = ptr;
+
 	if (copy_to_user(*bufptr, src, size))
 		return -EFAULT;
 	*bufptr += size;
@@ -149,8 +153,7 @@ int snd_seq_expand_var_event(const struct snd_seq_event *event, int count, char
 		return newlen;
 	}
 	err = snd_seq_dump_var_event(event,
-				     in_kernel ? (snd_seq_dump_func_t)seq_copy_in_kernel :
-				     (snd_seq_dump_func_t)seq_copy_in_user,
+				     in_kernel ? seq_copy_in_kernel : seq_copy_in_user,
 				     &buf);
 	return err < 0 ? err : newlen;
 }
-- 
2.35.1

