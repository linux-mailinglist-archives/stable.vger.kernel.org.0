Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88E03F64E9
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbhHXRIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235277AbhHXRGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:06:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 271CE619E4;
        Tue, 24 Aug 2021 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824389;
        bh=c1Gn0Qd0J8q38vZoZiZyLl/oKuQwchi9lzl4mHg3qZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvqD/Va00/mmDobbspv3rfcIfUnAjyK2XsAEOM+HgVo70rVCahPaeL90poCr7E98M
         0AO3/TpHjqTY7G5P30JRklEyEaG92M5q8eYNwcq7Ul8dmEpgCLr9pk02SFBHpSUtsF
         Wbagj1XCCU/YbzPNrLIx3biYYN47mm4ivkl1yI7FGle0iGRRWlekttQlPTxsEcEoCk
         BEhPED2dKn/Un6nWMex4x+YtAZksNX1GMhwiikZSpYu4c/SC0B254pM8GenDoSUmtJ
         bEqCoNca3myv4ChdAF7n5IbS1WwwMwkUL+5tBRNhJ8RFyzwZo7s1B1lMTcBjGFhgJ9
         tVL2pHnJqBdqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>, dccp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/98] dccp: add do-while-0 stubs for dccp_pr_debug macros
Date:   Tue, 24 Aug 2021 12:58:09 -0400
Message-Id: <20210824165908.709932-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 86aab09a4870bb8346c9579864588c3d7f555299 ]

GCC complains about empty macros in an 'if' statement, so convert
them to 'do {} while (0)' macros.

Fixes these build warnings:

net/dccp/output.c: In function 'dccp_xmit_packet':
../net/dccp/output.c:283:71: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
  283 |                 dccp_pr_debug("transmit_skb() returned err=%d\n", err);
net/dccp/ackvec.c: In function 'dccp_ackvec_update_old':
../net/dccp/ackvec.c:163:80: warning: suggest braces around empty body in an 'else' statement [-Wempty-body]
  163 |                                               (unsigned long long)seqno, state);

Fixes: dc841e30eaea ("dccp: Extend CCID packet dequeueing interface")
Fixes: 380240864451 ("dccp ccid-2: Update code for the Ack Vector input/registration routine")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: dccp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dccp/dccp.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 9cc9d1ee6cdb..c5c1d2b8045e 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -41,9 +41,9 @@ extern bool dccp_debug;
 #define dccp_pr_debug_cat(format, a...)   DCCP_PRINTK(dccp_debug, format, ##a)
 #define dccp_debug(fmt, a...)		  dccp_pr_debug_cat(KERN_DEBUG fmt, ##a)
 #else
-#define dccp_pr_debug(format, a...)
-#define dccp_pr_debug_cat(format, a...)
-#define dccp_debug(format, a...)
+#define dccp_pr_debug(format, a...)	  do {} while (0)
+#define dccp_pr_debug_cat(format, a...)	  do {} while (0)
+#define dccp_debug(format, a...)	  do {} while (0)
 #endif
 
 extern struct inet_hashinfo dccp_hashinfo;
-- 
2.30.2

