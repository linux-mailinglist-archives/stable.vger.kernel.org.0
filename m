Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DAE6AF179
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCGSo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjCGSoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:44:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD58B421D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:34:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2831361559
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372BCC433D2;
        Tue,  7 Mar 2023 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213962;
        bh=V85SEr6Ec7BXA7mqt65Urq4W5Pj0GKvaHF6qJSUhH3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqJi3xUQbYXffaqAwWTKe4obBxRfPb5QnQL+kUZn0zNhhk6Z1gtlXv6gz5qxNRLtQ
         zu8MGx8Sp4XsQ+sCtlao4l8QSVXLYh29PHjBvjE9GT2XQ2WB5tVdDYew9W++yMmDJj
         C+DkeEEX04FpaVhTLxImgjnSb3ZW76W48FQMewUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronnie Sahlberg <lsahlber@redhat.com>,
        Bharath SM <bharathsm@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 677/885] cifs: return a single-use cfid if we did not get a lease
Date:   Tue,  7 Mar 2023 18:00:11 +0100
Message-Id: <20230307170031.544275034@linuxfoundation.org>
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

commit 8e843bf38f7be0766642a91523cfa65f2b021a8a upstream.

If we did not get a lease we can still return a single use cfid to the caller.
The cfid will not have has_lease set and will thus not be shared with any
other concurrent users and will be freed immediately when the caller
drops the handle.

This avoids extra roundtrips for servers that do not support directory leases
where they would first fail to get a cfid with a lease and then fallback
to try a normal SMB2_open()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cached_dir.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -14,6 +14,7 @@
 
 static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
+static void smb2_close_cached_fid(struct kref *ref);
 
 static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 						    const char *path,
@@ -221,6 +222,7 @@ int open_cached_dir(unsigned int xid, st
 		}
 		goto oshr_free;
 	}
+	cfid->tcon = tcon;
 	cfid->is_open = true;
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
@@ -233,7 +235,6 @@ int open_cached_dir(unsigned int xid, st
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
 		goto oshr_free;
 
-
 	smb2_parse_contexts(server, o_rsp,
 			    &oparms.fid->epoch,
 			    oparms.fid->lease_key, &oplock,
@@ -260,7 +261,6 @@ int open_cached_dir(unsigned int xid, st
 		}
 	}
 	cfid->dentry = dentry;
-	cfid->tcon = tcon;
 	cfid->time = jiffies;
 	cfid->has_lease = true;
 
@@ -271,7 +271,7 @@ oshr_free:
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	spin_lock(&cfids->cfid_list_lock);
-	if (!cfid->has_lease) {
+	if (rc && !cfid->has_lease) {
 		if (cfid->on_list) {
 			list_del(&cfid->entry);
 			cfid->on_list = false;
@@ -280,6 +280,15 @@ oshr_free:
 		rc = -ENOENT;
 	}
 	spin_unlock(&cfids->cfid_list_lock);
+	if (!rc && !cfid->has_lease) {
+		/*
+		 * We are guaranteed to have two references at this point.
+		 * One for the caller and one for a potential lease.
+		 * Release the Lease-ref so that the directory will be closed
+		 * when the caller closes the cached handle.
+		 */
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
+	}
 	if (rc) {
 		if (cfid->is_open)
 			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
@@ -340,6 +349,7 @@ smb2_close_cached_fid(struct kref *ref)
 	if (cfid->is_open) {
 		SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
 			   cfid->fid.volatile_fid);
+		atomic_dec(&cfid->tcon->num_remote_opens);
 	}
 
 	free_cached_dir(cfid);


