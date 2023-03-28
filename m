Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46026CC46F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbjC1PFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbjC1PFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:05:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D862DE3AE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:03:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBE9DB81D88
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C298C433D2;
        Tue, 28 Mar 2023 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015806;
        bh=ySZiMr2m7vHPxr3G2zJQyoDP696CHpPuJZD/IYFhEVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPw0z7RgwpVeEfXWljju02VZQJLTls63Mr2Tl8IEHMCmEvlEgKjXkPHhAo7wn54pF
         VNNWwS2LleUx+VGauudI7d3LI6HdOe6kGUMBNM2EPmhVz/bq09Vtp5s5UbwSwuyXKO
         OAe5/FBojjSZVzOdNpAgz0kFKi/NNX3Cztsk1zN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 151/224] cifs: append path to open_enter trace event
Date:   Tue, 28 Mar 2023 16:42:27 +0200
Message-Id: <20230328142623.671228086@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit fddc6ccc487e5de07b98df8d04118d5dcb5e0407 upstream.

We do not dump the file path for smb3_open_enter ftrace
calls, which is a severe handicap while debugging
using ftrace evens. This change adds that info.

Unfortunately, we're not updating the path in open params
in many places; which I had to do as a part of this change.
SMB2_open gets path in utf16 format, but it's easier of
path is supplied as char pointer in oparms.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cached_dir.c |    1 +
 fs/cifs/link.c       |    2 ++
 fs/cifs/smb2inode.c  |    1 +
 fs/cifs/smb2ops.c    |   11 +++++++++++
 fs/cifs/smb2pdu.c    |    4 ++--
 fs/cifs/trace.h      |   12 ++++++++----
 6 files changed, 25 insertions(+), 6 deletions(-)

--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -184,6 +184,7 @@ int open_cached_dir(unsigned int xid, st
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -360,6 +360,7 @@ smb3_query_mf_symlink(unsigned int xid,
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
+		.path = path,
 		.desired_access = GENERIC_READ,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
 		.disposition = FILE_OPEN,
@@ -427,6 +428,7 @@ smb3_create_mf_symlink(unsigned int xid,
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
+		.path = path,
 		.desired_access = GENERIC_WRITE,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
 		.disposition = FILE_CREATE,
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -106,6 +106,7 @@ static int smb2_compound_op(const unsign
 
 	vars->oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = full_path,
 		.desired_access = desired_access,
 		.disposition = create_disposition,
 		.create_options = cifs_create_options(cifs_sb, create_options),
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -731,6 +731,7 @@ smb3_qfs_tcon(const unsigned int xid, st
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = "",
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -774,6 +775,7 @@ smb2_qfs_tcon(const unsigned int xid, st
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = "",
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -821,6 +823,7 @@ smb2_is_path_accessible(const unsigned i
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = full_path,
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -1105,6 +1108,7 @@ smb2_set_ea(const unsigned int xid, stru
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = FILE_WRITE_EA,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2096,6 +2100,7 @@ smb3_notify(const unsigned int xid, stru
 	tcon = cifs_sb_master_tcon(cifs_sb);
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2168,6 +2173,7 @@ smb2_query_dir_first(const unsigned int
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2500,6 +2506,7 @@ smb2_query_info_compound(const unsigned
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = desired_access,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2634,6 +2641,7 @@ smb311_queryfs(const unsigned int xid, s
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = "",
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
@@ -2928,6 +2936,7 @@ smb2_query_symlink(const unsigned int xi
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = full_path,
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, create_options),
@@ -3068,6 +3077,7 @@ smb2_query_reparse_tag(const unsigned in
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = full_path,
 		.desired_access = FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, OPEN_REPARSE_POINT),
@@ -3208,6 +3218,7 @@ get_smb2_acl_by_path(struct cifs_sb_info
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
+		.path = path,
 		.desired_access = READ_CONTROL,
 		.disposition = FILE_OPEN,
 		/*
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2742,7 +2742,7 @@ int smb311_posix_mkdir(const unsigned in
 	rqst.rq_nvec = n_iov;
 
 	/* no need to inc num_remote_opens because we close it just below */
-	trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, CREATE_NOT_FILE,
+	trace_smb3_posix_mkdir_enter(xid, tcon->tid, ses->Suid, full_path, CREATE_NOT_FILE,
 				    FILE_WRITE_ATTRIBUTES);
 	/* resource #4: response buffer */
 	rc = cifs_send_recv(xid, ses, server,
@@ -3010,7 +3010,7 @@ SMB2_open(const unsigned int xid, struct
 	if (rc)
 		goto creat_exit;
 
-	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid,
+	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid, oparms->path,
 		oparms->create_options, oparms->desired_access);
 
 	rc = cifs_send_recv(xid, ses, server,
--- a/fs/cifs/trace.h
+++ b/fs/cifs/trace.h
@@ -701,13 +701,15 @@ DECLARE_EVENT_CLASS(smb3_open_enter_clas
 	TP_PROTO(unsigned int xid,
 		__u32	tid,
 		__u64	sesid,
+		const char *full_path,
 		int	create_options,
 		int	desired_access),
-	TP_ARGS(xid, tid, sesid, create_options, desired_access),
+	TP_ARGS(xid, tid, sesid, full_path, create_options, desired_access),
 	TP_STRUCT__entry(
 		__field(unsigned int, xid)
 		__field(__u32, tid)
 		__field(__u64, sesid)
+		__string(path, full_path)
 		__field(int, create_options)
 		__field(int, desired_access)
 	),
@@ -715,11 +717,12 @@ DECLARE_EVENT_CLASS(smb3_open_enter_clas
 		__entry->xid = xid;
 		__entry->tid = tid;
 		__entry->sesid = sesid;
+		__assign_str(path, full_path);
 		__entry->create_options = create_options;
 		__entry->desired_access = desired_access;
 	),
-	TP_printk("xid=%u sid=0x%llx tid=0x%x cr_opts=0x%x des_access=0x%x",
-		__entry->xid, __entry->sesid, __entry->tid,
+	TP_printk("xid=%u sid=0x%llx tid=0x%x path=%s cr_opts=0x%x des_access=0x%x",
+		__entry->xid, __entry->sesid, __entry->tid, __get_str(path),
 		__entry->create_options, __entry->desired_access)
 )
 
@@ -728,9 +731,10 @@ DEFINE_EVENT(smb3_open_enter_class, smb3
 	TP_PROTO(unsigned int xid,		\
 		__u32	tid,			\
 		__u64	sesid,			\
+		const char *full_path,		\
 		int	create_options,		\
 		int	desired_access),	\
-	TP_ARGS(xid, tid, sesid, create_options, desired_access))
+	TP_ARGS(xid, tid, sesid, full_path, create_options, desired_access))
 
 DEFINE_SMB3_OPEN_ENTER_EVENT(open_enter);
 DEFINE_SMB3_OPEN_ENTER_EVENT(posix_mkdir_enter);


