Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6658A58534C
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 18:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbiG2QQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 12:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiG2QQ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 12:16:26 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15F5FD29;
        Fri, 29 Jul 2022 09:16:25 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id f15so6417356edc.4;
        Fri, 29 Jul 2022 09:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=DwVNOCOzOWBWsWkVq3Pp0C4luk4q+7oCVEKGom5nqrI=;
        b=HrLVn/1rH5GtGe4tB661pUDXlRwCXh9Inm5URuZxUfq6v2E2fUoZVNE7e4odcgEEiA
         64sG4KQlq4N/a8vRtjeK0jrV4M67UQLI7rwpWWxYcjv0yyLvM9E3XJX6o63RjM6XSRUv
         iehACZzcFtuafq/6uNAwLfrFJ/gAiBb3TBM4DpqbCL8Z421nsEYKAkLJStndQpgGSmPH
         /ZECcZuSc3Gmr4mnWHzQv5Ze77+X1Dis3UWftEuE70W7cWu+OCUqMnp5YGgOzxDNnUJg
         asruLwEO3u7p10dOt0OgbBo/+yCGYsDHZ/0A8Fnt8O+YcFJrfNcl3tVwlO2zK2oezMy0
         MnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=DwVNOCOzOWBWsWkVq3Pp0C4luk4q+7oCVEKGom5nqrI=;
        b=byILFPVUJ1nqnFODtg5EVIw/GybzROMoz0Lz5d+xac3MJTxlIrQ4azJlflFZQ9PfpK
         5NJnYtKw+pviaVD45XaUiSMrQ/wJqGV7p9pfWrESKfeykQ7gSfqvBOTNg3sgmUfljoLa
         8UcBo/wc1Qu1pzdyRLOHrWDu8c5S+ZH5sGWSW3/JmSL8553HpfCdSjzw0yxzRiNBYbWC
         1bLt2p+coYxlc24gLAKw7M+M7FzF4TR1dbny4/o9uZuspCpQpC1sxpNFXYPxzo+qDpnZ
         u79n8LvfU+1T77NKpvsxFLemnSfgH5IYz40Q+3gk6dGN4mXy89jVhoXcYPP3MzMPDagV
         Ltjg==
X-Gm-Message-State: AJIora/4GyiN3+Zs6V8kAV4T3B7L44DCnksfOF8xLB+QZNX/mkq5wTy7
        9+zKdT76gUY2NKu328EOac0=
X-Google-Smtp-Source: AGRyM1t7klR8/9yBp9KZbAHXrbhlzlQcutHEwC7cUKIBxNZGAoXppItKv0o+pe2qJpKc+9W0jN5C+g==
X-Received: by 2002:a50:ec0c:0:b0:43c:fd26:404d with SMTP id g12-20020a50ec0c000000b0043cfd26404dmr4321577edr.359.1659111384082;
        Fri, 29 Jul 2022 09:16:24 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan (4.196.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.196.4])
        by smtp.gmail.com with ESMTPSA id fm15-20020a1709072acf00b0072b14836087sm1870116ejc.103.2022.07.29.09.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:16:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 v2 6/9] xfs: hold buffer across unpin and potential shutdown processing
Date:   Fri, 29 Jul 2022 18:16:06 +0200
Message-Id: <20220729161609.4071252-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220729161609.4071252-1-amir73il@gmail.com>
References: <20220729161609.4071252-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 84d8949e770745b16a7e8a68dcb1d0f3687bdee9 upstream.

The special processing used to simulate a buffer I/O failure on fs
shutdown has a difficult to reproduce race that can result in a use
after free of the associated buffer. Consider a buffer that has been
committed to the on-disk log and thus is AIL resident. The buffer
lands on the writeback delwri queue, but is subsequently locked,
committed and pinned by another transaction before submitted for
I/O. At this point, the buffer is stuck on the delwri queue as it
cannot be submitted for I/O until it is unpinned. A log checkpoint
I/O failure occurs sometime later, which aborts the bli. The unpin
handler is called with the aborted log item, drops the bli reference
count, the pin count, and falls into the I/O failure simulation
path.

The potential problem here is that once the pin count falls to zero
in ->iop_unpin(), xfsaild is free to retry delwri submission of the
buffer at any time, before the unpin handler even completes. If
delwri queue submission wins the race to the buffer lock, it
observes the shutdown state and simulates the I/O failure itself.
This releases both the bli and delwri queue holds and frees the
buffer while xfs_buf_item_unpin() sits on xfs_buf_lock() waiting to
run through the same failure sequence. This problem is rare and
requires many iterations of fstest generic/019 (which simulates disk
I/O failures) to reproduce.

To avoid this problem, grab a hold on the buffer before the log item
is unpinned if the associated item has been aborted and will require
a simulated I/O failure. The hold is already required for the
simulated I/O failure, so the ordering simply guarantees the unpin
handler access to the buffer before it is unpinned and thus
processed by the AIL. This particular ordering is required so long
as the AIL does not acquire a reference on the bli, which is the
long term solution to this problem.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5d6535370f87..452af57731ed 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -393,17 +393,8 @@ xfs_buf_item_pin(
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log
- * item which was previously pinned with a call to xfs_buf_item_pin().
- *
- * Also drop the reference to the buf item for the current transaction.
- * If the XFS_BLI_STALE flag is set and we are the last reference,
- * then free up the buf log item and unlock the buffer.
- *
- * If the remove flag is set we are called from uncommit in the
- * forced-shutdown path.  If that is true and the reference count on
- * the log item is going to drop to zero we need to free the item's
- * descriptor in the transaction.
+ * This is called to unpin the buffer associated with the buf log item which
+ * was previously pinned with a call to xfs_buf_item_pin().
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -420,12 +411,26 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
+	/*
+	 * Drop the bli ref associated with the pin and grab the hold required
+	 * for the I/O simulation failure in the abort case. We have to do this
+	 * before the pin count drops because the AIL doesn't acquire a bli
+	 * reference. Therefore if the refcount drops to zero, the bli could
+	 * still be AIL resident and the buffer submitted for I/O (and freed on
+	 * completion) at any point before we return. This can be removed once
+	 * the AIL properly holds a reference on the bli.
+	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-
+	if (freed && !stale && remove)
+		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	if (freed && stale) {
+	 /* nothing to do but drop the pin count if the bli is active */
+	if (!freed)
+		return;
+
+	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_flags & XBF_STALE);
@@ -468,13 +473,13 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (freed && remove) {
+	} else if (remove) {
 		/*
 		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure.
+		 * an async I/O failure. We acquired the hold for this case
+		 * before the buffer was unpinned.
 		 */
 		xfs_buf_lock(bp);
-		xfs_buf_hold(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
 	}
-- 
2.25.1

