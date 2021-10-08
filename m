Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91034426903
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbhJHLdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240813AbhJHLcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15AA161056;
        Fri,  8 Oct 2021 11:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692619;
        bh=vKVbBT6K7EUFgsS0onoo+QViMYFx200+LtUtja1hZj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ku+rfyo0lhjshfinC4Qpwh/Ht+GpQHjvISv3SBVux1VRzlTYLmyUplywfU6r5GIP+
         m/goquWv0zUsBJa71GrftqlcfBJXMgP0K5DqieHCuOgNmMlzze+K2p2mcZTeJx3thM
         5US34pVLnFJ+YATFcOONtXqCDDjaTULqm7b2G+Ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rik van Riel <riel@surriel.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        =?UTF-8?q?Krzysztof=20Ol=C4=99dzki?= <ole@ans.pl>
Subject: [PATCH 5.4 15/16] silence nfscache allocation warnings with kvzalloc
Date:   Fri,  8 Oct 2021 13:28:05 +0200
Message-Id: <20211008112715.984293302@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112715.444305067@linuxfoundation.org>
References: <20211008112715.444305067@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rik van Riel <riel@surriel.com>

commit 8c38b705b4f4ca4e7f9cc116141bc38391917c30 upstream.

silence nfscache allocation warnings with kvzalloc

Currently nfsd_reply_cache_init attempts hash table allocation through
kmalloc, and manually falls back to vzalloc if that fails. This makes
the code a little larger than needed, and creates a significant amount
of serial console spam if you have enough systems.

Switching to kvzalloc gets rid of the allocation warnings, and makes
the code a little cleaner too as a side effect.

Freeing of nn->drc_hashtbl is already done using kvfree currently.

Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: Krzysztof Olędzki <ole@ans.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -173,14 +173,10 @@ int nfsd_reply_cache_init(struct nfsd_ne
 	if (status)
 		goto out_nomem;
 
-	nn->drc_hashtbl = kcalloc(hashsize,
-				sizeof(*nn->drc_hashtbl), GFP_KERNEL);
-	if (!nn->drc_hashtbl) {
-		nn->drc_hashtbl = vzalloc(array_size(hashsize,
-						 sizeof(*nn->drc_hashtbl)));
-		if (!nn->drc_hashtbl)
-			goto out_shrinker;
-	}
+	nn->drc_hashtbl = kvzalloc(array_size(hashsize,
+				sizeof(*nn->drc_hashtbl)), GFP_KERNEL);
+	if (!nn->drc_hashtbl)
+		goto out_shrinker;
 
 	for (i = 0; i < hashsize; i++) {
 		INIT_LIST_HEAD(&nn->drc_hashtbl[i].lru_head);


