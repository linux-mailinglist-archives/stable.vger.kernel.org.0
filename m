Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5746D3F2D86
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 15:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240820AbhHTN5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 09:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231854AbhHTN5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 09:57:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A4716113B;
        Fri, 20 Aug 2021 13:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629467832;
        bh=K8+S905uGyASJbRSp6ojxzz8FSVJlwShMqh++FTbeUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzn3O26so+FuhVw9kHhMyXbJ5ZEiAo0PLzc8znPDyofGJr9WSUruQkDieoWUYaU0g
         5bKhOWsLm0DBeAbyngiuAJbN9y0xKY0sjzJtvpNBYLnAPfwY9cVgEEYvY3gIcxx1aG
         uglOfDqvS4n6ts6K6paZ1uIVdX0VHYlnRMdjUKDqmkiY4gBiZG7/Xb40VIUcxWLOp9
         cXBVs8kjfJgj75iIMaPHLo2zZhELKAv0XgIsvt23fO5qwLfZZmicS1SCpwaDMMvaFe
         zxr49yGgO9JZR7elr/JBfGxd+YVB7AjEWSD30wNOM3My7Dprk6gS2/Cx5Rf52Z6Gpj
         ouUDTAjvDHXgQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ebiederm@xmission.com, david@redhat.com, willy@infradead.org,
        linux-nfs@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-doc@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org,
        akpm@linux-foundation.org, luto@kernel.org, bfields@fieldses.org,
        w@1wt.eu, rostedt@goodmis.org, stable@vger.kernel.org
Subject: [PATCH v2 1/2] fs: warn about impending deprecation of mandatory locks
Date:   Fri, 20 Aug 2021 09:57:06 -0400
Message-Id: <20210820135707.171001-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820135707.171001-1-jlayton@kernel.org>
References: <20210820135707.171001-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
have disabled it. Warn the stragglers that still use "-o mand" that
we'll be dropping support for that mount option.

Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/namespace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index ab4174a3c802..ffab0bb1e649 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1716,8 +1716,16 @@ static inline bool may_mount(void)
 }
 
 #ifdef	CONFIG_MANDATORY_FILE_LOCKING
+static bool warned_mand;
 static inline bool may_mandlock(void)
 {
+	if (!warned_mand) {
+		warned_mand = true;
+		pr_warn("======================================================\n");
+		pr_warn("WARNING: the mand mount option is being deprecated and\n");
+		pr_warn("         will be removed in v5.15!\n");
+		pr_warn("======================================================\n");
+	}
 	return capable(CAP_SYS_ADMIN);
 }
 #else
-- 
2.31.1

