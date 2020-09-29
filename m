Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E854227CB6B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732643AbgI2M1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbgI2LdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAD7923B44;
        Tue, 29 Sep 2020 11:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378767;
        bh=dd0qtlhGR+BuXIEjFCLdHvdAATNJgb10wbQgvOO26c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upQ6h2sQj++jRDcguoxWFLjuOQ66H298t3lA/WXr1v1iz3dEhElzIpRPPUZ7nY9M7
         uiKHGniboBH5d3b0Z6aZpVotKsNF8KViS59qkUk+Lje5O6VuiZxSsH1GBahq+ArfLP
         LWINbjKi9+ht+u7bKLtXEmPNAbbkMkBQxiTcQ+3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/245] SUNRPC: Fix a potential buffer overflow in svc_print_xprts()
Date:   Tue, 29 Sep 2020 12:59:42 +0200
Message-Id: <20200929105953.363620262@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b25b60d7bfb02a74bc3c2d998e09aab159df8059 ]

'maxlen' is the total size of the destination buffer. There is only one
caller and this value is 256.

When we compute the size already used and what we would like to add in
the buffer, the trailling NULL character is not taken into account.
However, this trailling character will be added by the 'strcat' once we
have checked that we have enough place.

So, there is a off-by-one issue and 1 byte of the stack could be
erroneously overwridden.

Take into account the trailling NULL, when checking if there is enough
place in the destination buffer.

While at it, also replace a 'sprintf' by a safer 'snprintf', check for
output truncation and avoid a superfluous 'strlen'.

Fixes: dc9a16e49dbba ("svc: Add /proc/sys/sunrpc/transport files")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
[ cel: very minor fix to documenting comment
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc_xprt.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index c8ee8e801edb8..709c082dc9059 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -103,8 +103,17 @@ void svc_unreg_xprt_class(struct svc_xprt_class *xcl)
 }
 EXPORT_SYMBOL_GPL(svc_unreg_xprt_class);
 
-/*
- * Format the transport list for printing
+/**
+ * svc_print_xprts - Format the transport list for printing
+ * @buf: target buffer for formatted address
+ * @maxlen: length of target buffer
+ *
+ * Fills in @buf with a string containing a list of transport names, each name
+ * terminated with '\n'. If the buffer is too small, some entries may be
+ * missing, but it is guaranteed that all lines in the output buffer are
+ * complete.
+ *
+ * Returns positive length of the filled-in string.
  */
 int svc_print_xprts(char *buf, int maxlen)
 {
@@ -117,9 +126,9 @@ int svc_print_xprts(char *buf, int maxlen)
 	list_for_each_entry(xcl, &svc_xprt_class_list, xcl_list) {
 		int slen;
 
-		sprintf(tmpstr, "%s %d\n", xcl->xcl_name, xcl->xcl_max_payload);
-		slen = strlen(tmpstr);
-		if (len + slen > maxlen)
+		slen = snprintf(tmpstr, sizeof(tmpstr), "%s %d\n",
+				xcl->xcl_name, xcl->xcl_max_payload);
+		if (slen >= sizeof(tmpstr) || len + slen >= maxlen)
 			break;
 		len += slen;
 		strcat(buf, tmpstr);
-- 
2.25.1



