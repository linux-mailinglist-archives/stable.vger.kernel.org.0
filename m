Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E241E2AC4
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390400AbgEZS6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390412AbgEZS6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:58:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA1812086A;
        Tue, 26 May 2020 18:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519530;
        bh=YSXS+QC2vBu+xyMqvrQ4vKEgvS07yXqDvMHZSQLqWf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u37jLfelOXChsaaeVcF53DIBm/OZulz3/fATt5589BFYshjSIk5PKwuKKlM1nqis6
         RfBu0e9dUQHKXxWWTSya4nsl5HFUoWuSd26YQAA7KSjZrfs4HFkcfMqsRAvZGgszc4
         IY6HXJUQLV3tdBmqF9Gn83TeXorGs63Lu8PzwTRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thiago Macieira <thiago.macieira@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>, stable@kernel.org
Subject: [PATCH 4.9 08/64] fix multiplication overflow in copy_fdtable()
Date:   Tue, 26 May 2020 20:52:37 +0200
Message-Id: <20200526183916.239049463@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 4e89b7210403fa4a8acafe7c602b6212b7af6c3b ]

cpy and set really should be size_t; we won't get an overflow on that,
since sysctl_nr_open can't be set above ~(size_t)0 / sizeof(void *),
so nr that would've managed to overflow size_t on that multiplication
won't get anywhere near copy_fdtable() - we'll fail with EMFILE
before that.

Cc: stable@kernel.org # v2.6.25+
Fixes: 9cfe015aa424 (get rid of NR_OPEN and introduce a sysctl_nr_open)
Reported-by: Thiago Macieira <thiago.macieira@intel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index 09aac4d4729b..82d3f925bab3 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -89,7 +89,7 @@ static void copy_fd_bitmaps(struct fdtable *nfdt, struct fdtable *ofdt,
  */
 static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 {
-	unsigned int cpy, set;
+	size_t cpy, set;
 
 	BUG_ON(nfdt->max_fds < ofdt->max_fds);
 
-- 
2.25.1



