Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364485B6FC7
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiIMOO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiIMOOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4B16111A;
        Tue, 13 Sep 2022 07:10:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D229F614AE;
        Tue, 13 Sep 2022 14:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFC5C433C1;
        Tue, 13 Sep 2022 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078234;
        bh=vxIJsfD1QQJZqFSp3yVKGXeoKphTwEQBO2rsy59mvac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJZ6Kt7sSnJHAnj68/YFXCLxqZ+jMtFOF2hKXFMVO2WYwxssDvMwNM3cyxaWWP8gD
         1pZc1BydrWGlm7C9JIWa54a7O/tG5C6hpsACB069rcqcX2piBL2oHU37t50SZU716L
         ucYhF2QhvvGmSS5GcTrjIGs3Nai/DYwA8B44TB4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Enzo Matsumiya <ematsumiya@suse.de>,
        Tom Talpey <tom@talpey.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 062/192] cifs: remove useless parameter is_fsctl from SMB2_ioctl()
Date:   Tue, 13 Sep 2022 16:02:48 +0200
Message-Id: <20220913140413.038083584@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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
index f5dcc4940b6da..9dfd2dd612c25 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -61,7 +61,6 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		nr_ioctl_req.Reserved = 0;
 		rc = SMB2_ioctl(xid, oparms->tcon, fid->persistent_fid,
 			fid->volatile_fid, FSCTL_LMR_REQUEST_RESILIENCY,
-			true /* is_fsctl */,
 			(char *)&nr_ioctl_req, sizeof(nr_ioctl_req),
 			CIFSMaxBufSize, NULL, NULL /* no return info */);
 		if (rc == -EOPNOTSUPP) {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3898ec2632dc4..33357846a01b1 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -680,7 +680,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
 	struct cifs_ses *ses = tcon->ses;
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
-			FSCTL_QUERY_NETWORK_INTERFACE_INFO, true /* is_fsctl */,
+			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
 			NULL /* no data input */, 0 /* no data input */,
 			CIFSMaxBufSize, (char **)&out_buf, &ret_data_len);
 	if (rc == -EOPNOTSUPP) {
@@ -1609,9 +1609,8 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
 	struct resume_key_req *res_key;
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
-			FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
-			NULL, 0 /* no input */, CIFSMaxBufSize,
-			(char **)&res_key, &ret_data_len);
+			FSCTL_SRV_REQUEST_RESUME_KEY, NULL, 0 /* no input */,
+			CIFSMaxBufSize, (char **)&res_key, &ret_data_len);
 
 	if (rc == -EOPNOTSUPP) {
 		pr_warn_once("Server share %s does not support copy range\n", tcon->treeName);
@@ -1753,7 +1752,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 		rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
 
 		rc = SMB2_ioctl_init(tcon, server, &rqst[1], COMPOUND_FID, COMPOUND_FID,
-				     qi.info_type, true, buffer, qi.output_buffer_length,
+				     qi.info_type, buffer, qi.output_buffer_length,
 				     CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
 				     MAX_SMB2_CLOSE_RESPONSE_SIZE);
 		free_req1_func = SMB2_ioctl_free;
@@ -1929,9 +1928,8 @@ smb2_copychunk_range(const unsigned int xid,
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
@@ -2091,7 +2089,6 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
-			true /* is_fctl */,
 			&setsparse, 1, CIFSMaxBufSize, NULL, NULL);
 	if (rc) {
 		tcon->broken_sparse_sup = true;
@@ -2174,7 +2171,6 @@ smb2_duplicate_extents(const unsigned int xid,
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
 			FSCTL_DUPLICATE_EXTENTS_TO_FILE,
-			true /* is_fsctl */,
 			(char *)&dup_ext_buf,
 			sizeof(struct duplicate_extents_to_file),
 			CIFSMaxBufSize, NULL,
@@ -2209,7 +2205,6 @@ smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
 	return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
 			FSCTL_SET_INTEGRITY_INFORMATION,
-			true /* is_fsctl */,
 			(char *)&integr_info,
 			sizeof(struct fsctl_set_integrity_information_req),
 			CIFSMaxBufSize, NULL,
@@ -2262,7 +2257,6 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
 			FSCTL_SRV_ENUMERATE_SNAPSHOTS,
-			true /* is_fsctl */,
 			NULL, 0 /* no input data */, max_response_size,
 			(char **)&retbuf,
 			&ret_data_len);
@@ -2982,7 +2976,6 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 	do {
 		rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 				FSCTL_DFS_GET_REFERRALS,
-				true /* is_fsctl */,
 				(char *)dfs_req, dfs_req_size, CIFSMaxBufSize,
 				(char **)&dfs_rsp, &dfs_rsp_size);
 		if (!is_retryable_error(rc))
@@ -3189,8 +3182,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst[1], fid.persistent_fid,
-			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
-			     true /* is_fctl */, NULL, 0,
+			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT, NULL, 0,
 			     CIFSMaxBufSize -
 			     MAX_SMB2_CREATE_RESPONSE_SIZE -
 			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
@@ -3370,8 +3362,7 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst[1], COMPOUND_FID,
-			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT,
-			     true /* is_fctl */, NULL, 0,
+			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT, NULL, 0,
 			     CIFSMaxBufSize -
 			     MAX_SMB2_CREATE_RESPONSE_SIZE -
 			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
@@ -3641,7 +3632,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
-			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, true,
+			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
 			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			0, NULL, NULL);
@@ -3702,7 +3693,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
-			true /* is_fctl */, (char *)&fsctl_buf,
+			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
 	filemap_invalidate_unlock(inode->i_mapping);
@@ -3764,7 +3755,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
-			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			FSCTL_QUERY_ALLOCATED_RANGES,
 			(char *)&in_data, sizeof(in_data),
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
@@ -4085,7 +4076,7 @@ static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offs
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
-			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			FSCTL_QUERY_ALLOCATED_RANGES,
 			(char *)&in_data, sizeof(in_data),
 			sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
@@ -4145,7 +4136,7 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid,
-			FSCTL_QUERY_ALLOCATED_RANGES, true,
+			FSCTL_QUERY_ALLOCATED_RANGES,
 			(char *)&in_data, sizeof(in_data),
 			1024 * sizeof(struct file_allocated_range_buffer),
 			(char **)&out_data, &out_data_len);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ba58d7fd54f9e..31d37afae741f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1174,7 +1174,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	}
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
-		FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
+		FSCTL_VALIDATE_NEGOTIATE_INFO,
 		(char *)pneg_inbuf, inbuflen, CIFSMaxBufSize,
 		(char **)&pneg_rsp, &rsplen);
 	if (rc == -EOPNOTSUPP) {
@@ -3053,7 +3053,7 @@ int
 SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		struct smb_rqst *rqst,
 		u64 persistent_fid, u64 volatile_fid, u32 opcode,
-		bool is_fsctl, char *in_data, u32 indatalen,
+		char *in_data, u32 indatalen,
 		__u32 max_response_size)
 {
 	struct smb2_ioctl_req *req;
@@ -3128,10 +3128,8 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	req->hdr.CreditCharge =
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
@@ -3158,9 +3156,9 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
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
@@ -3202,7 +3200,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 
 	rc = SMB2_ioctl_init(tcon, server,
 			     &rqst, persistent_fid, volatile_fid, opcode,
-			     is_fsctl, in_data, indatalen, max_out_data_len);
+			     in_data, indatalen, max_out_data_len);
 	if (rc)
 		goto ioctl_exit;
 
@@ -3294,7 +3292,7 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 			cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
 
 	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
-			FSCTL_SET_COMPRESSION, true /* is_fsctl */,
+			FSCTL_SET_COMPRESSION,
 			(char *)&fsctl_input /* data input */,
 			2 /* in data len */, CIFSMaxBufSize /* max out data */,
 			&ret_data /* out data */, NULL);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index a69f1eed1cfe5..d57d7202dc367 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -147,13 +147,13 @@ extern int SMB2_open_init(struct cifs_tcon *tcon,
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



