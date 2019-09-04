Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F70A8FFC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389118AbfIDSHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389556AbfIDSHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:07:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E6AF206B8;
        Wed,  4 Sep 2019 18:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620419;
        bh=/G2L9rpwpWgF/1asPzMmBbVZZzUgI+VRzg/JqC53Kxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRdYbJlkBc5yxLJPrll8KKKXE9lfISUehnMB8oRNQJdPOkSx/6ewrjhB0a/W0dK9x
         1bJSAaTLv9/B+NckyYjdcY9U2AwLWy9YX2RGCa8ufo4ChoZlYv1qPGhVKRY+eWel4P
         SfaK2c6+OsiOfHEf19DfwQ/uCJI+vW0Q09PHV3sg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 52/93] ftrace: Check for successful allocation of hash
Date:   Wed,  4 Sep 2019 19:53:54 +0200
Message-Id: <20190904175307.488673549@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

commit 5b0022dd32b7c2e15edf1827ba80aa1407edf9ff upstream.

In register_ftrace_function_probe(), we are not checking the return
value of alloc_and_copy_ftrace_hash(). The subsequent call to
ftrace_match_records() may end up dereferencing the same. Add a check to
ensure this doesn't happen.

Link: http://lkml.kernel.org/r/26e92574f25ad23e7cafa3cf5f7a819de1832cbe.1562249521.git.naveen.n.rao@linux.vnet.ibm.com

Cc: stable@vger.kernel.org
Fixes: 1ec3a81a0cf42 ("ftrace: Have each function probe use its own ftrace_ops")
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/ftrace.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4317,6 +4317,11 @@ register_ftrace_function_probe(char *glo
 	old_hash = *orig_hash;
 	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, old_hash);
 
+	if (!hash) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	ret = ftrace_match_records(hash, glob, strlen(glob));
 
 	/* Nothing found? */


