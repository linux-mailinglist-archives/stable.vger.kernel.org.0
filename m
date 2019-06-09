Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D989C3AAA1
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730903AbfFIQri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730891AbfFIQrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:47:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1765C206DF;
        Sun,  9 Jun 2019 16:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098856;
        bh=dsuY3ika3pM2TpW6IhoPArLRbVaGg/raG5jngM0Jwrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwGKyYHU1CQPhpP21tq4/HdVEEK2TlUqyyQKPUta56z7DzVSnZfFSjtmm3N2ujVUR
         G3XbFHSorEIPU9UpOSVgDmjk2foxCmIRvnWBwpOsKWQ4zOsNEmuAhVLxa5ujJ0FGuJ
         D88h79LgXSPRiKnR51vAteOB6FyMCxxP6zaj0h5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Yaro Slav <yaro330@gmail.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 14/51] Revert "fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied"
Date:   Sun,  9 Jun 2019 18:41:55 +0200
Message-Id: <20190609164127.924633657@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4970b42d5c362bf873982db7d93245c5281e58f4 ]

This reverts commit e9919a24d3022f72bcadc407e73a6ef17093a849.

Nathan reported the new behaviour breaks Android, as Android just add
new rules and delete old ones.

If we return 0 without adding dup rules, Android will remove the new
added rules and causing system to soft-reboot.

Fixes: e9919a24d302 ("fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Yaro Slav <yaro330@gmail.com>
Reported-by: Maciej Żenczykowski <zenczykowski@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/fib_rules.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -756,9 +756,9 @@ int fib_nl_newrule(struct sk_buff *skb,
 	if (err)
 		goto errout;
 
-	if (rule_exists(ops, frh, tb, rule)) {
-		if (nlh->nlmsg_flags & NLM_F_EXCL)
-			err = -EEXIST;
+	if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
+	    rule_exists(ops, frh, tb, rule)) {
+		err = -EEXIST;
 		goto errout_free;
 	}
 


