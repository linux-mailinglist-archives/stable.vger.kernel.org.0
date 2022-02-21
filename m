Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDAB4BDD6A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347003AbiBUJDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:03:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347155AbiBUJAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:00:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BDC27B01;
        Mon, 21 Feb 2022 00:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAA3761140;
        Mon, 21 Feb 2022 08:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2158C340E9;
        Mon, 21 Feb 2022 08:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433752;
        bh=8IUsyVO3CUV/NHmrn9iyf0MiQePqG+1lN0ZMxV/tScY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3Gv2yAsZu2oWjP/YzMHqmxsrP3ICvri6F1GzgcTtkU7NoXWDwpFdxavtXVzjOYSJ
         bU6KsTaTbXiNt+yWlViS5O0FRpxtotoMsOp55acgmGyDg7V/Bzff5ud8HYJ5g+HCSZ
         EmMuUzQrcs8y9tiW4He9fwNww9GYw0XEQ6dZJFa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Kees Kook <keescook@chromium.org>,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-hardening@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.19 30/58] libsubcmd: Fix use-after-free for realloc(..., 0)
Date:   Mon, 21 Feb 2022 09:49:23 +0100
Message-Id: <20220221084912.857952812@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084911.895146879@linuxfoundation.org>
References: <20220221084911.895146879@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit 52a9dab6d892763b2a8334a568bd4e2c1a6fde66 upstream.

GCC 12 correctly reports a potential use-after-free condition in the
xrealloc helper. Fix the warning by avoiding an implicit "free(ptr)"
when size == 0:

In file included from help.c:12:
In function 'xrealloc',
    inlined from 'add_cmdname' at help.c:24:2: subcmd-util.h:56:23: error: pointer may be used after 'realloc' [-Werror=use-after-free]
   56 |                 ret = realloc(ptr, size);
      |                       ^~~~~~~~~~~~~~~~~~
subcmd-util.h:52:21: note: call to 'realloc' here
   52 |         void *ret = realloc(ptr, size);
      |                     ^~~~~~~~~~~~~~~~~~
subcmd-util.h:58:31: error: pointer may be used after 'realloc' [-Werror=use-after-free]
   58 |                         ret = realloc(ptr, 1);
      |                               ^~~~~~~~~~~~~~~
subcmd-util.h:52:21: note: call to 'realloc' here
   52 |         void *ret = realloc(ptr, size);
      |                     ^~~~~~~~~~~~~~~~~~

Fixes: 2f4ce5ec1d447beb ("perf tools: Finalize subcmd independence")
Reported-by: Valdis Klētnieks <valdis.kletnieks@vt.edu>
Signed-off-by: Kees Kook <keescook@chromium.org>
Tested-by: Valdis Klētnieks <valdis.kletnieks@vt.edu>
Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: linux-hardening@vger.kernel.org
Cc: Valdis Klētnieks <valdis.kletnieks@vt.edu>
Link: http://lore.kernel.org/lkml/20220213182443.4037039-1-keescook@chromium.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/subcmd/subcmd-util.h |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/tools/lib/subcmd/subcmd-util.h
+++ b/tools/lib/subcmd/subcmd-util.h
@@ -50,15 +50,8 @@ static NORETURN inline void die(const ch
 static inline void *xrealloc(void *ptr, size_t size)
 {
 	void *ret = realloc(ptr, size);
-	if (!ret && !size)
-		ret = realloc(ptr, 1);
-	if (!ret) {
-		ret = realloc(ptr, size);
-		if (!ret && !size)
-			ret = realloc(ptr, 1);
-		if (!ret)
-			die("Out of memory, realloc failed");
-	}
+	if (!ret)
+		die("Out of memory, realloc failed");
 	return ret;
 }
 


