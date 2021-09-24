Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB5341750E
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346809AbhIXNOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346169AbhIXNMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A39613CE;
        Fri, 24 Sep 2021 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488330;
        bh=YN4sg+A4COQS9FIG8U7VhzOngajLK+jzTcdur6B65n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/IagCKpgmTfsC55e6MtAAYouh/Yy31YIej9weOHn4LoXHFSdDdWzZ9CcdiT1f/Pz
         bldaLCSYd1JIAKvJIPggiEwNLvx7x6g/cwI5B8mScXTpYFJqjzqhqdfHD8mhOWqBRL
         BnUNcBL9d1mhpbXXhVcW2NDTkcXJiB5jCNslddmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/63] tools/bootconfig: Fix tracing_on option checking in ftrace2bconf.sh
Date:   Fri, 24 Sep 2021 14:44:33 +0200
Message-Id: <20210924124335.405312246@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 32ba9f0fb027cc43074e3ea26fcf831adeee8e03 ]

Since tracing_on indicates only "1" (default) or "0", ftrace2bconf.sh
only need to check the value is "0".

Link: https://lkml.kernel.org/r/163077087144.222577.6888011847727968737.stgit@devnote2

Fixes: 55ed4560774d ("tools/bootconfig: Add tracing_on support to helper scripts")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/scripts/ftrace2bconf.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bootconfig/scripts/ftrace2bconf.sh b/tools/bootconfig/scripts/ftrace2bconf.sh
index a0c3bcc6da4f..fb201d5afe2c 100755
--- a/tools/bootconfig/scripts/ftrace2bconf.sh
+++ b/tools/bootconfig/scripts/ftrace2bconf.sh
@@ -222,8 +222,8 @@ instance_options() { # [instance-name]
 		emit_kv $PREFIX.cpumask = $val
 	fi
 	val=`cat $INSTANCE/tracing_on`
-	if [ `echo $val | sed -e s/f//g`x != x ]; then
-		emit_kv $PREFIX.tracing_on = $val
+	if [ "$val" = "0" ]; then
+		emit_kv $PREFIX.tracing_on = 0
 	fi
 
 	val=
-- 
2.33.0



