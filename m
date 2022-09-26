Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E525EA162
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbiIZKup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236728AbiIZKtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD7C5788F;
        Mon, 26 Sep 2022 03:26:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E48C60C05;
        Mon, 26 Sep 2022 10:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291C1C433C1;
        Mon, 26 Sep 2022 10:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187988;
        bh=TYkAw3ddzhpkb5703Ow+vuHz71S7/pXKULuF/8cdCsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oh+0a8kZReiv28ijsHSiPUtADvVBad8JFb5QARVfZqHCYYAXcpETW102607BuXmgh
         O0z+D6mY7q2NpHVEbHQdDdfgogjnmviiitlWSgKNrOQTGhBXcTf2PdSX4iQmsFnBeP
         Ikq4d+r74/QI9iqS71DNBtskv5RR0Il3dmCb15/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 110/120] xfs: convert EIO to EFSCORRUPTED when log contents are invalid
Date:   Mon, 26 Sep 2022 12:12:23 +0200
Message-Id: <20220926100754.964029305@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 895e196fb6f84402dcd0c1d3c3feb8a58049564e upstream.

Convert EIO to EFSCORRUPTED in the logging code when we can determine
that the log contents are invalid.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_item.c     |    4 ++--
 fs/xfs/xfs_extfree_item.c  |    2 +-
 fs/xfs/xfs_log_recover.c   |   32 ++++++++++++++++----------------
 fs/xfs/xfs_refcount_item.c |    2 +-
 fs/xfs/xfs_rmap_item.c     |    2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -456,7 +456,7 @@ xfs_bui_recover(
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -490,7 +490,7 @@ xfs_bui_recover(
 		 */
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -624,7 +624,7 @@ xfs_efi_recover(
 			 */
 			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 			xfs_efi_release(efip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -471,7 +471,7 @@ xlog_find_verify_log_record(
 			xfs_warn(log->l_mp,
 		"Log inconsistent (didn't find previous header)");
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out;
 		}
 
@@ -1350,7 +1350,7 @@ xlog_find_tail(
 		return error;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -3166,7 +3166,7 @@ xlog_recover_inode_pass2(
 		default:
 			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out_release;
 		}
 	}
@@ -3247,12 +3247,12 @@ xlog_recover_dquot_pass2(
 	recddq = item->ri_buf[1].i_addr;
 	if (recddq == NULL) {
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -3279,7 +3279,7 @@ xlog_recover_dquot_pass2(
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	ASSERT(dq_f->qlf_len == 1);
 
@@ -4018,7 +4018,7 @@ xlog_recover_commit_pass1(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4066,7 +4066,7 @@ xlog_recover_commit_pass2(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4187,7 +4187,7 @@ xlog_recover_add_to_cont_trans(
 		ASSERT(len <= sizeof(struct xfs_trans_header));
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		xlog_recover_add_item(&trans->r_itemq);
@@ -4243,13 +4243,13 @@ xlog_recover_add_to_trans(
 			xfs_warn(log->l_mp, "%s: bad header magic number",
 				__func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		/*
@@ -4285,7 +4285,7 @@ xlog_recover_add_to_trans(
 				  in_f->ilf_size);
 			ASSERT(0);
 			kmem_free(ptr);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		item->ri_total = in_f->ilf_size;
@@ -4389,7 +4389,7 @@ xlog_recovery_process_trans(
 	default:
 		xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
 		ASSERT(0);
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		break;
 	}
 	if (error || freeit)
@@ -4469,7 +4469,7 @@ xlog_recover_process_ophdr(
 		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 			__func__, ohead->oh_clientid);
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -4479,7 +4479,7 @@ xlog_recover_process_ophdr(
 	if (dp + len > end) {
 		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
 		WARN_ON(1);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
@@ -5209,7 +5209,7 @@ xlog_valid_rec_header(
 	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
 		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
 			__func__, be32_to_cpu(rhead->h_version));
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/* LR body must have data or it wouldn't have been written */
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -497,7 +497,7 @@ xfs_cui_recover(
 			 */
 			set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
 			xfs_cui_release(cuip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -539,7 +539,7 @@ xfs_rui_recover(
 			 */
 			set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
 			xfs_rui_release(ruip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 


