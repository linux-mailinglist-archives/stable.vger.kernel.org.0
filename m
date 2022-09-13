Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278745B723C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiIMOtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbiIMOsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:48:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434A43C14D;
        Tue, 13 Sep 2022 07:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18C30614B9;
        Tue, 13 Sep 2022 14:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBE6C433C1;
        Tue, 13 Sep 2022 14:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078977;
        bh=/PpnwnjJVSUV4+cN9sDteDUVvA5ejNPS6gpK+wLPc5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfeKfbK0yHA9dK3SPGPWKyasuUYissH5+AuZbcoewOrQtNHjXQg0D7jZuMGAtKx0K
         PqFUInvwyH4HLn3GTx/Gmd8dUIfdK3rg/9IT9B4+w+Aq4h2mRhUK6VHIlCx7jQvGEW
         622GbsIaGzyyoyN2JgDrZkMk5Ct1CkpAk/3yFGuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Enzo Matsumiya <ematsumiya@suse.de>,
        Tom Talpey <tom@talpey.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/79] cifs: remove useless parameter is_fsctl from SMB2_ioctl()
Date:   Tue, 13 Sep 2022 16:04:40 +0200
Message-Id: <20220913140351.991126004@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enzo Matsumiya <ematsumiya@suse.de>

[ Upstream commit 400d0ad63b190895e29f43bc75b1260111d3fd34 ]

SMB2_ioctl() is always called with is_fsctl = true, so doesn't make any
sense to have it at all.

Thus, always set SMB2_0_IOCTL_IS_FSCTL flag on the request.

Also, as per MS-SMB2 3.3.5.15 "Receiving an SMB2 IOCTL Request", servers
must fail the request if the request flags is zero anyway.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2file.c  |  1 -
 fs/cifs/smb2ops.c   | 35 +++++++++++++----------------------
 fs/cifs/smb2pdu.c   | 20 +++++++++-----------
 fs/cifs/smb2proto.h |  4 ++--
 4 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 2fa3ba354cc96..001c26daacbaa 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -74,7 +74,6 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		nr_ioctl_req.Reserved = 0;
 		rc = SMB2_ioctl(xid, oparms->tcon, fid->persistent_fid,
 			fid->volatile_fid, FSCTL_LMR_REQUEST_RESILIENCY,
-			true /* is_fsctl */,
 			(char *)&nr_ioctl_req, sizeof(nr_ioctl_req),
 			CIFSMaxBufSize, NULL, NULL /* no return info */);
 		if (rc == -EOPNOTSUPP) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b6d72e3c5ebad..0a20ae96fe243 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -587,7 +587,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
 	struct cifs_ses *ses = tcon->ses;
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
-			FSCTL_QUERY_NETWORK_INTERFACE_INFO, true /* is_fsctl */,
+			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
 			NULL /* no data input */, 0 /* no data input */,
 			CIFSMaxBufSize, (char **)&out_buf, &ret_data_len);
 	if (rc == -EOPNOTSUPP) {
@@ -1470,9 +1470,8 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 	struct resume_key_req *res_key;
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
-			FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
-			NULL, 0 /* no input */, CIFSMaxBufSize,
-			(char **)&res_key, &ret_data_len);
+			FSCTL_SRV_REQUEST_RESUME_KEY, NULL, 0 /* no input */,
+			CIFSMaxBufSize, (char **)&res_key, &ret_data_len);
 
 	if (rc) {
 		cifs_tcon_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
@@ -1611,7 +1610,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 		rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
 
 		rc = SMB2_ioctl_init(tcon, server, &rqst[1], COMPOUND_FID, COMPOUND_FID,
-				     qi.info_type, true, buffer, qi.output_buffer_length,
+				     qi.info_type, buffer, qi.output_buffer_length,
 				     CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
 				     MAX_SMB2_CLOSE_RESPONSE_SIZE);
 		free_req1_func = SMB2_ioctl_free;
@@ -1787,9 +1786,8 @@ smb2_copychunk_range(const unsigned int xid,
 		retbuf = NULL;
 		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
-			true /* is_fsctl */, (char *)pcchunk,
-			sizeof(struct copychunk_ioctl),	CIFSMaxBufSize,
-			(char **)&retbuf, &ret_data_len);
+			(char *)pcchunk, sizeof(struct copychunk_ioctl),
+			CIFSMaxBufSize, (char **)&retbuf, &ret_data_len);
 		if (rc == 0) {
 			if (ret_data_len !=
 					sizeof(struct copychunk_ioctl_rsp)) {
@@ -1949,7 +1947,6 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
-			true /* is_fctl */,
 			&setsparse, 1, CIFSMaxBufSize, NULL, NULL);
 	if (rc) {
 		tcon->broken_sparse_sup = true;
@@ -2032,7 +2029,6 @@ smb2_duplicate_extents(const unsigned int xid,
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
 			FSCTL_DUPLICATE_EXTENTS_TO_FILE,
-			true /* is_fsctl */,
 			(char *)&dup_ext_buf,
 			sizeof(struct duplicate_extents_to_file),
 			CIFSMaxBufSize, NULL,
@@ -2067,7 +2063,6 @@ smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
 	return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
 			FSCTL_SET_INTEGRITY_INFORMATION,
-			true /* is_fsctl */,
 			(char *)&integr_info,
 			sizeof(struct fsctl_set_integrity_information_req),
 			CIFSMaxBufSize, NULL,
@@ -2120,7 +2115,6 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
 			FSCTL_SRV_ENUMERATE_SNAPSHOTS,
-			true /* is_fsctl */,
 			NULL, 0 /* no input data */, max_response_size,
 			(char **)&retbuf,
 			&ret_data_len);
@@ -2762,7 +2756,6 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	do {
 		rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 				FSCTL_DFS_GET_REFERRALS,
-				true /* is_fsctl */,
 				(char *)dfs_req, dfs_req_size, CIFSMaxBufSize,
 				(char **)&dfs_rsp, &dfs_rsp_size);
 	} while (rc == -EAGAIN);
@@ -2964,8 +2957,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst[1], fid.persistent_fid,
-			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
-			     true /* is_fctl */, NULL, 0,
+			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT, NULL, 0,
 			     CIFSMaxBufSize -
 			     MAX_SMB2_CREATE_RESPONSE_SIZE -
 			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
@@ -3145,8 +3137,7 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst[1], COMPOUND_FID,
-			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT,
-			     true /* is_fctl */, NULL, 0,
+			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT, NULL, 0,
 			     CIFSMaxBufSize -
 			     MAX_SMB2_CREATE_RESPONSE_SIZE -
 			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
@@ -3409,7 +3400,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
-			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, true,
+			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
 			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			0, NULL, NULL);
@@ -3471,7 +3462,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
-			true /* is_fctl */, (char *)&fsctl_buf,
+			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
 	free_xid(xid);
@@ -3530,7 +3521,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
-			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			FSCTL_QUERY_ALLOCATED_RANGES,
 			(char *)&in_data, sizeof(in_data),
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
@@ -3771,7 +3762,7 @@ static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offs
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
-			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			FSCTL_QUERY_ALLOCATED_RANGES,
 			(char *)&in_data, sizeof(in_data),
 			sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
@@ -3831,7 +3822,7 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
-			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			FSCTL_QUERY_ALLOCATED_RANGES,
 			(char *)&in_data, sizeof(in_data),
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 24dd711fa9b95..7ee8abd1f79be 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1081,7 +1081,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	}
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
-		FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
+		FSCTL_VALIDATE_NEGOTIATE_INFO,
 		(char *)pneg_inbuf, inbuflen, CIFSMaxBufSize,
 		(char **)&pneg_rsp, &rsplen);
 	if (rc == -EOPNOTSUPP) {
@@ -2922,7 +2922,7 @@ int
 SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		struct smb_rqst *rqst,
 		u64 persistent_fid, u64 volatile_fid, u32 opcode,
-		bool is_fsctl, char *in_data, u32 indatalen,
+		char *in_data, u32 indatalen,
 		__u32 max_response_size)
 {
 	struct smb2_ioctl_req *req;
@@ -2997,10 +2997,8 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	req->sync_hdr.CreditCharge =
 		cpu_to_le16(DIV_ROUND_UP(max(indatalen, max_response_size),
 					 SMB2_MAX_BUFFER_SIZE));
-	if (is_fsctl)
-		req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
-	else
-		req->Flags = 0;
+	/* always an FSCTL (for now) */
+	req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
 
 	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
 	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
@@ -3027,9 +3025,9 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
  */
 int
 SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
-	   u64 volatile_fid, u32 opcode, bool is_fsctl,
-	   char *in_data, u32 indatalen, u32 max_out_data_len,
-	   char **out_data, u32 *plen /* returned data len */)
+	   u64 volatile_fid, u32 opcode, char *in_data, u32 indatalen,
+	   u32 max_out_data_len, char **out_data,
+	   u32 *plen /* returned data len */)
 {
 	struct smb_rqst rqst;
 	struct smb2_ioctl_rsp *rsp = NULL;
@@ -3071,7 +3069,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst, persistent_fid, volatile_fid, opcode,
-			     is_fsctl, in_data, indatalen, max_out_data_len);
+			     in_data, indatalen, max_out_data_len);
 	if (rc)
 		goto ioctl_exit;
 
@@ -3153,7 +3151,7 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 			cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
-			FSCTL_SET_COMPRESSION, true /* is_fsctl */,
+			FSCTL_SET_COMPRESSION,
 			(char *)&fsctl_input /* data input */,
 			2 /* in data len */, CIFSMaxBufSize /* max out data */,
 			&ret_data /* out data */, NULL);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 4eb0ca84355a6..ed2b4fb012a41 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -155,13 +155,13 @@ extern int SMB2_open_init(struct cifs_tcon *tcon,
 extern void SMB2_open_free(struct smb_rqst *rqst);
 extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, u32 opcode,
-		     bool is_fsctl, char *in_data, u32 indatalen, u32 maxoutlen,
+		     char *in_data, u32 indatalen, u32 maxoutlen,
 		     char **out_data, u32 *plen /* returned data len */);
 extern int SMB2_ioctl_init(struct cifs_tcon *tcon,
 			   struct TCP_Server_Info *server,
 			   struct smb_rqst *rqst,
 			   u64 persistent_fid, u64 volatile_fid, u32 opcode,
-			   bool is_fsctl, char *in_data, u32 indatalen,
+			   char *in_data, u32 indatalen,
 			   __u32 max_response_size);
 extern void SMB2_ioctl_free(struct smb_rqst *rqst);
 extern int SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
-- 
2.35.1



