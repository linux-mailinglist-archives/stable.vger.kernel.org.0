Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6F64408F7
	for <lists+stable@lfdr.de>; Sat, 30 Oct 2021 15:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhJ3NKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Oct 2021 09:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhJ3NKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 Oct 2021 09:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3867F61040;
        Sat, 30 Oct 2021 13:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635599304;
        bh=2sIaxcwMsk9qdCk8zVHq+BTASTkdUlpSWF7UD7QWnzk=;
        h=Subject:To:Cc:From:Date:From;
        b=etWRmF5bf8lMyqxvgLV5u0camfTmfx4HqpzCgZZ8TpKoF+aLtBdEE9thB0k/0X9EM
         jTX+nZ15lDztEg6eMki/8qzJIKH3DxRx531uXpuGRmllX/X5U2jNnxgcWMKkEHpPDR
         LK/SDGlCj2c/NIkUiHxTdeytUTdCuQr+qOuL2Q/k=
Subject: FAILED: patch "[PATCH] net: hns3: fix data endian problem of some functions of" failed to apply to 5.10-stable tree
To:     wangjie125@huawei.com, davem@davemloft.net,
        huangguangbin2@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Oct 2021 15:08:14 +0200
Message-ID: <1635599294179208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2a21dab594a98c338c4bfbc31864cbca15888549 Mon Sep 17 00:00:00 2001
From: Jie Wang <wangjie125@huawei.com>
Date: Wed, 27 Oct 2021 20:11:46 +0800
Subject: [PATCH] net: hns3: fix data endian problem of some functions of
 debugfs

The member data in struct hclge_desc is type of __le32, it needs endian
conversion before using it, and some functions of debugfs didn't do that,
so this patch fixes it.

Fixes: c0ebebb9ccc1 ("net: hns3: Add "dcb register" status information query function")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 32f62cd2dd99..9cda8b3562b8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -391,7 +391,7 @@ static int hclge_dbg_dump_mac(struct hclge_dev *hdev, char *buf, int len)
 static int hclge_dbg_dump_dcb_qset(struct hclge_dev *hdev, char *buf, int len,
 				   int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u16 qset_id, qset_num;
 	int ret;
@@ -408,12 +408,12 @@ static int hclge_dbg_dump_dcb_qset(struct hclge_dev *hdev, char *buf, int len,
 		if (ret)
 			return ret;
 
-		bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+		req.bitmap = (u8)le32_to_cpu(desc.data[1]);
 
 		*pos += scnprintf(buf + *pos, len - *pos,
 				  "%04u           %#x            %#x             %#x               %#x\n",
-				  qset_id, bitmap->bit0, bitmap->bit1,
-				  bitmap->bit2, bitmap->bit3);
+				  qset_id, req.bit0, req.bit1, req.bit2,
+				  req.bit3);
 	}
 
 	return 0;
@@ -422,7 +422,7 @@ static int hclge_dbg_dump_dcb_qset(struct hclge_dev *hdev, char *buf, int len,
 static int hclge_dbg_dump_dcb_pri(struct hclge_dev *hdev, char *buf, int len,
 				  int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u8 pri_id, pri_num;
 	int ret;
@@ -439,12 +439,11 @@ static int hclge_dbg_dump_dcb_pri(struct hclge_dev *hdev, char *buf, int len,
 		if (ret)
 			return ret;
 
-		bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+		req.bitmap = (u8)le32_to_cpu(desc.data[1]);
 
 		*pos += scnprintf(buf + *pos, len - *pos,
 				  "%03u       %#x           %#x                %#x\n",
-				  pri_id, bitmap->bit0, bitmap->bit1,
-				  bitmap->bit2);
+				  pri_id, req.bit0, req.bit1, req.bit2);
 	}
 
 	return 0;
@@ -453,7 +452,7 @@ static int hclge_dbg_dump_dcb_pri(struct hclge_dev *hdev, char *buf, int len,
 static int hclge_dbg_dump_dcb_pg(struct hclge_dev *hdev, char *buf, int len,
 				 int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u8 pg_id;
 	int ret;
@@ -466,12 +465,11 @@ static int hclge_dbg_dump_dcb_pg(struct hclge_dev *hdev, char *buf, int len,
 		if (ret)
 			return ret;
 
-		bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+		req.bitmap = (u8)le32_to_cpu(desc.data[1]);
 
 		*pos += scnprintf(buf + *pos, len - *pos,
 				  "%03u      %#x           %#x               %#x\n",
-				  pg_id, bitmap->bit0, bitmap->bit1,
-				  bitmap->bit2);
+				  pg_id, req.bit0, req.bit1, req.bit2);
 	}
 
 	return 0;
@@ -511,7 +509,7 @@ static int hclge_dbg_dump_dcb_queue(struct hclge_dev *hdev, char *buf, int len,
 static int hclge_dbg_dump_dcb_port(struct hclge_dev *hdev, char *buf, int len,
 				   int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u8 port_id = 0;
 	int ret;
@@ -521,12 +519,12 @@ static int hclge_dbg_dump_dcb_port(struct hclge_dev *hdev, char *buf, int len,
 	if (ret)
 		return ret;
 
-	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+	req.bitmap = (u8)le32_to_cpu(desc.data[1]);
 
 	*pos += scnprintf(buf + *pos, len - *pos, "port_mask: %#x\n",
-			 bitmap->bit0);
+			 req.bit0);
 	*pos += scnprintf(buf + *pos, len - *pos, "port_shaping_pass: %#x\n",
-			 bitmap->bit1);
+			 req.bit1);
 
 	return 0;
 }

