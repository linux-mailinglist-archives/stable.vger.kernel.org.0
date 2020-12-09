Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27152D4922
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 19:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732996AbgLIShL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 13:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbgLIShL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 13:37:11 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13FFC0613CF;
        Wed,  9 Dec 2020 10:36:30 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id k2so2746740oic.13;
        Wed, 09 Dec 2020 10:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=InI8kMxZ0SE9l75DuOndEZGfmarmC3cXjv+qNAPdxJc=;
        b=LsJ2BETuCnGZplnCDnz9ZU/yhWlpFhGebvqCV1GITkN7ifDJZbUx21OQBZDu8otKZB
         Z+rOS2JXHh+o5IkyMq4Rc0lcJohqNOsjejAD9dEUKG8GhAYYNOHhwNUPfgz3AXsq0aU9
         CL/YfPZi64bVyKE9IFBwOyqY25PxEaerntKM7SjeuNrv74hq1FkXppsCbWMY3CNpjHwR
         rhBIsXUCAFQAnnd6RNtR1eBwY8PQ2B1cx5W+f/M37LmJRc7iIP8v7FyhjGTctyy9J+FK
         K5dEzwZIjoijlFv9OKZTwHKfBdHItKvhwbVZoldEDyQ/AC6pDxi48+t4og7mu1yjzM6N
         +xQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=InI8kMxZ0SE9l75DuOndEZGfmarmC3cXjv+qNAPdxJc=;
        b=CJ5F5ZbgDs5berxM48iAuhQ3fr2u2KZ3BGXAGT8q4kQcUE4pxhWIyOefgTGwmAGe3W
         EI0ee06h77pPLcx8Mb5nARvF9pRvIAx7rjnRnnpJLtlNEKex4aU7Q3/Fwd20I/Mn0HUh
         P8Y/JC2/vJi9lMjbb0TRHzetOXP740ijpARMmn6WU/vSeZJPghpPtBy0XTVE3TYAtvj3
         2v7xkZSdM37TVajQdG/hw4B7FCCMYriDvVpt2g1FvFmQu2iZMT9Li8dOsoteogtxD6SL
         77zN4Nnyp6q2iKUPPjvnkXqBC9n+SmgWCoLsqMqVTuFgrN4xCqVYzf9KxxCX09BmFarL
         LRbg==
X-Gm-Message-State: AOAM530BHIe4z/88fxJb/dXFHNnBJRlPG/tXFIH1YfW3QG6TiKCKIfl9
        R+Bbvdf+cWPDxSeEMEIFsTQ=
X-Google-Smtp-Source: ABdhPJxac6zOWQSSOhowGRR+mBoaphIpZOvtYniHZef00B2ugFhDq6F63R87YXZdizEmrtE/U13eKw==
X-Received: by 2002:aca:aa83:: with SMTP id t125mr2702550oie.103.1607538990199;
        Wed, 09 Dec 2020 10:36:30 -0800 (PST)
Received: from frodo.comcast.net ([2601:284:8203:5970::fb22])
        by smtp.googlemail.com with ESMTPSA id e8sm540375oti.76.2020.12.09.10.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 10:36:29 -0800 (PST)
From:   Jim Cromie <jim.cromie@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Jim Cromie <jim.cromie@gmail.com>, stable@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] dyndbg: fix use before null check
Date:   Wed,  9 Dec 2020 11:36:25 -0700
Message-Id: <20201209183625.2432329-1-jim.cromie@gmail.com>
X-Mailer: git-send-email 2.29.2
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

