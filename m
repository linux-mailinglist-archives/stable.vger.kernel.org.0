Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AE1232D5E
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgG3IJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:09:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729746AbgG3IJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:09:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550422070B;
        Thu, 30 Jul 2020 08:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096593;
        bh=eUhvwrtCzl8ctpxf2MXDDRqpicwqtJPQF+VzXjCcQDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b79GmVgGe8oPk/WYRH0QV7xzJNz5eKGk5qn9A2cWHWycEw9Nw5ym+0uFJEYx7RYh9
         YKgcQzxeq9fihHtTc7oxPPs1Z7G0vH7N3smpTXE7EqU00xgvxW4DRb+7s12XipEkZW
         /yFi45vbyhMJR2Lk33iwzQSDHsjQ07Dd4BG3JL5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+c82752228ed975b0a623@syzkaller.appspotmail.com,
        Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 46/61] AX.25: Fix out-of-bounds read in ax25_connect()
Date:   Thu, 30 Jul 2020 10:05:04 +0200
Message-Id: <20200730074423.061102178@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit 2f2a7ffad5c6cbf3d438e813cfdc88230e185ba6 ]

Checks on `addr_len` and `fsa->fsa_ax25.sax25_ndigis` are insufficient.
ax25_connect() can go out of bounds when `fsa->fsa_ax25.sax25_ndigis`
equals to 7 or 8. Fix it.

This issue has been reported as a KMSAN uninit-value bug, because in such
a case, ax25_connect() reaches into the uninitialized portion of the
`struct sockaddr_storage` statically allocated in __sys_connect().

It is safe to remove `fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS` because
`addr_len` is guaranteed to be less than or equal to
`sizeof(struct full_sockaddr_ax25)`.

Reported-by: syzbot+c82752228ed975b0a623@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=55ef9d629f3b3d7d70b69558015b63b48d01af66
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1191,7 +1191,9 @@ static int __must_check ax25_connect(str
 	if (addr_len > sizeof(struct sockaddr_ax25) &&
 	    fsa->fsa_ax25.sax25_ndigis != 0) {
 		/* Valid number of digipeaters ? */
-		if (fsa->fsa_ax25.sax25_ndigis < 1 || fsa->fsa_ax25.sax25_ndigis > AX25_MAX_DIGIS) {
+		if (fsa->fsa_ax25.sax25_ndigis < 1 ||
+		    addr_len < sizeof(struct sockaddr_ax25) +
+		    sizeof(ax25_address) * fsa->fsa_ax25.sax25_ndigis) {
 			err = -EINVAL;
 			goto out_release;
 		}


