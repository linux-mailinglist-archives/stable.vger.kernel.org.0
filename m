Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1982F240EED
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgHJTOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729972AbgHJTOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:14:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F11B22B49;
        Mon, 10 Aug 2020 19:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086853;
        bh=aLwNQpIz+zkPVPgfGML/oL14Z+6IMWC7eDFdKkDNAdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMSoKJqRaDJQI0fUGqB50YpeYdsCPlfHtIz0Ju9I77ryeEyEZXlF559StBrDSo7D7
         wZwiC9/nrXdm7M0x//f7rSyR/jjWELS+iAgtkkyB4ozte4y6rDbNpr8O6C9MpGQGcs
         7eEqNqXLdpyC7Cdz6qkA0X4oCIikOUT6V0/8BbCM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jim Cromie <jim.cromie@gmail.com>, jbaron@akamai.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 20/22] dyndbg: prefer declarative init in caller, to memset in callee
Date:   Mon, 10 Aug 2020 15:13:42 -0400
Message-Id: <20200810191345.3795166-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191345.3795166-1-sashal@kernel.org>
References: <20200810191345.3795166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

[ Upstream commit 9c9d0acbe2793315fa6945a19685ad2a51fb281b ]

ddebug_exec_query declares an auto var, and passes it to
ddebug_parse_query, which memsets it before using it.  Drop that
memset, instead initialize the variable in the caller; let the
compiler decide how to do it.

Acked-by: <jbaron@akamai.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Link: https://lore.kernel.org/r/20200719231058.1586423-10-jim.cromie@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/dynamic_debug.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 91c451e0f4741..a95557f9e8d55 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -325,7 +325,6 @@ static int ddebug_parse_query(char *words[], int nwords,
 		pr_err("expecting pairs of match-spec <value>\n");
 		return -EINVAL;
 	}
-	memset(query, 0, sizeof(*query));
 
 	if (modname)
 		/* support $modname.dyndbg=<multiple queries> */
@@ -443,7 +442,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 static int ddebug_exec_query(char *query_string, const char *modname)
 {
 	unsigned int flags = 0, mask = 0;
-	struct ddebug_query query;
+	struct ddebug_query query = {};
 #define MAXWORDS 9
 	int nwords, nfound;
 	char *words[MAXWORDS];
-- 
2.25.1

