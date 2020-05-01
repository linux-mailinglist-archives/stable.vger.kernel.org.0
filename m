Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3A71C1398
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgEANbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:31:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729542AbgEANbF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:31:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2886D208D6;
        Fri,  1 May 2020 13:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339864;
        bh=edkgb4YFtV0pjk4fMcb3zIHYot/KfuGSfN95srNmDaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlFTd18a/+PdkdlO5xvC9RvUrJJYtTe06niY5Owkq+pbTW/6Q77yEg2duGVt5tNFU
         JcLAzyJzcVQ7zb5yFPRj3S+ImHIbxEz5024NV/PWqyXBAzZ/TGES6It+cQd2pRRDFl
         62uX0Gq+KTRi+TtCrMFfwwtaEVe4/fvKDdWMCq5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 002/117] net: ipv4: emulate READ_ONCE() on ->hdrincl bit-field in raw_sendmsg()
Date:   Fri,  1 May 2020 15:20:38 +0200
Message-Id: <20200501131544.590806170@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolai Stange <nstange@suse.de>

commit 20b50d79974ea3192e8c3ab7faf4e536e5f14d8f upstream.

Commit 8f659a03a0ba ("net: ipv4: fix for a race condition in
raw_sendmsg") fixed the issue of possibly inconsistent ->hdrincl handling
due to concurrent updates by reading this bit-field member into a local
variable and using the thus stabilized value in subsequent tests.

However, aforementioned commit also adds the (correct) comment that

  /* hdrincl should be READ_ONCE(inet->hdrincl)
   * but READ_ONCE() doesn't work with bit fields
   */

because as it stands, the compiler is free to shortcut or even eliminate
the local variable at its will.

Note that I have not seen anything like this happening in reality and thus,
the concern is a theoretical one.

However, in order to be on the safe side, emulate a READ_ONCE() on the
bit-field by doing it on the local 'hdrincl' variable itself:

	int hdrincl = inet->hdrincl;
	hdrincl = READ_ONCE(hdrincl);

This breaks the chain in the sense that the compiler is not allowed
to replace subsequent reads from hdrincl with reloads from inet->hdrincl.

Fixes: 8f659a03a0ba ("net: ipv4: fix for a race condition in raw_sendmsg")
Signed-off-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/raw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -520,9 +520,11 @@ static int raw_sendmsg(struct sock *sk,
 		goto out;
 
 	/* hdrincl should be READ_ONCE(inet->hdrincl)
-	 * but READ_ONCE() doesn't work with bit fields
+	 * but READ_ONCE() doesn't work with bit fields.
+	 * Doing this indirectly yields the same result.
 	 */
 	hdrincl = inet->hdrincl;
+	hdrincl = READ_ONCE(hdrincl);
 	/*
 	 *	Check the flags.
 	 */


