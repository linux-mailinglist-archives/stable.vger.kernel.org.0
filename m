Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3034E761E
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359801AbiCYPKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359775AbiCYPJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:09:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A88DAFC1;
        Fri, 25 Mar 2022 08:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7468361C14;
        Fri, 25 Mar 2022 15:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817B2C340EE;
        Fri, 25 Mar 2022 15:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220847;
        bh=hfnD0IaVDMjKW0Z+paPYvWTlpQ/2eeOa5et+T8s/UdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBEVldzuJFWX49glc1RUoygNY59zQPboL39suj9piJZ/b8etD4MJAoO+S9ZnxYmgU
         xwmjxLH1DROPgkCGz1W/VZLauzvAEwMep8GW+ExJC+ox3dB6AFH0Gv2lF/AWzSZogJ
         9+yuLmq1dwsYvEFqxtxIo3ZQxZ52RFrCKbl16XBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Khazhy Kumykov <khazhy@google.com>
Subject: [PATCH 5.4 01/29] nfsd: cleanup nfsd_file_lru_dispose()
Date:   Fri, 25 Mar 2022 16:04:41 +0100
Message-Id: <20220325150418.629382640@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

commit 36ebbdb96b694dd9c6b25ad98f2bbd263d022b63 upstream.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Cc: Khazhy Kumykov <khazhy@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -260,8 +260,6 @@ nfsd_file_do_unhash(struct nfsd_file *nf
 		nfsd_reset_boot_verifier(net_generic(nf->nf_net, nfsd_net_id));
 	--nfsd_file_hashtbl[nf->nf_hashval].nfb_count;
 	hlist_del_rcu(&nf->nf_node);
-	if (!list_empty(&nf->nf_lru))
-		list_lru_del(&nfsd_file_lru, &nf->nf_lru);
 	atomic_long_dec(&nfsd_filecache_count);
 }
 
@@ -270,6 +268,8 @@ nfsd_file_unhash(struct nfsd_file *nf)
 {
 	if (test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
 		nfsd_file_do_unhash(nf);
+		if (!list_empty(&nf->nf_lru))
+			list_lru_del(&nfsd_file_lru, &nf->nf_lru);
 		return true;
 	}
 	return false;
@@ -406,15 +406,14 @@ out_skip:
 static void
 nfsd_file_lru_dispose(struct list_head *head)
 {
-	while(!list_empty(head)) {
-		struct nfsd_file *nf = list_first_entry(head,
-				struct nfsd_file, nf_lru);
-		list_del_init(&nf->nf_lru);
+	struct nfsd_file *nf;
+
+	list_for_each_entry(nf, head, nf_lru) {
 		spin_lock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
 		nfsd_file_do_unhash(nf);
 		spin_unlock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-		nfsd_file_put_noref(nf);
 	}
+	nfsd_file_dispose_list(head);
 }
 
 static unsigned long


