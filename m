Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69697505040
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbiDRMXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238573AbiDRMWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:22:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548251E3E3;
        Mon, 18 Apr 2022 05:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4195CE1077;
        Mon, 18 Apr 2022 12:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90880C385A7;
        Mon, 18 Apr 2022 12:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284269;
        bh=8knLZoPJk4a53zkhcmAmTdECi6kU/0EGUcp5Zlk78SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXnwJoaeDGMn+1uZ/f7kDg3xFOec8iOjzfst893O6W3e1Jpr7pdsNr2B6TDaOzlAx
         xe8EeiAjCAwgmySGy4Vi9I+GquCP6Is143AjqRXIZQtOR8bQoCPwTpJBri/8xrTHa8
         NEQgKv8iRfLzBblP97ty4q4aZvcuHbGatUW9uC80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 059/219] nfsd: Fix a write performance regression
Date:   Mon, 18 Apr 2022 14:10:28 +0200
Message-Id: <20220418121207.048407777@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6b8a94332ee4f7d9a8ae0cbac7609f79c212f06c ]

The call to filemap_flush() in nfsd_file_put() is there to ensure that
we clear out any writes belonging to a NFSv3 client relatively quickly
and avoid situations where the file can't be evicted by the garbage
collector. It also ensures that we detect write errors quickly.

The problem is this causes a regression in performance for some
workloads.

So try to improve matters by deferring writeback until we're ready to
close the file, and need to detect errors so that we can force the
client to resend.

Tested-by: Jan Kara <jack@suse.cz>
Fixes: b6669305d35a ("nfsd: Reduce the number of calls to nfsd_file_gc()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Link: https://lore.kernel.org/all/20220330103457.r4xrhy2d6nhtouzk@quack3.lan
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index cc2831cec669..496f7b3f7523 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -235,6 +235,13 @@ nfsd_file_check_write_error(struct nfsd_file *nf)
 	return filemap_check_wb_err(file->f_mapping, READ_ONCE(file->f_wb_err));
 }
 
+static void
+nfsd_file_flush(struct nfsd_file *nf)
+{
+	if (nf->nf_file && vfs_fsync(nf->nf_file, 1) != 0)
+		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
+}
+
 static void
 nfsd_file_do_unhash(struct nfsd_file *nf)
 {
@@ -302,11 +309,14 @@ nfsd_file_put(struct nfsd_file *nf)
 		return;
 	}
 
-	filemap_flush(nf->nf_file->f_mapping);
 	is_hashed = test_bit(NFSD_FILE_HASHED, &nf->nf_flags) != 0;
-	nfsd_file_put_noref(nf);
-	if (is_hashed)
+	if (!is_hashed) {
+		nfsd_file_flush(nf);
+		nfsd_file_put_noref(nf);
+	} else {
+		nfsd_file_put_noref(nf);
 		nfsd_file_schedule_laundrette();
+	}
 	if (atomic_long_read(&nfsd_filecache_count) >= NFSD_FILE_LRU_LIMIT)
 		nfsd_file_gc();
 }
@@ -327,6 +337,7 @@ nfsd_file_dispose_list(struct list_head *dispose)
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
 		list_del(&nf->nf_lru);
+		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
 	}
 }
@@ -340,6 +351,7 @@ nfsd_file_dispose_list_sync(struct list_head *dispose)
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
 		list_del(&nf->nf_lru);
+		nfsd_file_flush(nf);
 		if (!refcount_dec_and_test(&nf->nf_ref))
 			continue;
 		if (nfsd_file_free(nf))
-- 
2.35.1



