Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD29759B3F8
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiHUNgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiHUNgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:36:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6F4220C2;
        Sun, 21 Aug 2022 06:35:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 784FBB80D18;
        Sun, 21 Aug 2022 13:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE5CC433C1;
        Sun, 21 Aug 2022 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661088952;
        bh=s+Uj4RbWXYFlTqqPOLbbbkxlRMf/EJFcseVnE7zKUTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLfNU6Ox8SykR7RkOm55WwLmTahYJzMSk0LeSErMZtQ+w3wzCfc4S3TDgr5EOs4WY
         wHpjZt71T8napLszrNKAg+g/PqzNaNfqQXTtGLqV1MIUYX54GMK+fw36Cdj947JRZu
         0I3DDJZO3TKD0j4MisJMPRKa4S4h1aqIr1SjK3Qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.62
Date:   Sun, 21 Aug 2022 15:35:37 +0200
Message-Id: <166108893745104@kroah.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <1661088936412@kroah.com>
References: <1661088936412@kroah.com>
MIME-Version: 1.0
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

diff --git a/Makefile b/Makefile
index 0802acf352d2..5b4f8f8851bf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 61
+SUBLEVEL = 62
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index ceab28277546..b3c9ef01d6c0 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -322,12 +322,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	unsigned long offset;
 	unsigned long npages;
 	unsigned long size;
-	unsigned long retq;
 	unsigned long *ptr;
 	void *trampoline;
 	void *ip;
 	/* 48 8b 15 <offset> is movq <offset>(%rip), %rdx */
 	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
+	unsigned const char retq[] = { RET_INSN_OPCODE, INT3_INSN_OPCODE };
 	union ftrace_op_code_union op_ptr;
 	int ret;
 
@@ -367,13 +367,10 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	ip = trampoline + size;
 
 	/* The trampoline ends with ret(q) */
-	retq = (unsigned long)ftrace_stub;
 	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
 		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
 	else
-		ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
-	if (WARN_ON(ret < 0))
-		goto fail;
+		memcpy(ip, retq, sizeof(retq));
 
 	/* No need to test direct calls on created trampolines */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index d6af81d1b788..6cc14a835991 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -181,7 +181,6 @@ SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL)
 
 /*
  * This is weak to keep gas from relaxing the jumps.
- * It is also used to copy the RET for trampolines.
  */
 SYM_INNER_LABEL_ALIGN(ftrace_stub, SYM_L_WEAK)
 	UNWIND_HINT_FUNC
@@ -335,7 +334,7 @@ SYM_FUNC_START(ftrace_graph_caller)
 SYM_FUNC_END(ftrace_graph_caller)
 
 SYM_FUNC_START(return_to_handler)
-	subq  $24, %rsp
+	subq  $16, %rsp
 
 	/* Save the return values */
 	movq %rax, (%rsp)
@@ -347,7 +346,19 @@ SYM_FUNC_START(return_to_handler)
 	movq %rax, %rdi
 	movq 8(%rsp), %rdx
 	movq (%rsp), %rax
-	addq $24, %rsp
-	JMP_NOSPEC rdi
+
+	addq $16, %rsp
+	/*
+	 * Jump back to the old return address. This cannot be JMP_NOSPEC rdi
+	 * since IBT would demand that contain ENDBR, which simply isn't so for
+	 * return addresses. Use a retpoline here to keep the RSB balanced.
+	 */
+	ANNOTATE_INTRA_FUNCTION_CALL
+	call .Ldo_rop
+	int3
+.Ldo_rop:
+	mov %rdi, (%rsp)
+	UNWIND_HINT_FUNC
+	RET
 SYM_FUNC_END(return_to_handler)
 #endif
diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 499fccba3d74..6e662fb131d5 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -222,6 +222,9 @@ struct tee_shm *tee_shm_register(struct tee_context *ctx, unsigned long addr,
 		goto err;
 	}
 
+	if (!access_ok((void __user *)addr, length))
+		return ERR_PTR(-EFAULT);
+
 	mutex_lock(&teedev->mutex);
 	shm->id = idr_alloc(&teedev->idr, shm, 1, 0, GFP_KERNEL);
 	mutex_unlock(&teedev->mutex);
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 893d93e3c516..3157a26ddf7e 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -324,6 +324,9 @@ static void merge_rbio(struct btrfs_raid_bio *dest,
 {
 	bio_list_merge(&dest->bio_list, &victim->bio_list);
 	dest->bio_list_bytes += victim->bio_list_bytes;
+	/* Also inherit the bitmaps from @victim. */
+	bitmap_or(dest->dbitmap, victim->dbitmap, dest->dbitmap,
+		  dest->stripe_npages);
 	dest->generic_bio_cnt += victim->generic_bio_cnt;
 	bio_list_init(&victim->bio_list);
 }
@@ -865,6 +868,12 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
 
 	if (rbio->generic_bio_cnt)
 		btrfs_bio_counter_sub(rbio->fs_info, rbio->generic_bio_cnt);
+	/*
+	 * Clear the data bitmap, as the rbio may be cached for later usage.
+	 * do this before before unlock_stripe() so there will be no new bio
+	 * for this bio.
+	 */
+	bitmap_clear(rbio->dbitmap, 0, rbio->stripe_npages);
 
 	/*
 	 * At this moment, rbio->bio_list is empty, however since rbio does not
@@ -1197,6 +1206,9 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	else
 		BUG();
 
+	/* We should have at least one data sector. */
+	ASSERT(bitmap_weight(rbio->dbitmap, rbio->stripe_npages));
+
 	/* at this point we either have a full stripe,
 	 * or we've read the full stripe from the drive.
 	 * recalculate the parity and write the new results.
@@ -1268,6 +1280,11 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
 		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
 			struct page *page;
+
+			/* This vertical stripe has no data, skip it. */
+			if (!test_bit(pagenr, rbio->dbitmap))
+				continue;
+
 			if (stripe < rbio->nr_data) {
 				page = page_in_rbio(rbio, stripe, pagenr, 1);
 				if (!page)
@@ -1292,6 +1309,11 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 
 		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
 			struct page *page;
+
+			/* This vertical stripe has no data, skip it. */
+			if (!test_bit(pagenr, rbio->dbitmap))
+				continue;
+
 			if (stripe < rbio->nr_data) {
 				page = page_in_rbio(rbio, stripe, pagenr, 1);
 				if (!page)
@@ -1715,6 +1737,33 @@ static void btrfs_raid_unplug(struct blk_plug_cb *cb, bool from_schedule)
 	run_plug(plug);
 }
 
+/* Add the original bio into rbio->bio_list, and update rbio::dbitmap. */
+static void rbio_add_bio(struct btrfs_raid_bio *rbio, struct bio *orig_bio)
+{
+	const struct btrfs_fs_info *fs_info = rbio->fs_info;
+	const u64 orig_logical = orig_bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	const u64 full_stripe_start = rbio->bioc->raid_map[0];
+	const u32 orig_len = orig_bio->bi_iter.bi_size;
+	const u32 sectorsize = fs_info->sectorsize;
+	u64 cur_logical;
+
+	ASSERT(orig_logical >= full_stripe_start &&
+	       orig_logical + orig_len <= full_stripe_start +
+	       rbio->nr_data * rbio->stripe_len);
+
+	bio_list_add(&rbio->bio_list, orig_bio);
+	rbio->bio_list_bytes += orig_bio->bi_iter.bi_size;
+
+	/* Update the dbitmap. */
+	for (cur_logical = orig_logical; cur_logical < orig_logical + orig_len;
+	     cur_logical += sectorsize) {
+		int bit = ((u32)(cur_logical - full_stripe_start) >>
+			   fs_info->sectorsize_bits) % rbio->stripe_npages;
+
+		set_bit(bit, rbio->dbitmap);
+	}
+}
+
 /*
  * our main entry point for writes from the rest of the FS.
  */
@@ -1731,9 +1780,8 @@ int raid56_parity_write(struct btrfs_fs_info *fs_info, struct bio *bio,
 		btrfs_put_bioc(bioc);
 		return PTR_ERR(rbio);
 	}
-	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 	rbio->operation = BTRFS_RBIO_WRITE;
+	rbio_add_bio(rbio, bio);
 
 	btrfs_bio_counter_inc_noblocked(fs_info);
 	rbio->generic_bio_cnt = 1;
@@ -2037,9 +2085,12 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 	atomic_set(&rbio->error, 0);
 
 	/*
-	 * read everything that hasn't failed.  Thanks to the
-	 * stripe cache, it is possible that some or all of these
-	 * pages are going to be uptodate.
+	 * Read everything that hasn't failed. However this time we will
+	 * not trust any cached sector.
+	 * As we may read out some stale data but higher layer is not reading
+	 * that stale part.
+	 *
+	 * So here we always re-read everything in recovery path.
 	 */
 	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
 		if (rbio->faila == stripe || rbio->failb == stripe) {
@@ -2048,16 +2099,6 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 		}
 
 		for (pagenr = 0; pagenr < rbio->stripe_npages; pagenr++) {
-			struct page *p;
-
-			/*
-			 * the rmw code may have already read this
-			 * page in
-			 */
-			p = rbio_stripe_page(rbio, stripe, pagenr);
-			if (PageUptodate(p))
-				continue;
-
 			ret = rbio_add_io_page(rbio, &bio_list,
 				       rbio_stripe_page(rbio, stripe, pagenr),
 				       stripe, pagenr, rbio->stripe_len);
@@ -2135,8 +2176,7 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
 	}
 
 	rbio->operation = BTRFS_RBIO_READ_REBUILD;
-	bio_list_add(&rbio->bio_list, bio);
-	rbio->bio_list_bytes = bio->bi_iter.bi_size;
+	rbio_add_bio(rbio, bio);
 
 	rbio->faila = find_logical_bio_stripe(rbio, bio);
 	if (rbio->faila == -1) {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0ce1587df432..89f24b54fe5e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1405,7 +1405,7 @@ static void io_req_track_inflight(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_INFLIGHT)) {
 		req->flags |= REQ_F_INFLIGHT;
-		atomic_inc(&current->io_uring->inflight_tracked);
+		atomic_inc(&req->task->io_uring->inflight_tracked);
 	}
 }
 
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 66b24b480ebf..b47be71be4c8 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -132,8 +132,11 @@ static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
 		*len = le16_to_cpu(((struct smb2_read_req *)hdr)->ReadChannelInfoLength);
 		break;
 	case SMB2_WRITE:
-		if (((struct smb2_write_req *)hdr)->DataOffset) {
-			*off = le16_to_cpu(((struct smb2_write_req *)hdr)->DataOffset);
+		if (((struct smb2_write_req *)hdr)->DataOffset ||
+		    ((struct smb2_write_req *)hdr)->Length) {
+			*off = max_t(unsigned int,
+				     le16_to_cpu(((struct smb2_write_req *)hdr)->DataOffset),
+				     offsetof(struct smb2_write_req, Buffer) - 4);
 			*len = le32_to_cpu(((struct smb2_write_req *)hdr)->Length);
 			break;
 		}
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 53f5db40b96e..28b5d20c8766 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -541,9 +541,10 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 		struct smb2_query_info_req *req;
 
 		req = work->request_buf;
-		if (req->InfoType == SMB2_O_INFO_FILE &&
-		    (req->FileInfoClass == FILE_FULL_EA_INFORMATION ||
-		     req->FileInfoClass == FILE_ALL_INFORMATION))
+		if ((req->InfoType == SMB2_O_INFO_FILE &&
+		     (req->FileInfoClass == FILE_FULL_EA_INFORMATION ||
+		      req->FileInfoClass == FILE_ALL_INFORMATION)) ||
+		    req->InfoType == SMB2_O_INFO_SECURITY)
 			sz = large_sz;
 	}
 
@@ -2981,7 +2982,7 @@ int smb2_open(struct ksmbd_work *work)
 						goto err_out;
 
 					rc = build_sec_desc(user_ns,
-							    pntsd, NULL,
+							    pntsd, NULL, 0,
 							    OWNER_SECINFO |
 							    GROUP_SECINFO |
 							    DACL_SECINFO,
@@ -3824,6 +3825,15 @@ static int verify_info_level(int info_level)
 	return 0;
 }
 
+static int smb2_resp_buf_len(struct ksmbd_work *work, unsigned short hdr2_len)
+{
+	int free_len;
+
+	free_len = (int)(work->response_sz -
+		(get_rfc1002_len(work->response_buf) + 4)) - hdr2_len;
+	return free_len;
+}
+
 static int smb2_calc_max_out_buf_len(struct ksmbd_work *work,
 				     unsigned short hdr2_len,
 				     unsigned int out_buf_len)
@@ -3833,9 +3843,7 @@ static int smb2_calc_max_out_buf_len(struct ksmbd_work *work,
 	if (out_buf_len > work->conn->vals->max_trans_size)
 		return -EINVAL;
 
-	free_len = (int)(work->response_sz -
-			 (get_rfc1002_len(work->response_buf) + 4)) -
-		hdr2_len;
+	free_len = smb2_resp_buf_len(work, hdr2_len);
 	if (free_len < 0)
 		return -EINVAL;
 
@@ -5087,10 +5095,10 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 	struct smb_ntsd *pntsd = (struct smb_ntsd *)rsp->Buffer, *ppntsd = NULL;
 	struct smb_fattr fattr = {{0}};
 	struct inode *inode;
-	__u32 secdesclen;
+	__u32 secdesclen = 0;
 	unsigned int id = KSMBD_NO_FID, pid = KSMBD_NO_FID;
 	int addition_info = le32_to_cpu(req->AdditionalInformation);
-	int rc;
+	int rc = 0, ppntsd_size = 0;
 
 	if (addition_info & ~(OWNER_SECINFO | GROUP_SECINFO | DACL_SECINFO |
 			      PROTECTED_DACL_SECINFO |
@@ -5136,11 +5144,14 @@ static int smb2_get_info_sec(struct ksmbd_work *work,
 
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_ACL_XATTR))
-		ksmbd_vfs_get_sd_xattr(work->conn, user_ns,
-				       fp->filp->f_path.dentry, &ppntsd);
-
-	rc = build_sec_desc(user_ns, pntsd, ppntsd, addition_info,
-			    &secdesclen, &fattr);
+		ppntsd_size = ksmbd_vfs_get_sd_xattr(work->conn, user_ns,
+						     fp->filp->f_path.dentry,
+						     &ppntsd);
+
+	/* Check if sd buffer size exceeds response buffer size */
+	if (smb2_resp_buf_len(work, 8) > ppntsd_size)
+		rc = build_sec_desc(user_ns, pntsd, ppntsd, ppntsd_size,
+				    addition_info, &secdesclen, &fattr);
 	posix_acl_release(fattr.cf_acls);
 	posix_acl_release(fattr.cf_dacls);
 	kfree(ppntsd);
@@ -6471,10 +6482,8 @@ int smb2_write(struct ksmbd_work *work)
 		    (offsetof(struct smb2_write_req, Buffer) - 4)) {
 			data_buf = (char *)&req->Buffer[0];
 		} else {
-			if ((u64)le16_to_cpu(req->DataOffset) + length > get_rfc1002_len(req)) {
-				pr_err("invalid write data offset %u, smb_len %u\n",
-				       le16_to_cpu(req->DataOffset),
-				       get_rfc1002_len(req));
+			if (le16_to_cpu(req->DataOffset) <
+			    offsetof(struct smb2_write_req, Buffer)) {
 				err = -EINVAL;
 				goto out;
 			}
diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 38f23bf981ac..3781bca2c8fc 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -690,6 +690,7 @@ static void set_posix_acl_entries_dacl(struct user_namespace *user_ns,
 static void set_ntacl_dacl(struct user_namespace *user_ns,
 			   struct smb_acl *pndacl,
 			   struct smb_acl *nt_dacl,
+			   unsigned int aces_size,
 			   const struct smb_sid *pownersid,
 			   const struct smb_sid *pgrpsid,
 			   struct smb_fattr *fattr)
@@ -703,9 +704,19 @@ static void set_ntacl_dacl(struct user_namespace *user_ns,
 	if (nt_num_aces) {
 		ntace = (struct smb_ace *)((char *)nt_dacl + sizeof(struct smb_acl));
 		for (i = 0; i < nt_num_aces; i++) {
-			memcpy((char *)pndace + size, ntace, le16_to_cpu(ntace->size));
-			size += le16_to_cpu(ntace->size);
-			ntace = (struct smb_ace *)((char *)ntace + le16_to_cpu(ntace->size));
+			unsigned short nt_ace_size;
+
+			if (offsetof(struct smb_ace, access_req) > aces_size)
+				break;
+
+			nt_ace_size = le16_to_cpu(ntace->size);
+			if (nt_ace_size > aces_size)
+				break;
+
+			memcpy((char *)pndace + size, ntace, nt_ace_size);
+			size += nt_ace_size;
+			aces_size -= nt_ace_size;
+			ntace = (struct smb_ace *)((char *)ntace + nt_ace_size);
 			num_aces++;
 		}
 	}
@@ -878,7 +889,7 @@ int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 /* Convert permission bits from mode to equivalent CIFS ACL */
 int build_sec_desc(struct user_namespace *user_ns,
 		   struct smb_ntsd *pntsd, struct smb_ntsd *ppntsd,
-		   int addition_info, __u32 *secdesclen,
+		   int ppntsd_size, int addition_info, __u32 *secdesclen,
 		   struct smb_fattr *fattr)
 {
 	int rc = 0;
@@ -938,15 +949,25 @@ int build_sec_desc(struct user_namespace *user_ns,
 
 		if (!ppntsd) {
 			set_mode_dacl(user_ns, dacl_ptr, fattr);
-		} else if (!ppntsd->dacloffset) {
-			goto out;
 		} else {
 			struct smb_acl *ppdacl_ptr;
+			unsigned int dacl_offset = le32_to_cpu(ppntsd->dacloffset);
+			int ppdacl_size, ntacl_size = ppntsd_size - dacl_offset;
+
+			if (!dacl_offset ||
+			    (dacl_offset + sizeof(struct smb_acl) > ppntsd_size))
+				goto out;
+
+			ppdacl_ptr = (struct smb_acl *)((char *)ppntsd + dacl_offset);
+			ppdacl_size = le16_to_cpu(ppdacl_ptr->size);
+			if (ppdacl_size > ntacl_size ||
+			    ppdacl_size < sizeof(struct smb_acl))
+				goto out;
 
-			ppdacl_ptr = (struct smb_acl *)((char *)ppntsd +
-						le32_to_cpu(ppntsd->dacloffset));
 			set_ntacl_dacl(user_ns, dacl_ptr, ppdacl_ptr,
-				       nowner_sid_ptr, ngroup_sid_ptr, fattr);
+				       ntacl_size - sizeof(struct smb_acl),
+				       nowner_sid_ptr, ngroup_sid_ptr,
+				       fattr);
 		}
 		pntsd->dacloffset = cpu_to_le32(offset);
 		offset += le16_to_cpu(dacl_ptr->size);
@@ -980,24 +1001,31 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	struct smb_sid owner_sid, group_sid;
 	struct dentry *parent = path->dentry->d_parent;
 	struct user_namespace *user_ns = mnt_user_ns(path->mnt);
-	int inherited_flags = 0, flags = 0, i, ace_cnt = 0, nt_size = 0;
-	int rc = 0, num_aces, dacloffset, pntsd_type, acl_len;
+	int inherited_flags = 0, flags = 0, i, ace_cnt = 0, nt_size = 0, pdacl_size;
+	int rc = 0, num_aces, dacloffset, pntsd_type, pntsd_size, acl_len, aces_size;
 	char *aces_base;
 	bool is_dir = S_ISDIR(d_inode(path->dentry)->i_mode);
 
-	acl_len = ksmbd_vfs_get_sd_xattr(conn, user_ns,
-					 parent, &parent_pntsd);
-	if (acl_len <= 0)
+	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, user_ns,
+					    parent, &parent_pntsd);
+	if (pntsd_size <= 0)
 		return -ENOENT;
 	dacloffset = le32_to_cpu(parent_pntsd->dacloffset);
-	if (!dacloffset) {
+	if (!dacloffset || (dacloffset + sizeof(struct smb_acl) > pntsd_size)) {
 		rc = -EINVAL;
 		goto free_parent_pntsd;
 	}
 
 	parent_pdacl = (struct smb_acl *)((char *)parent_pntsd + dacloffset);
+	acl_len = pntsd_size - dacloffset;
 	num_aces = le32_to_cpu(parent_pdacl->num_aces);
 	pntsd_type = le16_to_cpu(parent_pntsd->type);
+	pdacl_size = le16_to_cpu(parent_pdacl->size);
+
+	if (pdacl_size > acl_len || pdacl_size < sizeof(struct smb_acl)) {
+		rc = -EINVAL;
+		goto free_parent_pntsd;
+	}
 
 	aces_base = kmalloc(sizeof(struct smb_ace) * num_aces * 2, GFP_KERNEL);
 	if (!aces_base) {
@@ -1008,11 +1036,23 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 	aces = (struct smb_ace *)aces_base;
 	parent_aces = (struct smb_ace *)((char *)parent_pdacl +
 			sizeof(struct smb_acl));
+	aces_size = acl_len - sizeof(struct smb_acl);
 
 	if (pntsd_type & DACL_AUTO_INHERITED)
 		inherited_flags = INHERITED_ACE;
 
 	for (i = 0; i < num_aces; i++) {
+		int pace_size;
+
+		if (offsetof(struct smb_ace, access_req) > aces_size)
+			break;
+
+		pace_size = le16_to_cpu(parent_aces->size);
+		if (pace_size > aces_size)
+			break;
+
+		aces_size -= pace_size;
+
 		flags = parent_aces->flags;
 		if (!smb_inherit_flags(flags, is_dir))
 			goto pass;
@@ -1057,8 +1097,7 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
 		aces = (struct smb_ace *)((char *)aces + le16_to_cpu(aces->size));
 		ace_cnt++;
 pass:
-		parent_aces =
-			(struct smb_ace *)((char *)parent_aces + le16_to_cpu(parent_aces->size));
+		parent_aces = (struct smb_ace *)((char *)parent_aces + pace_size);
 	}
 
 	if (nt_size > 0) {
@@ -1153,7 +1192,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, struct path *path,
 	struct smb_ntsd *pntsd = NULL;
 	struct smb_acl *pdacl;
 	struct posix_acl *posix_acls;
-	int rc = 0, acl_size;
+	int rc = 0, pntsd_size, acl_size, aces_size, pdacl_size, dacl_offset;
 	struct smb_sid sid;
 	int granted = le32_to_cpu(*pdaccess & ~FILE_MAXIMAL_ACCESS_LE);
 	struct smb_ace *ace;
@@ -1162,37 +1201,33 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, struct path *path,
 	struct smb_ace *others_ace = NULL;
 	struct posix_acl_entry *pa_entry;
 	unsigned int sid_type = SIDOWNER;
-	char *end_of_acl;
+	unsigned short ace_size;
 
 	ksmbd_debug(SMB, "check permission using windows acl\n");
-	acl_size = ksmbd_vfs_get_sd_xattr(conn, user_ns,
-					  path->dentry, &pntsd);
-	if (acl_size <= 0 || !pntsd || !pntsd->dacloffset) {
-		kfree(pntsd);
-		return 0;
-	}
+	pntsd_size = ksmbd_vfs_get_sd_xattr(conn, user_ns,
+					    path->dentry, &pntsd);
+	if (pntsd_size <= 0 || !pntsd)
+		goto err_out;
+
+	dacl_offset = le32_to_cpu(pntsd->dacloffset);
+	if (!dacl_offset ||
+	    (dacl_offset + sizeof(struct smb_acl) > pntsd_size))
+		goto err_out;
 
 	pdacl = (struct smb_acl *)((char *)pntsd + le32_to_cpu(pntsd->dacloffset));
-	end_of_acl = ((char *)pntsd) + acl_size;
-	if (end_of_acl <= (char *)pdacl) {
-		kfree(pntsd);
-		return 0;
-	}
+	acl_size = pntsd_size - dacl_offset;
+	pdacl_size = le16_to_cpu(pdacl->size);
 
-	if (end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size) ||
-	    le16_to_cpu(pdacl->size) < sizeof(struct smb_acl)) {
-		kfree(pntsd);
-		return 0;
-	}
+	if (pdacl_size > acl_size || pdacl_size < sizeof(struct smb_acl))
+		goto err_out;
 
 	if (!pdacl->num_aces) {
-		if (!(le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) &&
+		if (!(pdacl_size - sizeof(struct smb_acl)) &&
 		    *pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)) {
 			rc = -EACCES;
 			goto err_out;
 		}
-		kfree(pntsd);
-		return 0;
+		goto err_out;
 	}
 
 	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
@@ -1200,11 +1235,16 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, struct path *path,
 			DELETE;
 
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
+		aces_size = acl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le32_to_cpu(pdacl->num_aces); i++) {
+			if (offsetof(struct smb_ace, access_req) > aces_size)
+				break;
+			ace_size = le16_to_cpu(ace->size);
+			if (ace_size > aces_size)
+				break;
+			aces_size -= ace_size;
 			granted |= le32_to_cpu(ace->access_req);
 			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
-			if (end_of_acl < (char *)ace)
-				goto err_out;
 		}
 
 		if (!pdacl->num_aces)
@@ -1216,7 +1256,15 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, struct path *path,
 	id_to_sid(uid, sid_type, &sid);
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
+	aces_size = acl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le32_to_cpu(pdacl->num_aces); i++) {
+		if (offsetof(struct smb_ace, access_req) > aces_size)
+			break;
+		ace_size = le16_to_cpu(ace->size);
+		if (ace_size > aces_size)
+			break;
+		aces_size -= ace_size;
+
 		if (!compare_sids(&sid, &ace->sid) ||
 		    !compare_sids(&sid_unix_NFS_mode, &ace->sid)) {
 			found = 1;
@@ -1226,8 +1274,6 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, struct path *path,
 			others_ace = ace;
 
 		ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
-		if (end_of_acl < (char *)ace)
-			goto err_out;
 	}
 
 	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE && found) {
diff --git a/fs/ksmbd/smbacl.h b/fs/ksmbd/smbacl.h
index 811af3309429..fcb2c83f2992 100644
--- a/fs/ksmbd/smbacl.h
+++ b/fs/ksmbd/smbacl.h
@@ -193,7 +193,7 @@ struct posix_acl_state {
 int parse_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
 		   int acl_len, struct smb_fattr *fattr);
 int build_sec_desc(struct user_namespace *user_ns, struct smb_ntsd *pntsd,
-		   struct smb_ntsd *ppntsd, int addition_info,
+		   struct smb_ntsd *ppntsd, int ppntsd_size, int addition_info,
 		   __u32 *secdesclen, struct smb_fattr *fattr);
 int init_acl_state(struct posix_acl_state *state, int cnt);
 void free_acl_state(struct posix_acl_state *state);
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 2139aa042c79..513989b1c8cd 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1543,6 +1543,11 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	}
 
 	*pntsd = acl.sd_buf;
+	if (acl.sd_size < sizeof(struct smb_ntsd)) {
+		pr_err("sd size is invalid\n");
+		goto out_free;
+	}
+
 	(*pntsd)->osidoffset = cpu_to_le32(le32_to_cpu((*pntsd)->osidoffset) -
 					   NDR_NTSD_OFFSETOF);
 	(*pntsd)->gsidoffset = cpu_to_le32(le32_to_cpu((*pntsd)->gsidoffset) -
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 3f935cbbaff6..48712bc51bda 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -424,6 +424,11 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 			return -EINVAL;
 	}
 
+	if (!nhandle) {
+		NL_SET_ERR_MSG(extack, "Replacing with handle of 0 is invalid");
+		return -EINVAL;
+	}
+
 	h1 = to_hash(nhandle);
 	b = rtnl_dereference(head->table[h1]);
 	if (!b) {
@@ -477,6 +482,11 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	int err;
 	bool new = true;
 
+	if (!handle) {
+		NL_SET_ERR_MSG(extack, "Creating with handle of 0 is invalid");
+		return -EINVAL;
+	}
+
 	if (opt == NULL)
 		return handle ? -EINVAL : 0;
 
