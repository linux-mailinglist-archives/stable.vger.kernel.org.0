Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A4711B077
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732663AbfLKPXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:53898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732184AbfLKPXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9AD0208C3;
        Wed, 11 Dec 2019 15:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077784;
        bh=3aXXUP6CSHv5npCS0f3X5zHZNaBwI9CZNedUZywSiRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BmgFo2DH4Kt4jERr7/Cfv7Ynh/cFGM0g95M/+MceK3NWdebHW2koh8EeReCkYoVpR
         Dj1LMdJFvJg8z965uynS46zf9GoQbrVn7YRqsMcTL/isPDjGj1wbIEwwMkpQmMjRYq
         WzLbpKc4AERf/jEr7sVtNQDyVM/a5BCp2fXqz338=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 169/243] pstore/ram: Avoid NULL deref in ftrace merging failure path
Date:   Wed, 11 Dec 2019 16:05:31 +0100
Message-Id: <20191211150350.589883633@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 8665569e97dd52920713b95675409648986b5b0d ]

Given corruption in the ftrace records, it might be possible to allocate
tmp_prz without assigning prz to it, but still marking it as needing to
be freed, which would cause at least a NULL dereference.

smatch warnings:
fs/pstore/ram.c:340 ramoops_pstore_read() error: we previously assumed 'prz' could be null (see line 255)

https://lists.01.org/pipermail/kbuild-all/2018-December/055528.html

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 2fbea82bbb89 ("pstore: Merge per-CPU ftrace records into one")
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 015d74ee31a03..631ae057ab537 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -301,6 +301,7 @@ static ssize_t ramoops_pstore_read(struct pstore_record *record)
 					  GFP_KERNEL);
 			if (!tmp_prz)
 				return -ENOMEM;
+			prz = tmp_prz;
 			free_prz = true;
 
 			while (cxt->ftrace_read_cnt < cxt->max_ftrace_cnt) {
@@ -323,7 +324,6 @@ static ssize_t ramoops_pstore_read(struct pstore_record *record)
 					goto out;
 			}
 			record->id = 0;
-			prz = tmp_prz;
 		}
 	}
 
-- 
2.20.1



