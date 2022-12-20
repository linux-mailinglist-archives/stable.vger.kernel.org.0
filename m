Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354A56517CA
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiLTBWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232938AbiLTBV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:21:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21D5FAC0;
        Mon, 19 Dec 2022 17:21:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59D63CE1142;
        Tue, 20 Dec 2022 01:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DC1C433EF;
        Tue, 20 Dec 2022 01:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499269;
        bh=GfROr8HR6qZP6TAhiHR0HybOQfzTNxipuRy8eXjgMtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/mMHEUdg1xJYqkHvbnaZeAWCJhGbsOlGgf8Trg0CkNLyilB4ANHWJQQdBqrpPrmW
         GMU+tCoe4+LChVCJGEP11suX8SbkoCFssyyor0YFa8e5SZEagtsz1M+hxE0WWX3NQP
         Ik2Q4ogPViLBVUTl8AUZjxgLivERmu3qQ45XFRDD/ixqdMZfoCHkIRzmg5JdfxWKUV
         Bp6GPqbSkUiDTtYP9OdpgfOSzWxTF1TUPHj90++OCI61xUdgquELxRuGcj29w8Vb6O
         tjNyn4BjZK57OlRT/5dxLxDJSZvXRzShfCZb0m2yD4GNDv6ixpd2MBni8/+u9ofhFa
         +YQBc2Bc66MUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        ram.vegesna@broadcom.com, jejb@linux.ibm.com,
        ndesaulniers@google.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 06/16] scsi: elx: libefc: Fix second parameter type in state callbacks
Date:   Mon, 19 Dec 2022 20:20:43 -0500
Message-Id: <20221220012053.1222101-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012053.1222101-1-sashal@kernel.org>
References: <20221220012053.1222101-1-sashal@kernel.org>
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 3d75e766b58a7410d4e835c534e1b4664a8f62d0 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function pointer
prototype to make sure the call target is valid to help mitigate ROP
attacks. If they are not identical, there is a failure at run time, which
manifests as either a kernel panic or thread getting killed. A proposed
warning in clang aims to catch these at compile time, which reveals:

  drivers/scsi/elx/libefc/efc_node.c:811:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
                  ctx->current_state = state;
                                    ^ ~~~~~
  drivers/scsi/elx/libefc/efc_node.c:878:21: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          node->nodedb_state = state;
                            ^ ~~~~~
  drivers/scsi/elx/libefc/efc_node.c:905:6: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' from 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') [-Werror,-Wincompatible-function-pointer-types-strict]
                  pf = node->nodedb_state;
                    ^ ~~~~~~~~~~~~~~~~~~

  drivers/scsi/elx/libefc/efc_device.c:455:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
                  node->nodedb_state = __efc_d_init;
                                    ^ ~~~~~~~~~~~~

  drivers/scsi/elx/libefc/efc_sm.c:41:22: error: incompatible function pointer types assigning to 'void (*)(struct efc_sm_ctx *, u32, void *)' (aka 'void (*)(struct efc_sm_ctx *, unsigned int, void *)') from 'void (*)(struct efc_sm_ctx *, enum efc_sm_event, void *)' [-Werror,-Wincompatible-function-pointer-types-strict]
                  ctx->current_state = state;
                                    ^ ~~~~~

The type of the second parameter in the prototypes of ->current_state() and
->nodedb_state() ('u32') does not match the implementations, which have a
second parameter type of 'enum efc_sm_event'. Update the prototypes to have
the correct second parameter type, clearing up all the warnings and CFI
failures.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20221102161906.2781508-1-nathan@kernel.org
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/libefc/efclib.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/libefc/efclib.h b/drivers/scsi/elx/libefc/efclib.h
index dde20891c2dd..57e338612812 100644
--- a/drivers/scsi/elx/libefc/efclib.h
+++ b/drivers/scsi/elx/libefc/efclib.h
@@ -58,10 +58,12 @@ enum efc_node_send_ls_acc {
 #define EFC_LINK_STATUS_UP		0
 #define EFC_LINK_STATUS_DOWN		1
 
+enum efc_sm_event;
+
 /* State machine context header  */
 struct efc_sm_ctx {
 	void (*current_state)(struct efc_sm_ctx *ctx,
-			      u32 evt, void *arg);
+			      enum efc_sm_event evt, void *arg);
 
 	const char	*description;
 	void		*app;
@@ -365,7 +367,7 @@ struct efc_node {
 	int			prev_evt;
 
 	void (*nodedb_state)(struct efc_sm_ctx *ctx,
-			     u32 evt, void *arg);
+			     enum efc_sm_event evt, void *arg);
 	struct timer_list	gidpt_delay_timer;
 	u64			time_last_gidpt_msec;
 
-- 
2.35.1

