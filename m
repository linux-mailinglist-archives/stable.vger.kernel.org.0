Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55124B4B15
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346180AbiBNKR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347981AbiBNKRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:17:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A318CDA5;
        Mon, 14 Feb 2022 01:54:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B999B80DC4;
        Mon, 14 Feb 2022 09:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92146C340E9;
        Mon, 14 Feb 2022 09:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832436;
        bh=HgDS/vqrYnhvkyXDkH5OZTa9pHSx5ejvwP0/rYor4Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8wpV+UAAUWC2PGSlOcKfVvjqtV07hvmkXIe8dALe92A5EDdgPFsQ782dgdwF+My4
         8NNOILzHJ4dIoAPgwCYjyrcJg0ylOeEGwcW86OcucT49nJNMod0/liisdflH9se0bn
         2h60VTyOO3LpRZ1EGmqrygak5bg8efE2uVNw8SLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.16 014/203] NFS: Fix initialisation of nfs_client cl_flags field
Date:   Mon, 14 Feb 2022 10:24:18 +0100
Message-Id: <20220214092510.708862613@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 468d126dab45718feeb728319be20bd869a5eaa7 upstream.

For some long forgotten reason, the nfs_client cl_flags field is
initialised in nfs_get_client() instead of being initialised at
allocation time. This quirk was harmless until we moved the call to
nfs_create_rpc_client().

Fixes: dd99e9f98fbf ("NFSv4: Initialise connection to the server in nfs4_alloc_client()")
Cc: stable@vger.kernel.org # 4.8.x
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -177,6 +177,7 @@ struct nfs_client *nfs_alloc_client(cons
 	INIT_LIST_HEAD(&clp->cl_superblocks);
 	clp->cl_rpcclient = ERR_PTR(-EINVAL);
 
+	clp->cl_flags = cl_init->init_flags;
 	clp->cl_proto = cl_init->proto;
 	clp->cl_nconnect = cl_init->nconnect;
 	clp->cl_max_connect = cl_init->max_connect ? cl_init->max_connect : 1;
@@ -427,7 +428,6 @@ struct nfs_client *nfs_get_client(const
 			list_add_tail(&new->cl_share_link,
 					&nn->nfs_client_list);
 			spin_unlock(&nn->nfs_client_lock);
-			new->cl_flags = cl_init->init_flags;
 			return rpc_ops->init_client(new, cl_init);
 		}
 


