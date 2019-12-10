Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8F6119AFB
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbfLJWEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:04:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbfLJWEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E84E920828;
        Tue, 10 Dec 2019 22:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015485;
        bh=SQNqfs3xX6Ay9KHY/sTpJriYHrOPjc5jnhEYVXUUXV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v85NphY5CbSmB5/k9sW6Ce3fQ1NoT32+kXQ1Z4fXk/2H13ltJLuTEsiukJTpYEpgL
         V0Yr9Hlq056eqw/STBkg1zsOaX3BAgFdM7s2sszsxwL7EdOAGI5AdKwWq9VtXXRRHp
         Wrguy547AeK4Wj0qIt/o+tgcoE3Bji9YmM+irNpI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Clark <James.Clark@arm.com>,
        James Clark <james.clark@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, nd <nd@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 088/130] libsubcmd: Use -O0 with DEBUG=1
Date:   Tue, 10 Dec 2019 17:02:19 -0500
Message-Id: <20191210220301.13262-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clark <James.Clark@arm.com>

[ Upstream commit 22bd8f1b5a1dd168ba4eba27cb17643a11012f5d ]

When a 'make DEBUG=1' build is done, the command parser is still built
with -O6 and is hard to step through, fix it making it use -O0 in that
case.

Signed-off-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: nd <nd@arm.com>
Link: http://lore.kernel.org/lkml/20191028113340.4282-1-james.clark@arm.com
[ split from a larger patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/subcmd/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/subcmd/Makefile b/tools/lib/subcmd/Makefile
index 5b2cd5e58df09..5dbb0dde208c4 100644
--- a/tools/lib/subcmd/Makefile
+++ b/tools/lib/subcmd/Makefile
@@ -28,7 +28,9 @@ ifeq ($(DEBUG),0)
   endif
 endif
 
-ifeq ($(CC_NO_CLANG), 0)
+ifeq ($(DEBUG),1)
+  CFLAGS += -O0
+else ifeq ($(CC_NO_CLANG), 0)
   CFLAGS += -O3
 else
   CFLAGS += -O6
-- 
2.20.1

