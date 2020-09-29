Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215C827C352
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgI2LEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728586AbgI2LEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:04:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA35321734;
        Tue, 29 Sep 2020 11:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377471;
        bh=nV2hnbKtkB2BlDOC4qeSSeGMkvJWmVGMRnEvR21pAkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xwjsv/X2lMlxrPWc6cYbgjJuqbTxiAF5dD45WC56vp9JWpdXnkx5gtJnt1RYnelHI
         BGPME54sIT3+b2uR1ulmShaZvROocdOsbKMOmkg6RtkppSxjugah1MHFQP1YeWrqiT
         Q/HljNQJYbKAarYIHdMlvjIT3sHu38RHu+0+oPpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Song <liu.song11@zte.com.cn>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 47/85] ubifs: Fix out-of-bounds memory access caused by abnormal value of node_len
Date:   Tue, 29 Sep 2020 13:00:14 +0200
Message-Id: <20200929105930.589534153@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



