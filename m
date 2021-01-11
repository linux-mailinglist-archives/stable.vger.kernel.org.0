Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A622F1448
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbhAKNSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733105AbhAKNS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3487F22A83;
        Mon, 11 Jan 2021 13:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371092;
        bh=38g0OaW0S0xlW9lL1byQD9zjXHWS9D4jvgtVRmqoqac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ii/YDLAhvzpGXcJC4FDR4uIQhuWK89BopS2vGlZRJaKkRSGQ3KrhNlqT0N/1ftvfF
         8HeW074eiJsBHhwZuPgL+RV9MpD9RRMP7w9iy/rIAZD49PPfWa0SkQ4pWkqaM0kd1D
         /Zl6Skw4sazHd/Df0/aqbDfMkyCZSJTq8QA3zvR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 139/145] netfilter: xt_RATEEST: reject non-null terminated string from userspace
Date:   Mon, 11 Jan 2021 14:02:43 +0100
Message-Id: <20210111130055.187923678@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 6cb56218ad9e580e519dcd23bfb3db08d8692e5a upstream.

syzbot reports:
detected buffer overflow in strlen
[..]
Call Trace:
 strlen include/linux/string.h:325 [inline]
 strlcpy include/linux/string.h:348 [inline]
 xt_rateest_tg_checkentry+0x2a5/0x6b0 net/netfilter/xt_RATEEST.c:143

strlcpy assumes src is a c-string. Check info->name before its used.

Reported-by: syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com
Fixes: 5859034d7eb8793 ("[NETFILTER]: x_tables: add RATEEST target")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_RATEEST.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -115,6 +115,9 @@ static int xt_rateest_tg_checkentry(cons
 	} cfg;
 	int ret;
 
+	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
+		return -ENAMETOOLONG;
+
 	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
 
 	mutex_lock(&xn->hash_lock);


