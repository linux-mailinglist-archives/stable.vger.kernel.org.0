Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AD83137C1
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhBHPat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231687AbhBHP0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:26:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ABF364F31;
        Mon,  8 Feb 2021 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797335;
        bh=9ssLXoxktnkifxFHN8BZERPbYjyLxBGVshfK2BtaSuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSk/YkK9sqaJwOoLOrOntBWRviUZviDDwgRf884HEyl7qJydJqXu0DB/asxqtlkbb
         DnAh5Q5J70zDOygVZyTmrB5Khftav0VQx/45bDXmFG9srZ1hcuVqKLVzKO6SSZOD9R
         65QTHE8O88EapYX7E7v3/ceYsVpuCo4kSNRxdEFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 074/120] smb3: fix crediting for compounding when only one request in flight
Date:   Mon,  8 Feb 2021 16:01:01 +0100
Message-Id: <20210208145821.364490485@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
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
@@ -655,10 +655,22 @@ wait_for_compound_request(struct TCP_Ser
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


