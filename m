Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9D226ED31
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgIRCRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729177AbgIRCRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:17:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E74032396F;
        Fri, 18 Sep 2020 02:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395450;
        bh=nV2hnbKtkB2BlDOC4qeSSeGMkvJWmVGMRnEvR21pAkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOOr4LTuMquWCRq//sZqeGeD3aXOrOd8tfZzzIUfcJOEdz3Q3Z0BzjyRVqkneVD4W
         Hay4uScr+5H6QfuMHl4tI2P8WdCsbODt7yp0xFJ5xEo5OUwdLcBUVLTG9IB5mD9sQa
         MbnhjIu+GgYODIiR805DKf6l1mjUOJTEL2r/lJzw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liu Song <liu.song11@zte.com.cn>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 38/64] ubifs: Fix out-of-bounds memory access caused by abnormal value of node_len
Date:   Thu, 17 Sep 2020 22:16:17 -0400
Message-Id: <20200918021643.2067895-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021643.2067895-1-sashal@kernel.org>
References: <20200918021643.2067895-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Song <liu.song11@zte.com.cn>

[ Upstream commit acc5af3efa303d5f36cc8c0f61716161f6ca1384 ]

In “ubifs_check_node”, when the value of "node_len" is abnormal,
the code will goto label of "out_len" for execution. Then, in the
following "ubifs_dump_node", if inode type is "UBIFS_DATA_NODE",
in "print_hex_dump", an out-of-bounds access may occur due to the
wrong "ch->len".

Therefore, when the value of "node_len" is abnormal, data length
should to be adjusted to a reasonable safe range. At this time,
structured data is not credible, so dump the corrupted data directly
for analysis.

Signed-off-by: Liu Song <liu.song11@zte.com.cn>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/io.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 97be412153328..9213a9e046ae0 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -237,7 +237,7 @@ int ubifs_is_mapped(const struct ubifs_info *c, int lnum)
 int ubifs_check_node(const struct ubifs_info *c, const void *buf, int lnum,
 		     int offs, int quiet, int must_chk_crc)
 {
-	int err = -EINVAL, type, node_len;
+	int err = -EINVAL, type, node_len, dump_node = 1;
 	uint32_t crc, node_crc, magic;
 	const struct ubifs_ch *ch = buf;
 
@@ -290,10 +290,22 @@ int ubifs_check_node(const struct ubifs_info *c, const void *buf, int lnum,
 out_len:
 	if (!quiet)
 		ubifs_err(c, "bad node length %d", node_len);
+	if (type == UBIFS_DATA_NODE && node_len > UBIFS_DATA_NODE_SZ)
+		dump_node = 0;
 out:
 	if (!quiet) {
 		ubifs_err(c, "bad node at LEB %d:%d", lnum, offs);
-		ubifs_dump_node(c, buf);
+		if (dump_node) {
+			ubifs_dump_node(c, buf);
+		} else {
+			int safe_len = min3(node_len, c->leb_size - offs,
+				(int)UBIFS_MAX_DATA_NODE_SZ);
+			pr_err("\tprevent out-of-bounds memory access\n");
+			pr_err("\ttruncated data node length      %d\n", safe_len);
+			pr_err("\tcorrupted data node:\n");
+			print_hex_dump(KERN_ERR, "\t", DUMP_PREFIX_OFFSET, 32, 1,
+					buf, safe_len, 0);
+		}
 		dump_stack();
 	}
 	return err;
-- 
2.25.1

