Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D1C1E2CCB
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392241AbgEZTRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404352AbgEZTOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:14:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A407208B6;
        Tue, 26 May 2020 19:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520460;
        bh=6s0esmbuhORqW3ghCADkZDwb2rfkAM/yLBfDpUl9yg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBn0Ip0NzVdauRNE2j5JULxu1W+4bIWT+5ocTxfMOnzZW73u8aV2pVAdzLDfD2lMN
         qDVarjyyP4c2MwL6koXeLX4EY5stjjoqvakL2Gf2DawgWWpfXmyHzXYnDA3uuLPws3
         m/4j4e34pKYTZE9dTq45FuOxv41+1LHwXtLvrbWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 088/126] tools/bootconfig: Fix apply_xbc() to return zero on success
Date:   Tue, 26 May 2020 20:53:45 +0200
Message-Id: <20200526183945.367638554@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit 9d82ccda2bc5c148060543d249d54f8703741bb4 ]

The return of apply_xbc() returns the result of the last write() call, which
is not what is expected. It should only return zero on success.

Link: https://lore.kernel.org/r/20200508093059.GF9365@kadam

Fixes: 8842604446d1 ("tools/bootconfig: Fix resource leak in apply_xbc()")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index 5dbe893cf00c..37fb2e85de12 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -310,6 +310,7 @@ int apply_xbc(const char *path, const char *xbc_path)
 		pr_err("Failed to apply a boot config magic: %d\n", ret);
 		goto out;
 	}
+	ret = 0;
 out:
 	close(fd);
 	free(data);
-- 
2.25.1



