Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD80417436
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345440AbhIXNDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345745AbhIXNBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:01:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CDA36140F;
        Fri, 24 Sep 2021 12:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488066;
        bh=YN4sg+A4COQS9FIG8U7VhzOngajLK+jzTcdur6B65n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrQ7uXY9y1Qvm2wknaHaxYqmGX49MpDnIpy0f8f+CObsZ5Tx9VQjdBt4qU/bKaXtu
         pbZXRYWwDgrkuXC73fnECblbvtdjz9W4vpSRcoQo6uBa8kUer+t7C/jaSKtuwYOdMg
         HDsSatmmDgwdhv6RNZEMtuY0OyOUZYyI0xFJqV5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 039/100] tools/bootconfig: Fix tracing_on option checking in ftrace2bconf.sh
Date:   Fri, 24 Sep 2021 14:43:48 +0200
Message-Id: <20210924124342.767754659@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
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



