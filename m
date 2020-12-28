Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F492E3FA3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502366AbgL1O2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:28:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502358AbgL1O2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64270206D4;
        Mon, 28 Dec 2020 14:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165659;
        bh=aZwdFjxzpDrDs30YAcOvGiCDupbp5UYPJBHDopEQny0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8azPOAhJNWVqmTCDQ4xiaMcptf8CUAiS1BvISxnmpuG3M9YYOeCEYq7t0Jk05oB/
         LIKIcJ5MzrRZDyihz+bRYO7DGNTbEI8CnV+syZrppHohgYLMQsDVVOOFZlCoSAt8lW
         +RyCJ6/Y6TSAU73HrQW/qDz9KbhTLdxYvdXRuVJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 5.10 578/717] dyndbg: fix use before null check
Date:   Mon, 28 Dec 2020 13:49:36 +0100
Message-Id: <20201228125048.602826394@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

commit 3577afb0052fca65e67efdfc8e0859bb7bac87a6 upstream.

In commit a2d375eda771 ("dyndbg: refine export, rename to
dynamic_debug_exec_queries()"), a string is copied before checking it
isn't NULL.  Fix this, report a usage/interface error, and return the
proper error code.

Fixes: a2d375eda771 ("dyndbg: refine export, rename to dynamic_debug_exec_queries()")
Cc: stable@vger.kernel.org
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Link: https://lore.kernel.org/r/20201209183625.2432329-1-jim.cromie@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/dynamic_debug.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -561,9 +561,14 @@ static int ddebug_exec_queries(char *que
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


