Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FEB2D0412
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgLFLnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgLFLms (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:42:48 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, =?UTF-8?q?kiyin ?= <kiyin@tencent.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 24/39] net/x25: prevent a couple of overflows
Date:   Sun,  6 Dec 2020 12:17:28 +0100
Message-Id: <20201206111555.835757221@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6ee50c8e262a0f0693dad264c3c99e30e6442a56 ]

The .x25_addr[] address comes from the user and is not necessarily
NUL terminated.  This leads to a couple problems.  The first problem is
that the strlen() in x25_bind() can read beyond the end of the buffer.

The second problem is more subtle and could result in memory corruption.
The call tree is:
  x25_connect()
  --> x25_write_internal()
      --> x25_addr_aton()

The .x25_addr[] buffers are copied to the "addresses" buffer from
x25_write_internal() so it will lead to stack corruption.

Verify that the strings are NUL terminated and return -EINVAL if they
are not.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: a9288525d2ae ("X25: Dont let x25_bind use addresses containing characters")
Reported-by: "kiyin(尹亮)" <kiyin@tencent.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Martin Schiller <ms@dev.tdt.de>
Link: https://lore.kernel.org/r/X8ZeAKm8FnFpN//B@mwanda
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/x25/af_x25.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -675,7 +675,8 @@ static int x25_bind(struct socket *sock,
 	int len, i, rc = 0;
 
 	if (addr_len != sizeof(struct sockaddr_x25) ||
-	    addr->sx25_family != AF_X25) {
+	    addr->sx25_family != AF_X25 ||
+	    strnlen(addr->sx25_addr.x25_addr, X25_ADDR_LEN) == X25_ADDR_LEN) {
 		rc = -EINVAL;
 		goto out;
 	}
@@ -769,7 +770,8 @@ static int x25_connect(struct socket *so
 
 	rc = -EINVAL;
 	if (addr_len != sizeof(struct sockaddr_x25) ||
-	    addr->sx25_family != AF_X25)
+	    addr->sx25_family != AF_X25 ||
+	    strnlen(addr->sx25_addr.x25_addr, X25_ADDR_LEN) == X25_ADDR_LEN)
 		goto out;
 
 	rc = -ENETUNREACH;


