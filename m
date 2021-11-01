Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424BD441883
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhKAJtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234565AbhKAJrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20075613DB;
        Mon,  1 Nov 2021 09:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759040;
        bh=ZSFO595i7pmRGBTm8Yu/O+S22szZYMD9KTJPSPbmjpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xa414NjbwTLLxFn3GUZjSKrn7fHBVWqA1yrDNLinlpB/uvBV+/U0YbIc4L1bu6RXD
         AR4CqKJt5c5ibRV8UXOix/JYls0bUrU78AqIweE/f6+UR32O1OQmoongTdPOccCAJL
         Y5nhpXG998bhRcAvS2fzfS6bXpBntguXPQDWd3pE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 089/125] net: hns3: fix data endian problem of some functions of debugfs
Date:   Mon,  1 Nov 2021 10:17:42 +0100
Message-Id: <20211101082550.010453252@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

commit 2a21dab594a98c338c4bfbc31864cbca15888549 upstream.

The member data in struct hclge_desc is type of __le32, it needs endian
conversion before using it, and some functions of debugfs didn't do that,
so this patch fixes it.

Fixes: c0ebebb9ccc1 ("net: hns3: Add "dcb register" status information query function")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   30 ++++++-------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -391,7 +391,7 @@ static int hclge_dbg_dump_mac(struct hcl
 static int hclge_dbg_dump_dcb_qset(struct hclge_dev *hdev, char *buf, int len,
 				   int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u16 qset_id, qset_num;
 	int ret;
@@ -408,12 +408,12 @@ static int hclge_dbg_dump_dcb_qset(struc
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
@@ -422,7 +422,7 @@ static int hclge_dbg_dump_dcb_qset(struc
 static int hclge_dbg_dump_dcb_pri(struct hclge_dev *hdev, char *buf, int len,
 				  int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u8 pri_id, pri_num;
 	int ret;
@@ -439,12 +439,11 @@ static int hclge_dbg_dump_dcb_pri(struct
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
@@ -453,7 +452,7 @@ static int hclge_dbg_dump_dcb_pri(struct
 static int hclge_dbg_dump_dcb_pg(struct hclge_dev *hdev, char *buf, int len,
 				 int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u8 pg_id;
 	int ret;
@@ -466,12 +465,11 @@ static int hclge_dbg_dump_dcb_pg(struct
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
@@ -511,7 +509,7 @@ static int hclge_dbg_dump_dcb_queue(stru
 static int hclge_dbg_dump_dcb_port(struct hclge_dev *hdev, char *buf, int len,
 				   int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u8 port_id = 0;
 	int ret;
@@ -521,12 +519,12 @@ static int hclge_dbg_dump_dcb_port(struc
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


