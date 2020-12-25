Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9E02E2C39
	for <lists+stable@lfdr.de>; Fri, 25 Dec 2020 21:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgLYUUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Dec 2020 15:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgLYUUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Dec 2020 15:20:52 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FB6C0613C1;
        Fri, 25 Dec 2020 12:20:11 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id k8so4611337ilr.4;
        Fri, 25 Dec 2020 12:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=InI8kMxZ0SE9l75DuOndEZGfmarmC3cXjv+qNAPdxJc=;
        b=r6NQf9sanR+K4FmtKtZxi0+2djREFNuDx7xAFlKcuIGdrzDT01FfkTiv8KttlxgpP8
         Jf0wONnTXXrXHgdkSJ8Cs3BqfcpriC/TLqWtDzxhOeZ2EvW2ZliGq3UPWw824DNy4B3a
         tyPy5/Kecfx7sC1EtM+J8d0Bze7PsSUUYV4REqjCpJmZQPNmKoHsNhHHqvzUr715ejEe
         Lq0c7BikZ20WX7pZcWCW7fYYtRjAQ00RTq9J+xc/UiLRAkH+VOBAuWhGf8hdsjnmhO+H
         hLo5sINXfqQST/qfavuOmDeYnux9FDGKjr9QX4z/V8b2fbHrkgJZTbNELwtiOO+N5xFF
         fzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=InI8kMxZ0SE9l75DuOndEZGfmarmC3cXjv+qNAPdxJc=;
        b=oOrjXmFXhUJvZdi5mb2VrAGAdeYIZ67/tdI2AgGykQ68DcLRfObA0ylgv3v2bQdiUo
         8915fqEOmqpAuv+RWOUHeO510+q+ioE8co+QOls6ESS1mUU/6Os3kvwf1glAQFS0GRQ4
         cU62YeaJlIpwHiFzwt7Gs0COK11b/ty4YTLnvYFHbxN5Asw33Z6pPRlzGFkI/djYxv7F
         cAwVFzAFa5ClM+ztak0yDO21yMVje4MSyMAjXRFQBtvS4BrV1deX30rQZ9da1RSf5+wl
         v28y/Yj8jFUzg07trr48kKRmK6lhhF5MdEow4EYBATKqepaeyxmNNt5IVXVezykRfg02
         Nf4Q==
X-Gm-Message-State: AOAM530Gz6gGbpRzNa6dvDFXQwFvb6f2qFQmCEYYzzkA7+mOPjOPCLtb
        aiNzGdAeQ4XAC+wHn8KbZA0=
X-Google-Smtp-Source: ABdhPJzcroUJQmkQGcY7BxNYigl/rjO7YLJpONAnadfT8KS5+HQr9+NSD1zpJH+0E7zdC0dE6lc0Eg==
X-Received: by 2002:a92:c847:: with SMTP id b7mr35308541ilq.210.1608927611296;
        Fri, 25 Dec 2020 12:20:11 -0800 (PST)
Received: from frodo.mearth (c-24-9-77-57.hsd1.co.comcast.net. [24.9.77.57])
        by smtp.googlemail.com with ESMTPSA id e1sm28380401iod.17.2020.12.25.12.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Dec 2020 12:20:10 -0800 (PST)
From:   Jim Cromie <jim.cromie@gmail.com>
To:     jbaron@akamai.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc:     Jim Cromie <jim.cromie@gmail.com>, stable@vger.kernel.org
Subject: [RFC PATCH v2 01/19] dyndbg: fix use before null check
Date:   Fri, 25 Dec 2020 13:19:26 -0700
Message-Id: <20201225201944.3701590-2-jim.cromie@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201225201944.3701590-1-jim.cromie@gmail.com>
References: <20201225201944.3701590-1-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit a2d375eda771 ("dyndbg: refine export, rename to
dynamic_debug_exec_queries()"), a string is copied before checking it
isn't NULL.  Fix this, report a usage/interface error, and return the
proper error code.

Fixes: a2d375eda771 ("dyndbg: refine export, rename to dynamic_debug_exec_queries()")
Cc: stable@vger.kernel.org
--
-v2 drop comment tweak, improve commit message

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index bd7b3aaa93c3..c70d6347afa2 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -561,9 +561,14 @@ static int ddebug_exec_queries(char *query, const char *modname)
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
2.29.2

