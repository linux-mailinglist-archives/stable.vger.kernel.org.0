Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00E04B469C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbiBNJen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:34:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243807AbiBNJec (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:34:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410FB67375;
        Mon, 14 Feb 2022 01:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EBC960DFD;
        Mon, 14 Feb 2022 09:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFE5C340E9;
        Mon, 14 Feb 2022 09:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831146;
        bh=QYHIR1qTK8qTBzRthT2D8u50eh/lkgFN+11DGVDpRAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUVOZ8PNruGicthfO6AI+7E9McUe0ivzD5vOVCbc0817B4Hniz2p6BpZUH+kSJXZ5
         hfL/yoUY1q+eoFJYmyNGW6cTivhYhI/ZAln7HCdgNfBcivvPDd7NJCSA0nVHTZBYhk
         pgA04yitMFrhVh82EEb/sZfd5OOij+vDPSRxa1dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/49] NFSv4 expose nfs_parse_server_name function
Date:   Mon, 14 Feb 2022 10:25:39 +0100
Message-Id: <20220214092448.739029245@linuxfoundation.org>
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

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit f5b27cc6761e27ee6387a24df1a99ca77b360fea ]

Make nfs_parse_server_name available outside of nfs4namespace.c.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4_fs.h       | 3 ++-
 fs/nfs/nfs4namespace.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 4dc9bd7ddf073..5ac7bf24c507b 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -276,7 +276,8 @@ struct vfsmount *nfs4_submount(struct nfs_server *, struct dentry *,
 			       struct nfs_fh *, struct nfs_fattr *);
 int nfs4_replace_transport(struct nfs_server *server,
 				const struct nfs4_fs_locations *locations);
-
+size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
+			     size_t salen, struct net *net);
 /* nfs4proc.c */
 extern int nfs4_handle_exception(struct nfs_server *, int, struct nfs4_exception *);
 extern int nfs4_async_handle_error(struct rpc_task *task,
diff --git a/fs/nfs/nfs4namespace.c b/fs/nfs/nfs4namespace.c
index 24f06dcc2b08e..936c412be28ef 100644
--- a/fs/nfs/nfs4namespace.c
+++ b/fs/nfs/nfs4namespace.c
@@ -121,8 +121,8 @@ static int nfs4_validate_fspath(struct dentry *dentry,
 	return 0;
 }
 
-static size_t nfs_parse_server_name(char *string, size_t len,
-		struct sockaddr *sa, size_t salen, struct net *net)
+size_t nfs_parse_server_name(char *string, size_t len, struct sockaddr *sa,
+			     size_t salen, struct net *net)
 {
 	ssize_t ret;
 
-- 
2.34.1



