Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002BC60A2FD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiJXLt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiJXLsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:48:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC033A161;
        Mon, 24 Oct 2022 04:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9383612A0;
        Mon, 24 Oct 2022 11:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B744DC433D6;
        Mon, 24 Oct 2022 11:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611768;
        bh=R2o+Cu2UAOttf3+FN46CvIfUeo5oZyZa9B5Y8e4wXF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNG7aefQfLXn9od6GWQWvgJY2AKw3MBmlmjHpBPr/T1ByszvXnAs5vWgBEkSE9eZw
         yhvQvSBtFR6KVUAdkgeJ25uHJZ7oNs8qGQ6cVs6HbTE1dtFgYRDM8EWLJ2JnC3bsE7
         2xpndMXyNZWAZe/vZ2S0U4MIALHURf6+qEpxBnfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jim Cromie <jim.cromie@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 103/159] dyndbg: let query-modname override actual module name
Date:   Mon, 24 Oct 2022 13:30:57 +0200
Message-Id: <20221024112953.207373954@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

[ Upstream commit e75ef56f74965f426dd819a41336b640ffdd8fbc ]

dyndbg's control-parser: ddebug_parse_query(), requires that search
terms: module, func, file, lineno, are used only once in a query; a
thing cannot be named both foo and bar.

The cited commit added an overriding module modname, taken from the
module loader, which is authoritative.  So it set query.module 1st,
which disallowed its use in the query-string.

But now, its useful to allow a module-load to enable classes across a
whole (or part of) a subsystem at once.

  # enable (dynamic-debug in) drm only
  modprobe drm dyndbg="class DRM_UT_CORE +p"

  # get drm_helper too
  modprobe drm dyndbg="class DRM_UT_CORE module drm* +p"

  # get everything that knows DRM_UT_CORE
  modprobe drm dyndbg="class DRM_UT_CORE module * +p"

  # also for boot-args:
  drm.dyndbg="class DRM_UT_CORE module * +p"

So convert the override into a default, by filling it only when/after
the query-string omitted the module.

NB: the query class FOO handling is forthcoming.

Fixes: 8e59b5cfb9a6 dynamic_debug: add modname arg to exec_query callchain
Acked-by: Jason Baron <jbaron@akamai.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Link: https://lore.kernel.org/r/20220904214134.408619-8-jim.cromie@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dynamic_debug.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 91c451e0f474..01591a7b151f 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -327,10 +327,6 @@ static int ddebug_parse_query(char *words[], int nwords,
 	}
 	memset(query, 0, sizeof(*query));
 
-	if (modname)
-		/* support $modname.dyndbg=<multiple queries> */
-		query->module = modname;
-
 	for (i = 0; i < nwords; i += 2) {
 		if (!strcmp(words[i], "func")) {
 			rc = check_set(&query->function, words[i+1], "func");
@@ -379,6 +375,13 @@ static int ddebug_parse_query(char *words[], int nwords,
 		if (rc)
 			return rc;
 	}
+	if (!query->module && modname)
+		/*
+		 * support $modname.dyndbg=<multiple queries>, when
+		 * not given in the query itself
+		 */
+		query->module = modname;
+
 	vpr_info_dq(query, "parsed");
 	return 0;
 }
-- 
2.35.1



