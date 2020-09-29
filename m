Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2A027C6D3
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgI2LtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729955AbgI2Ls6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6B672083B;
        Tue, 29 Sep 2020 11:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380138;
        bh=jHWn/Vris5ab3EyU7q0T+C5BBCMEeASBeyK4+7BStbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1646tCpskLVMLCKYvjlBTflCDU28BnyUPBA6Luwt0MRglfeHBlqEFp1kT/yERNJsw
         JiXqRFMw0ezVDh012MI2ozc8zoOeb2USpcDEhMOG5MF6dd2fsulZH7em88uwypNpFs
         0x6Ymdg9qqx9nlBckln8PqoPRUuvgsmXyKN/S/T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.8 83/99] lib/bootconfig: Fix to remove tailing spaces after value
Date:   Tue, 29 Sep 2020 13:02:06 +0200
Message-Id: <20200929105933.822431869@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit c7af4ecdffe1537ba8aeed0ac12c3326f908df43 upstream.

Fix to remove tailing spaces after value. If there is a space
after value, the bootconfig failed to remove it because it
applies strim() before replacing the delimiter with null.

For example,

foo = var    # comment

was parsed as below.

foo="var    "

but user will expect

foo="var"

This fixes it by applying strim() after removing the delimiter.

Link: https://lkml.kernel.org/r/160068149134.1088739.8868306567670058853.stgit@devnote2

Fixes: 76db5a27a827 ("bootconfig: Add Extra Boot Config support")
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -486,8 +486,8 @@ static int __init __xbc_parse_value(char
 			break;
 		}
 		if (strchr(",;\n#}", c)) {
-			v = strim(v);
 			*p++ = '\0';
+			v = strim(v);
 			break;
 		}
 	}


