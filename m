Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E4E4B496B
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345019AbiBNKIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:08:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344617AbiBNKEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:04:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8DF4BFDF;
        Mon, 14 Feb 2022 01:49:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC8D861284;
        Mon, 14 Feb 2022 09:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5490C340E9;
        Mon, 14 Feb 2022 09:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832152;
        bh=LDr9fet3QinOPzrvjIlFRpO51oUaf2hH9I6poxqYFRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdtHBmV5fE8HGwnlxGV0RkVGCn6nIHn3KlTjS/PZAt6FOG7K5/q+IaazBld0DRyM0
         6LKVOJmusYV5DqhZwXlar7n/REEC5LjGfhvd5BqAP6DKSnVs6Tw/Fw6K7HuhznCFKx
         1JD1s2yCP4w/NAAGXzn7bMxFLWZgDQtbN4EN0T8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/172] NFS: Dont overfill uncached readdir pages
Date:   Mon, 14 Feb 2022 10:25:52 +0100
Message-Id: <20220214092509.650004231@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: trondmy@kernel.org <trondmy@kernel.org>

[ Upstream commit d9c4e39c1f8f8a8ebaccf00b8f22c14364b2d27e ]

If we're doing an uncached read of the directory, then we ideally want
to read only the exact set of entries that will fit in the buffer
supplied by the getdents() system call. So unlike the case where we're
reading into the page cache, let's send only one READDIR call, before
trying to fill up the buffer.

Fixes: 35df59d3ef69 ("NFS: Reduce number of RPC calls when doing uncached readdir")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index db6abd4733bfb..af7881bc6b3e6 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -870,7 +870,8 @@ static int nfs_readdir_xdr_to_array(struct nfs_readdir_descriptor *desc,
 
 		status = nfs_readdir_page_filler(desc, entry, pages, pglen,
 						 arrays, narrays);
-	} while (!status && nfs_readdir_page_needs_filling(page));
+	} while (!status && nfs_readdir_page_needs_filling(page) &&
+		page_mapping(page));
 
 	nfs_readdir_free_pages(pages, array_size);
 out_release_label:
-- 
2.34.1



