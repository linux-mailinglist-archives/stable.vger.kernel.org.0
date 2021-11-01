Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D35344178E
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhKAJhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232951AbhKAJfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 123D2610EA;
        Mon,  1 Nov 2021 09:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758751;
        bh=+dUawZk6GtwDVH/yYAw4hiUj90ZKrLMt98cNPghJXr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISWXhrVo43j3Yx/DO3povu1m8+dkVBppltkIu0ZxBr+dVgKbH56Q0JvyGhcyXAqcY
         R32+gokgsnsH86K+60OeHUs6oFCv5K89oJbr2D/32qTq0Uzo1IpC1YQLWIui9cUxXW
         cvfbIB/eX974M62kDbS7O9vgfWCL20dpk3JYo+NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rakesh Babu <rsaladi2@marvell.com>,
        Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 44/77] octeontx2-af: Display all enabled PF VF rsrc_alloc entries.
Date:   Mon,  1 Nov 2021 10:17:32 +0100
Message-Id: <20211101082521.130369489@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

commit e77bcdd1f639809950c45234b08647ac6d3ffe7b upstream.

Currently, we are using a fixed buffer size of length 2048 to display
rsrc_alloc output. As a result a maximum of 2048 characters of
rsrc_alloc output is displayed, which may lead sometimes to display only
partial output. This patch fixes this dependency on max limit of buffer
size and displays all PF VF entries.

Each column of the debugfs entry "rsrc_alloc" uses a fixed width of 12
characters to print the list of LFs of each block for a PF/VF. If the
length of list of LFs of a block exceeds this fixed width then the list
gets truncated and displays only a part of the list. This patch fixes
this by using the maximum possible length of list of LFs among all
blocks of all PFs and VFs entries as the width size.

Fixes: f7884097141b ("octeontx2-af: Formatting debugfs entry rsrc_alloc.")
Fixes: 23205e6d06d4 ("octeontx2-af: Dump current resource provisioning status")
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c |  138 ++++++++++++----
 1 file changed, 106 insertions(+), 32 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -139,18 +139,85 @@ static const struct file_operations rvu_
 
 static void print_nix_qsize(struct seq_file *filp, struct rvu_pfvf *pfvf);
 
+static void get_lf_str_list(struct rvu_block block, int pcifunc,
+			    char *lfs)
+{
+	int lf = 0, seq = 0, len = 0, prev_lf = block.lf.max;
+
+	for_each_set_bit(lf, block.lf.bmap, block.lf.max) {
+		if (lf >= block.lf.max)
+			break;
+
+		if (block.fn_map[lf] != pcifunc)
+			continue;
+
+		if (lf == prev_lf + 1) {
+			prev_lf = lf;
+			seq = 1;
+			continue;
+		}
+
+		if (seq)
+			len += sprintf(lfs + len, "-%d,%d", prev_lf, lf);
+		else
+			len += (len ? sprintf(lfs + len, ",%d", lf) :
+				      sprintf(lfs + len, "%d", lf));
+
+		prev_lf = lf;
+		seq = 0;
+	}
+
+	if (seq)
+		len += sprintf(lfs + len, "-%d", prev_lf);
+
+	lfs[len] = '\0';
+}
+
+static int get_max_column_width(struct rvu *rvu)
+{
+	int index, pf, vf, lf_str_size = 12, buf_size = 256;
+	struct rvu_block block;
+	u16 pcifunc;
+	char *buf;
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
+		for (vf = 0; vf <= rvu->hw->total_vfs; vf++) {
+			pcifunc = pf << 10 | vf;
+			if (!pcifunc)
+				continue;
+
+			for (index = 0; index < BLK_COUNT; index++) {
+				block = rvu->hw->block[index];
+				if (!strlen(block.name))
+					continue;
+
+				get_lf_str_list(block, pcifunc, buf);
+				if (lf_str_size <= strlen(buf))
+					lf_str_size = strlen(buf) + 1;
+			}
+		}
+	}
+
+	kfree(buf);
+	return lf_str_size;
+}
+
 /* Dumps current provisioning status of all RVU block LFs */
 static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 					  char __user *buffer,
 					  size_t count, loff_t *ppos)
 {
-	int index, off = 0, flag = 0, go_back = 0, len = 0;
+	int index, off = 0, flag = 0, len = 0, i = 0;
 	struct rvu *rvu = filp->private_data;
-	int lf, pf, vf, pcifunc;
+	int bytes_not_copied = 0;
 	struct rvu_block block;
-	int bytes_not_copied;
-	int lf_str_size = 12;
+	int pf, vf, pcifunc;
 	int buf_size = 2048;
+	int lf_str_size;
 	char *lfs;
 	char *buf;
 
@@ -162,6 +229,9 @@ static ssize_t rvu_dbg_rsrc_attach_statu
 	if (!buf)
 		return -ENOSPC;
 
+	/* Get the maximum width of a column */
+	lf_str_size = get_max_column_width(rvu);
+
 	lfs = kzalloc(lf_str_size, GFP_KERNEL);
 	if (!lfs) {
 		kfree(buf);
@@ -175,65 +245,69 @@ static ssize_t rvu_dbg_rsrc_attach_statu
 					 "%-*s", lf_str_size,
 					 rvu->hw->block[index].name);
 		}
+
 	off += scnprintf(&buf[off], buf_size - 1 - off, "\n");
+	bytes_not_copied = copy_to_user(buffer + (i * off), buf, off);
+	if (bytes_not_copied)
+		goto out;
+
+	i++;
+	*ppos += off;
 	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
 		for (vf = 0; vf <= rvu->hw->total_vfs; vf++) {
+			off = 0;
+			flag = 0;
 			pcifunc = pf << 10 | vf;
 			if (!pcifunc)
 				continue;
 
 			if (vf) {
 				sprintf(lfs, "PF%d:VF%d", pf, vf - 1);
-				go_back = scnprintf(&buf[off],
-						    buf_size - 1 - off,
-						    "%-*s", lf_str_size, lfs);
+				off = scnprintf(&buf[off],
+						buf_size - 1 - off,
+						"%-*s", lf_str_size, lfs);
 			} else {
 				sprintf(lfs, "PF%d", pf);
-				go_back = scnprintf(&buf[off],
-						    buf_size - 1 - off,
-						    "%-*s", lf_str_size, lfs);
+				off = scnprintf(&buf[off],
+						buf_size - 1 - off,
+						"%-*s", lf_str_size, lfs);
 			}
 
-			off += go_back;
-			for (index = 0; index < BLKTYPE_MAX; index++) {
+			for (index = 0; index < BLK_COUNT; index++) {
 				block = rvu->hw->block[index];
 				if (!strlen(block.name))
 					continue;
 				len = 0;
 				lfs[len] = '\0';
-				for (lf = 0; lf < block.lf.max; lf++) {
-					if (block.fn_map[lf] != pcifunc)
-						continue;
+				get_lf_str_list(block, pcifunc, lfs);
+				if (strlen(lfs))
 					flag = 1;
-					len += sprintf(&lfs[len], "%d,", lf);
-				}
 
-				if (flag)
-					len--;
-				lfs[len] = '\0';
 				off += scnprintf(&buf[off], buf_size - 1 - off,
 						 "%-*s", lf_str_size, lfs);
-				if (!strlen(lfs))
-					go_back += lf_str_size;
 			}
-			if (!flag)
-				off -= go_back;
-			else
-				flag = 0;
-			off--;
-			off +=	scnprintf(&buf[off], buf_size - 1 - off, "\n");
+			if (flag) {
+				off +=	scnprintf(&buf[off],
+						  buf_size - 1 - off, "\n");
+				bytes_not_copied = copy_to_user(buffer +
+								(i * off),
+								buf, off);
+				if (bytes_not_copied)
+					goto out;
+
+				i++;
+				*ppos += off;
+			}
 		}
 	}
 
-	bytes_not_copied = copy_to_user(buffer, buf, off);
+out:
 	kfree(lfs);
 	kfree(buf);
-
 	if (bytes_not_copied)
 		return -EFAULT;
 
-	*ppos = off;
-	return off;
+	return *ppos;
 }
 
 RVU_DEBUG_FOPS(rsrc_status, rsrc_attach_status, NULL);


