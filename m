Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D406AEC1E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbjCGRwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjCGRwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:52:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFE7A5919
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:46:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FCABB819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6EDC433EF;
        Tue,  7 Mar 2023 17:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211178;
        bh=V85SEr6Ec7BXA7mqt65Urq4W5Pj0GKvaHF6qJSUhH3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AN7rg7mXKk2NsnvuAedHCG2OUGcCC3SvpES+eSasqCKnVGDrGb0jZ7fuxVZ9cyX5d
         AQ7JEBTdB/OfpR1BWmf881IGNxT8WtxIe67kwQaRQjDzHWToqu0mitalIeQsxOoJii
         CZdc842D8zAXX/ZFQ7uVzPHj/wCqmMlmKsqjs8cQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronnie Sahlberg <lsahlber@redhat.com>,
        Bharath SM <bharathsm@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 0778/1001] cifs: return a single-use cfid if we did not get a lease
Date:   Tue,  7 Mar 2023 17:59:10 +0100
Message-Id: <20230307170055.507544272@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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


