Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21206313744
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbhBHPWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:22:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233517AbhBHPOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:14:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F4FD64ECB;
        Mon,  8 Feb 2021 15:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797050;
        bh=PJ6Jtig7KPgqGEEqxQ1Xnv6Kxjj3F3qRz2LrumFTtHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLS8uddC6cEtlBkhT34FXlkniNApHseNyxJvsW376e0KisizPotmAJ1kwK76oppZw
         6GWAOPeFZwchwayxTKvtgxi6tTyxWyKbFjZSsZDGifx+HSgpCLg1sN2RyXUxDsi/YO
         D3sGDU+A+9X4aFLNelmNanoZLCAXptpZSrZXIwwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 41/65] smb3: fix crediting for compounding when only one request in flight
Date:   Mon,  8 Feb 2021 16:01:13 +0100
Message-Id: <20210208145811.812309797@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

commit 91792bb8089b63b7b780251eb83939348ac58a64 upstream.

Currently we try to guess if a compound request is going to
succeed waiting for credits or not based on the number of
requests in flight. This approach doesn't work correctly
all the time because there may be only one request in
flight which is going to bring multiple credits satisfying
the compound request.

Change the behavior to fail a request only if there are no requests
in flight at all and proceed waiting for credits otherwise.

Cc: <stable@vger.kernel.org> # 5.1+
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Reviewed-by: Shyam Prasad N <nspmangalore@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/transport.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -659,10 +659,22 @@ wait_for_compound_request(struct TCP_Ser
 	spin_lock(&server->req_lock);
 	if (*credits < num) {
 		/*
-		 * Return immediately if not too many requests in flight since
-		 * we will likely be stuck on waiting for credits.
+		 * If the server is tight on resources or just gives us less
+		 * credits for other reasons (e.g. requests are coming out of
+		 * order and the server delays granting more credits until it
+		 * processes a missing mid) and we exhausted most available
+		 * credits there may be situations when we try to send
+		 * a compound request but we don't have enough credits. At this
+		 * point the client needs to decide if it should wait for
+		 * additional credits or fail the request. If at least one
+		 * request is in flight there is a high probability that the
+		 * server will return enough credits to satisfy this compound
+		 * request.
+		 *
+		 * Return immediately if no requests in flight since we will be
+		 * stuck on waiting for credits.
 		 */
-		if (server->in_flight < num - *credits) {
+		if (server->in_flight == 0) {
 			spin_unlock(&server->req_lock);
 			return -ENOTSUPP;
 		}


