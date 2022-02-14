Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245BA4B473A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244307AbiBNJhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244398AbiBNJfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:35:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FC2AE7E;
        Mon, 14 Feb 2022 01:33:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6759661113;
        Mon, 14 Feb 2022 09:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FC2C340E9;
        Mon, 14 Feb 2022 09:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831184;
        bh=Pj7iVm9wumsnEISLPdad7YpFuQ1JhNBS58i1zhLW9zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhkSTYYbS+NBRzrXpRllyKdwWjoTkA3mr0Q4lK2Yc6O6zGwWGvYWIfv4MUzCiQvWQ
         L9q5OzLHs1sZMGeEHVtRLQWVtfkE80a4252ik+oU/vDHvX91rK5//8jXR4qAWb51u3
         4VLrRNZ6cYKykl0EnLXbHkA4lrfek4Uixeeq+F8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.19 06/49] NFS: Fix initialisation of nfs_client cl_flags field
Date:   Mon, 14 Feb 2022 10:25:32 +0100
Message-Id: <20220214092448.507996176@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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
@@ -180,6 +180,7 @@ struct nfs_client *nfs_alloc_client(cons
 	INIT_LIST_HEAD(&clp->cl_superblocks);
 	clp->cl_rpcclient = ERR_PTR(-EINVAL);
 
+	clp->cl_flags = cl_init->init_flags;
 	clp->cl_proto = cl_init->proto;
 	clp->cl_net = get_net(cl_init->net);
 
@@ -427,7 +428,6 @@ struct nfs_client *nfs_get_client(const
 			list_add_tail(&new->cl_share_link,
 					&nn->nfs_client_list);
 			spin_unlock(&nn->nfs_client_lock);
-			new->cl_flags = cl_init->init_flags;
 			return rpc_ops->init_client(new, cl_init);
 		}
 


