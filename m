Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C1A579C54
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbiGSMio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240990AbiGSMiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:38:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FB24BD11;
        Tue, 19 Jul 2022 05:14:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81115B81B08;
        Tue, 19 Jul 2022 12:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03D8C341C6;
        Tue, 19 Jul 2022 12:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232885;
        bh=aEI8Mf2hTpeqLGJUU72cYnxpvzGp2z0G5ABV6Ey3eJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqn9smOVQb7dcgmn2ovJuyKaTg8+QlFyWdm8RzTQSYUrhET9dyi5xbovpfywgHjex
         oHJTZ7+JzXZIBwZsGoXE3S/sZSZUVucI5AnduM+OsCXzxFW9UveA3D1P3F+VjpQf8c
         VThNJ/db/5GZQzMBNgxzOMg19qK86UD19WN+ylm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/167] ceph: switch netfs read ops to use rreq->inode instead of rreq->mapping->host
Date:   Tue, 19 Jul 2022 13:53:52 +0200
Message-Id: <20220719114706.114166733@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit a25cedb4313d35e1f2968105678a47ca28e84d3b ]

One fewer pointer dereference, and in the future we may not be able to
count on the mapping pointer being populated (e.g. in the DIO case).

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 99b80b5c7a93..b218a26291b8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -179,7 +179,7 @@ static int ceph_releasepage(struct page *page, gfp_t gfp)
 
 static void ceph_netfs_expand_readahead(struct netfs_read_request *rreq)
 {
-	struct inode *inode = rreq->mapping->host;
+	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_file_layout *lo = &ci->i_layout;
 	u32 blockoff;
@@ -196,7 +196,7 @@ static void ceph_netfs_expand_readahead(struct netfs_read_request *rreq)
 
 static bool ceph_netfs_clamp_length(struct netfs_read_subrequest *subreq)
 {
-	struct inode *inode = subreq->rreq->mapping->host;
+	struct inode *inode = subreq->rreq->inode;
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 objno, objoff;
@@ -242,7 +242,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 {
 	struct netfs_read_request *rreq = subreq->rreq;
-	struct inode *inode = rreq->mapping->host;
+	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req;
-- 
2.35.1



