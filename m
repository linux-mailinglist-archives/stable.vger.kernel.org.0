Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D598548C3B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380028AbiFMN5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380951AbiFMNzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:55:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9751384A1F;
        Mon, 13 Jun 2022 04:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DFE4612A8;
        Mon, 13 Jun 2022 11:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5362CC34114;
        Mon, 13 Jun 2022 11:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120182;
        bh=GJNqqOKr0NBTjxoklh0NXy0vOn2yoYx8voMPjGc1T3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3m6Wl373YXO4Z16W1lZcf2PoCPqnbxpPkz0PmuYrRvim+foJHvRZD3BIwKiStTtK
         QNL5VV8w9RQmGkI/rlzemBe3e/M4R7uHAYdVyMJ+Q0cGKsdSR7d6U1TWyOZvfRanQF
         NvSBwF1ocPHtmQzQGoyn6cQAXFYmQ8iPCA4wdIEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 262/339] ceph: fix possible deadlock when holding Fwb to get inline_data
Date:   Mon, 13 Jun 2022 12:11:27 +0200
Message-Id: <20220613094934.597789562@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 825978fd6a0defc3c29d8a38b6cea76a0938d21e ]

1, mount with wsync.
2, create a file with O_RDWR, and the request was sent to mds.0:

   ceph_atomic_open()-->
     ceph_mdsc_do_request(openc)
     finish_open(file, dentry, ceph_open)-->
       ceph_open()-->
         ceph_init_file()-->
           ceph_init_file_info()-->
             ceph_uninline_data()-->
             {
               ...
               if (inline_version == 1 || /* initial version, no data */
                   inline_version == CEPH_INLINE_NONE)
                     goto out_unlock;
               ...
             }

The inline_version will be 1, which is the initial version for the
new create file. And here the ci->i_inline_version will keep with 1,
it's buggy.

3, buffer write to the file immediately:

   ceph_write_iter()-->
     ceph_get_caps(file, need=Fw, want=Fb, ...);
     generic_perform_write()-->
       a_ops->write_begin()-->
         ceph_write_begin()-->
           netfs_write_begin()-->
             netfs_begin_read()-->
               netfs_rreq_submit_slice()-->
                 netfs_read_from_server()-->
                   rreq->netfs_ops->issue_read()-->
                     ceph_netfs_issue_read()-->
                     {
                       ...
                       if (ci->i_inline_version != CEPH_INLINE_NONE &&
                           ceph_netfs_issue_op_inline(subreq))
                         return;
                       ...
                     }
     ceph_put_cap_refs(ci, Fwb);

The ceph_netfs_issue_op_inline() will send a getattr(Fsr) request to
mds.1.

4, then the mds.1 will request the rd lock for CInode::filelock from
the auth mds.0, the mds.0 will do the CInode::filelock state transation
from excl --> sync, but it need to revoke the Fxwb caps back from the
clients.

While the kernel client has aleady held the Fwb caps and waiting for
the getattr(Fsr).

It's deadlock!

URL: https://tracker.ceph.com/issues/55377
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index b6edcf89a429..adef10a6e5c7 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1644,7 +1644,7 @@ int ceph_uninline_data(struct file *file)
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_osd_request *req;
+	struct ceph_osd_request *req = NULL;
 	struct ceph_cap_flush *prealloc_cf;
 	struct folio *folio = NULL;
 	u64 inline_version = CEPH_INLINE_NONE;
@@ -1652,10 +1652,23 @@ int ceph_uninline_data(struct file *file)
 	int err = 0;
 	u64 len;
 
+	spin_lock(&ci->i_ceph_lock);
+	inline_version = ci->i_inline_version;
+	spin_unlock(&ci->i_ceph_lock);
+
+	dout("uninline_data %p %llx.%llx inline_version %llu\n",
+	     inode, ceph_vinop(inode), inline_version);
+
+	if (inline_version == CEPH_INLINE_NONE)
+		return 0;
+
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
 		return -ENOMEM;
 
+	if (inline_version == 1) /* initial version, no data */
+		goto out_uninline;
+
 	folio = read_mapping_folio(inode->i_mapping, 0, file);
 	if (IS_ERR(folio)) {
 		err = PTR_ERR(folio);
@@ -1664,17 +1677,6 @@ int ceph_uninline_data(struct file *file)
 
 	folio_lock(folio);
 
-	spin_lock(&ci->i_ceph_lock);
-	inline_version = ci->i_inline_version;
-	spin_unlock(&ci->i_ceph_lock);
-
-	dout("uninline_data %p %llx.%llx inline_version %llu\n",
-	     inode, ceph_vinop(inode), inline_version);
-
-	if (inline_version == 1 || /* initial version, no data */
-	    inline_version == CEPH_INLINE_NONE)
-		goto out_unlock;
-
 	len = i_size_read(inode);
 	if (len > folio_size(folio))
 		len = folio_size(folio);
@@ -1739,6 +1741,7 @@ int ceph_uninline_data(struct file *file)
 	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
 				  req->r_end_latency, len, err);
 
+out_uninline:
 	if (!err) {
 		int dirty;
 
@@ -1757,8 +1760,10 @@ int ceph_uninline_data(struct file *file)
 	if (err == -ECANCELED)
 		err = 0;
 out_unlock:
-	folio_unlock(folio);
-	folio_put(folio);
+	if (folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	}
 out:
 	ceph_free_cap_flush(prealloc_cf);
 	dout("uninline_data %p %llx.%llx inline_version %llu = %d\n",
-- 
2.35.1



