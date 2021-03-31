Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C2434CA79
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhC2Iim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231475AbhC2Ig5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 860E2619AA;
        Mon, 29 Mar 2021 08:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006970;
        bh=S19XpGdRWHwGiCP5Vh7cyhqQn3l9rvHTaARaTFYbnWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJXYz/cVimk/JlsMmdujgoHeSnrYSGhcmiXDlfG8XQ0Wb+ddhnaVkq6jK6kEowDtN
         CjTkysoggMS/bPbMPCq5lkf1NZ9QkW9rQgKAHO6VTZAV0n/AIxSEijvYzhHAJqI4gu
         fue4ybPGezGiAPOB0MNlWZTDqpdPJRCsDGPtYvJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Babu <rsaladi2@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 173/254] octeontx2-af: Formatting debugfs entry rsrc_alloc.
Date:   Mon, 29 Mar 2021 09:58:09 +0200
Message-Id: <20210329075638.847568376@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

[ Upstream commit f7884097141b615b6ce89c16f456a53902b4eec3 ]

With the existing rsrc_alloc's format, there is misalignment for the
pcifunc entries whose VF's index is a double digit. This patch fixes
this.

    pcifunc     NPA         NIX0        NIX1        SSO GROUP   SSOWS
    TIM         CPT0        CPT1        REE0        REE1
    PF0:VF0     8           5
    PF0:VF1     9                       3
    PF0:VF10    18          10
    PF0:VF11    19                      8
    PF0:VF12    20          11
    PF0:VF13    21                      9
    PF0:VF14    22          12
    PF0:VF15    23                      10
    PF1         0           0

Fixes: 23205e6d06d4 ("octeontx2-af: Dump current resource provisioning status")
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 46 ++++++++++++-------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index bb3fdaf33751..ea1e520b6552 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -150,12 +150,14 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 					  char __user *buffer,
 					  size_t count, loff_t *ppos)
 {
-	int index, off = 0, flag = 0, go_back = 0, off_prev;
+	int index, off = 0, flag = 0, go_back = 0, len = 0;
 	struct rvu *rvu = filp->private_data;
 	int lf, pf, vf, pcifunc;
 	struct rvu_block block;
 	int bytes_not_copied;
+	int lf_str_size = 12;
 	int buf_size = 2048;
+	char *lfs;
 	char *buf;
 
 	/* don't allow partial reads */
@@ -165,12 +167,18 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 	buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!buf)
 		return -ENOSPC;
-	off +=	scnprintf(&buf[off], buf_size - 1 - off, "\npcifunc\t\t");
+
+	lfs = kzalloc(lf_str_size, GFP_KERNEL);
+	if (!lfs)
+		return -ENOMEM;
+	off +=	scnprintf(&buf[off], buf_size - 1 - off, "%-*s", lf_str_size,
+			  "pcifunc");
 	for (index = 0; index < BLK_COUNT; index++)
-		if (strlen(rvu->hw->block[index].name))
-			off +=	scnprintf(&buf[off], buf_size - 1 - off,
-					  "%*s\t", (index - 1) * 2,
-					  rvu->hw->block[index].name);
+		if (strlen(rvu->hw->block[index].name)) {
+			off += scnprintf(&buf[off], buf_size - 1 - off,
+					 "%-*s", lf_str_size,
+					 rvu->hw->block[index].name);
+		}
 	off += scnprintf(&buf[off], buf_size - 1 - off, "\n");
 	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
 		for (vf = 0; vf <= rvu->hw->total_vfs; vf++) {
@@ -179,14 +187,15 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 				continue;
 
 			if (vf) {
+				sprintf(lfs, "PF%d:VF%d", pf, vf - 1);
 				go_back = scnprintf(&buf[off],
 						    buf_size - 1 - off,
-						    "PF%d:VF%d\t\t", pf,
-						    vf - 1);
+						    "%-*s", lf_str_size, lfs);
 			} else {
+				sprintf(lfs, "PF%d", pf);
 				go_back = scnprintf(&buf[off],
 						    buf_size - 1 - off,
-						    "PF%d\t\t", pf);
+						    "%-*s", lf_str_size, lfs);
 			}
 
 			off += go_back;
@@ -194,20 +203,22 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 				block = rvu->hw->block[index];
 				if (!strlen(block.name))
 					continue;
-				off_prev = off;
+				len = 0;
+				lfs[len] = '\0';
 				for (lf = 0; lf < block.lf.max; lf++) {
 					if (block.fn_map[lf] != pcifunc)
 						continue;
 					flag = 1;
-					off += scnprintf(&buf[off], buf_size - 1
-							- off, "%3d,", lf);
+					len += sprintf(&lfs[len], "%d,", lf);
 				}
-				if (flag && off_prev != off)
-					off--;
-				else
-					go_back++;
+
+				if (flag)
+					len--;
+				lfs[len] = '\0';
 				off += scnprintf(&buf[off], buf_size - 1 - off,
-						"\t");
+						 "%-*s", lf_str_size, lfs);
+				if (!strlen(lfs))
+					go_back += lf_str_size;
 			}
 			if (!flag)
 				off -= go_back;
@@ -219,6 +230,7 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 	}
 
 	bytes_not_copied = copy_to_user(buffer, buf, off);
+	kfree(lfs);
 	kfree(buf);
 
 	if (bytes_not_copied)
-- 
2.30.1



