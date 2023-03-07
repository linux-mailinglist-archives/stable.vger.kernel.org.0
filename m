Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 520E76AF15A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbjCGSmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjCGSmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:42:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD30B371E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DECC6154A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D703C433D2;
        Tue,  7 Mar 2023 18:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213959;
        bh=WxYwa2Cc30nYji1sh4OZhymFEFDeZ8K9EQ836M/pyes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fo9GDKxsSOTs94wYkjQoMbPHqnu8MGUNMVDOfouT+G0anAxTy0epAewlNDfii+X8F
         dd4CebsM9FW1XxCY/8IuWzQkAEmLxKX8cVmkc2Cv1iZhPBQmD6S4Ifu1ZTtVOsIAFM
         02C5yzO1lLeJFk6MmIGYl6uWDIZkZ6V/zkJfO0oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronnie Sahlberg <lsahlber@redhat.com>,
        Bharath SM <bharathsm@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 676/885] cifs: Check the lease context if we actually got a lease
Date:   Tue,  7 Mar 2023 18:00:10 +0100
Message-Id: <20230307170031.503938135@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 66d45ca1350a3bb8d5f4db8879ccad3ed492337a upstream.

Some servers may return that we got a lease in rsp->OplockLevel
but then in the lease context contradict this and say we got no lease
at all.  Thus we need to check the context if we have a lease.
Additionally, If we do not get a lease we need to make sure we close
the handle before we return an error to the caller.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cached_dir.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -221,8 +221,7 @@ int open_cached_dir(unsigned int xid, st
 		}
 		goto oshr_free;
 	}
-
-	atomic_inc(&tcon->num_remote_opens);
+	cfid->is_open = true;
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
@@ -239,7 +238,8 @@ int open_cached_dir(unsigned int xid, st
 			    &oparms.fid->epoch,
 			    oparms.fid->lease_key, &oplock,
 			    NULL, NULL);
-
+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
+		goto oshr_free;
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
 		goto oshr_free;
@@ -262,7 +262,6 @@ int open_cached_dir(unsigned int xid, st
 	cfid->dentry = dentry;
 	cfid->tcon = tcon;
 	cfid->time = jiffies;
-	cfid->is_open = true;
 	cfid->has_lease = true;
 
 oshr_free:
@@ -282,12 +281,17 @@ oshr_free:
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	if (rc) {
+		if (cfid->is_open)
+			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
+				   cfid->fid.volatile_fid);
 		free_cached_dir(cfid);
 		cfid = NULL;
 	}
 
-	if (rc == 0)
+	if (rc == 0) {
 		*ret_cfid = cfid;
+		atomic_inc(&tcon->num_remote_opens);
+	}
 
 	return rc;
 }


