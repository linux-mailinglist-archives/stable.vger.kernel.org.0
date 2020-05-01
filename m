Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8F01C149F
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbgEANlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731106AbgEANlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:41:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BBDB20757;
        Fri,  1 May 2020 13:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340477;
        bh=B1uZsd6re70zLVq6PjRevFnz2XLlg1hnPKISIIgjAf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozuHuHKorwyM8gCsR0QmzhgUO4aqx1+IhzentSIe4lJEqPJ0hQv+8s6/GoWS6VpL3
         xLZoKWHEwmRrWlx2wTuZFuRWLoFasS0t1bn2wBKjHjPj0LMuedyVMyO/+kH5cykLNN
         7jraQ6FjGclGD8PDWtH6dXbkMTI2IO4d1Pt6YsTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.6 010/106] afs: Fix to actually set AFS_SERVER_FL_HAVE_EPOCH
Date:   Fri,  1 May 2020 15:22:43 +0200
Message-Id: <20200501131545.582991701@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 69cf3978f3ada4e54beae4ad44868b5627864884 upstream.

AFS keeps track of the epoch value from the rxrpc protocol to note (a) when
a fileserver appears to have restarted and (b) when different endpoints of
a fileserver do not appear to be associated with the same fileserver
(ie. all probes back from a fileserver from all of its interfaces should
carry the same epoch).

However, the AFS_SERVER_FL_HAVE_EPOCH flag that indicates that we've
received the server's epoch is never set, though it is used.

Fix this to set the flag when we first receive an epoch value from a probe
sent to the filesystem client from the fileserver.

Fixes: 3bf0fb6f33dd ("afs: Probe multiple fileservers simultaneously")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/cmservice.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -169,7 +169,7 @@ static int afs_record_cm_probe(struct af
 
 	spin_lock(&server->probe_lock);
 
-	if (!test_bit(AFS_SERVER_FL_HAVE_EPOCH, &server->flags)) {
+	if (!test_and_set_bit(AFS_SERVER_FL_HAVE_EPOCH, &server->flags)) {
 		server->cm_epoch = call->epoch;
 		server->probe.cm_epoch = call->epoch;
 		goto out;


