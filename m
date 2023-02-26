Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053F06A3099
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 15:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjBZOvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 09:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjBZOu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 09:50:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6F1166C8;
        Sun, 26 Feb 2023 06:48:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE9AF60C4B;
        Sun, 26 Feb 2023 14:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAC3C4339E;
        Sun, 26 Feb 2023 14:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422777;
        bh=ta7h0pgijq+6wuebfJI+BybH3vX6uklbBdb+V9Ehz44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYYociSerCfXWiLVNaHtfYy0F7fy7oKewZW78TtyoEcocU2Gx32zYGnApbhMQr8y/
         GvIYV3D8AjeQrm8+LDLJP24dBnS6ejuQxTCh6hpJAIH9bdhvG1gjVZY0x/cwWa+yjA
         w94/ytxJgoWZD2p9K2IgcGMBECwm441yJLPIjnVcpsCEEGSwNwJSrmAXsisSq6ro/g
         zCMEzbGt8ETzgOhN/ZV/Kbc4+rjQI0JiZWx856MkVivvO+wwnws8F7vWmChZ7P5hLU
         S8VtaY4VXXHdTRIP2qm4CD47/5J2XeQNazMoz3DlRloc7ObvC+/kakij5kFnL+FdNV
         RhzTffERYeLCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@coda.cs.cmu.edu, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.2 39/53] coda: Avoid partial allocation of sig_inputArgs
Date:   Sun, 26 Feb 2023 09:44:31 -0500
Message-Id: <20230226144446.824580-39-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
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

[ Upstream commit 48df133578c70185a95a49390d42df1996ddba2a ]

GCC does not like having a partially allocated object, since it cannot
reason about it for bounds checking when it is passed to other code.
Instead, fully allocate sig_inputArgs. (Alternatively, sig_inputArgs
should be defined as a struct coda_in_hdr, if it is actually not using
any other part of the union.) Seen under GCC 13:

../fs/coda/upcall.c: In function 'coda_upcall':
../fs/coda/upcall.c:801:22: warning: array subscript 'union inputArgs[0]' is partly outside array bounds of 'unsigned char[20]' [-Warray-bounds=]
  801 |         sig_inputArgs->ih.opcode = CODA_SIGNAL;
      |                      ^~

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: coda@cs.cmu.edu
Cc: codalist@coda.cs.cmu.edu
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230127223921.never.882-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coda/upcall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 59f6cfd06f96a..cd6a3721f6f69 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -791,7 +791,7 @@ static int coda_upcall(struct venus_comm *vcp,
 	sig_req = kmalloc(sizeof(struct upc_req), GFP_KERNEL);
 	if (!sig_req) goto exit;
 
-	sig_inputArgs = kvzalloc(sizeof(struct coda_in_hdr), GFP_KERNEL);
+	sig_inputArgs = kvzalloc(sizeof(*sig_inputArgs), GFP_KERNEL);
 	if (!sig_inputArgs) {
 		kfree(sig_req);
 		goto exit;
-- 
2.39.0

