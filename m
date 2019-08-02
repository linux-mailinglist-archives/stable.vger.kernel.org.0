Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F247F318
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406373AbfHBJyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406352AbfHBJyG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:54:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDADF2064A;
        Fri,  2 Aug 2019 09:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739645;
        bh=0QrHLcZlTxBxRrMNGwkZ6LT+konluKI3yPm9WcrEoMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0i5DuK+JkS4F0AmpqIpKW84FX2duHO2QqaMPoG+mgqYXly9TFBYIDIxKvqC5K4Is
         00JJvL28Z34KDs29YEG0fC+CXfY2J2A9hFkBOfuDNAy3WAEvsjrCCZ4I0cU0BOcTfq
         AnU1+bfK4z8nvkIrRgIH70T3xWgjozIDqXfSCQsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7fe11b49c1cc30e3fce2@syzkaller.appspotmail.com,
        Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.14 15/25] NFS: Cleanup if nfs_match_client is interrupted
Date:   Fri,  2 Aug 2019 11:39:47 +0200
Message-Id: <20190802092104.271855151@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

commit 9f7761cf0409465075dadb875d5d4b8ef2f890c8 upstream.

Don't bail out before cleaning up a new allocation if the wait for
searching for a matching nfs client is interrupted.  Memory leaks.

Reported-by: syzbot+7fe11b49c1cc30e3fce2@syzkaller.appspotmail.com
Fixes: 950a578c6128 ("NFS: make nfs_match_client killable")
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/client.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -416,10 +416,10 @@ struct nfs_client *nfs_get_client(const
 		clp = nfs_match_client(cl_init);
 		if (clp) {
 			spin_unlock(&nn->nfs_client_lock);
-			if (IS_ERR(clp))
-				return clp;
 			if (new)
 				new->rpc_ops->free_client(new);
+			if (IS_ERR(clp))
+				return clp;
 			return nfs_found_client(cl_init, clp);
 		}
 		if (new) {


