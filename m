Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F7E2C13CE
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 20:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgKWSnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 13:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbgKWSnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 13:43:42 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C040C0613CF;
        Mon, 23 Nov 2020 10:43:42 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id q206so20726489oif.13;
        Mon, 23 Nov 2020 10:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pETq9vSAMO9m2cX45Apd5Cfd9J4rgPAz5ZZICh2r7R4=;
        b=ptGyx6cJ9GoUZYf6wMKMKNbA+CrIFjDF69cLnpHgE64fHrbWJSgr6LQpOT7Ex69M4a
         gjxqH4lrJ2j+4f7pyE6/PkttZtamV0qwz73rUsHhQLFdR1DNh07cUsKfUjDwD6L24Gvt
         lFAF7Y13s/teQwrYoQ/xnTeU+KH5qPX4ILw2CGkk9Ofw/58eRsdGkfxCDwC+uPMyBp2m
         XmEpqB8SoMtW95yQ9npl9dcJvtOzkli0F/0pcIdzJ6EDVndU5kfn6ddlxqIAHPipyJam
         6AA6lEnG7KFYdN9O3KAtlJVOtvalKX7P41nGNZggdM232JA7BIvdFQDf0nx+HloUdB7+
         yI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pETq9vSAMO9m2cX45Apd5Cfd9J4rgPAz5ZZICh2r7R4=;
        b=R0XMW/aTzSqmwyDcslCMjnYzLFZlPvPJN7qHO407y8vCPVekj5wD8MedTnH5j1lBmd
         lRErLI22OLd6iBEs9CcSf1ByJswbN268nHueMCzxJk5prrrDIFGpOTLNt89OkNyRzIqv
         Z49rxC1gmUFD//U2SZkD4Fucrx+FDq1lCeAbjSCI5Y+veRxMxzV8V8Xp8y4e0751Tqjh
         tw/SRQfUm6FEkdgpXaCvdxxvCKOWG8/gD0GiN1y/WKOTL5/rBZYaow/kP7ulKkMOJ5Jy
         A7E4j41D7VnMe/ZluO+xLhQaYHWtT7X2eBmR6N88I1QmcBnwhkgqVb2vJnfd/Uk2lR2d
         ms9g==
X-Gm-Message-State: AOAM530D2daO+sHf5LJRJHFeGoJMaabY9bctBjhujPmbTLMUa4fQ6gXN
        wwpgNknKPLj3hejb5Ug7apQ=
X-Google-Smtp-Source: ABdhPJzVRMqDMiiZaTuEvTvhlt+L9krQZjPTOTGWK08T6n4v6QHqyc0vmcLCWNH/Gw+arjk68K7dgA==
X-Received: by 2002:aca:3944:: with SMTP id g65mr225965oia.36.1606157021551;
        Mon, 23 Nov 2020 10:43:41 -0800 (PST)
Received: from frodo.mearth (c-24-9-77-57.hsd1.co.comcast.net. [24.9.77.57])
        by smtp.googlemail.com with ESMTPSA id 64sm6355366otu.62.2020.11.23.10.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 10:43:41 -0800 (PST)
From:   Jim Cromie <jim.cromie@gmail.com>
To:     Jason Baron <jbaron@akamai.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] dyndbg: fix use before null check
Date:   Mon, 23 Nov 2020 11:43:34 -0700
Message-Id: <20201123184334.1777186-1-jim.cromie@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a2d375eda771 ("dyndbg: refine export, rename to dynamic_debug_exec_queries()")

Above commit copies a string before checking for null pointer, fix
this, and add a pr_err.  Also trim comment, and add return val info.

Fixes: a2d375eda771
Cc: stable@vger.kernel.org
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index bd7b3aaa93c3..711a9def8c83 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -553,17 +553,23 @@ static int ddebug_exec_queries(char *query, const char *modname)
  * @query: query-string described in admin-guide/dynamic-debug-howto
  * @modname: string containing module name, usually &module.mod_name
  *
- * This uses the >/proc/dynamic_debug/control reader, allowing module
- * authors to modify their dynamic-debug callsites. The modname is
- * canonically struct module.mod_name, but can also be null or a
- * module-wildcard, for example: "drm*".
+ * This uses the >control reader, allowing module authors to modify
+ * their dynamic-debug callsites. The modname is canonically struct
+ * module.mod_name, but can also be null or a module-wildcard, for
+ * example: "drm*".
+ * Returns <0 on error, >=0 for callsites changed
  */
 int dynamic_debug_exec_queries(const char *query, const char *modname)
 {
 	int rc;
-	char *qry = kstrndup(query, PAGE_SIZE, GFP_KERNEL);
+	char *qry; /* writable copy of query */
 
-	if (!query)
+	if (!query) {
+		pr_err("non-null query/command string expected\n");
+		return -EINVAL;
+	}
+	qry = kstrndup(query, PAGE_SIZE, GFP_KERNEL);
+	if (!qry)
 		return -ENOMEM;
 
 	rc = ddebug_exec_queries(qry, modname);
-- 
2.28.0

