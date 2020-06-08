Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2F31F2D20
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbgFHXPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbgFHXPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D48762076C;
        Mon,  8 Jun 2020 23:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658132;
        bh=qhGBPMBKT8RTQQbdhq46yT8ycHE+O/Ie6Cv56w2lojE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdV1GwiVYiF5320uGISqfGNzeSPt7rD5D5Kgl66AnoQVViG4E+tYU5lShzaGevbcM
         oZBq6nQZKY1isUxq0ou4uJzPbIXShae3VB0LGKxfmgWdV5tP7BqVVIe6E9sCjwugKk
         QEpw8DwesWqQUyUNTPbOF1mmr8TgSjhiyhmbQOW4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 167/606] tools/bootconfig: Fix apply_xbc() to return zero on success
Date:   Mon,  8 Jun 2020 19:04:52 -0400
Message-Id: <20200608231211.3363633-167-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

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

