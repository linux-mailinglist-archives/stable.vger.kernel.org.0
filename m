Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E855213C3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 13:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238508AbiEJLdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 07:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiEJLde (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 07:33:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB7824C753;
        Tue, 10 May 2022 04:29:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5E4E61F8B4;
        Tue, 10 May 2022 11:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652182176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=l88OpwymRS8kYMT+FtQrPUr282oi1DS0LV6Iq7a+NEo=;
        b=sccR5tjtw/BTBdtBS/TFaH5JsbySvaN6uIvnLE0FSUi/ivNyZZybBymUVuQAJXv/tAzPQp
        CAosYGoSSONEKk63ZLrTu8wRdCvgpz3zmIIK5xv1eN5Inb6IGspBb3oySuvvraym8R7SXD
        VRKi5hKWrLGKiAhML5n8iL1CaMBYk9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652182176;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=l88OpwymRS8kYMT+FtQrPUr282oi1DS0LV6Iq7a+NEo=;
        b=Qkg+ay/p5cySNPVREBN88JbwWbXDsrF2g/KUqvwT6I0ITC2FGU0rzIgXTMbnqiHJJ/H+tr
        4UvZZkLD37xPsdAg==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 43D492C142;
        Tue, 10 May 2022 11:29:36 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C032BA062A; Tue, 10 May 2022 13:29:35 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] udf: Avoid using stale lengthOfImpUse
Date:   Tue, 10 May 2022 13:29:31 +0200
Message-Id: <20220510112931.9102-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1796; h=from:subject; bh=wgVZsNK3VcuIy4uYOZz3QzfhIsgyFOij3rrxo7PFolc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiekyJmpoBUQggiCS90rKJzDXzFX4KXCPVgCCmW9Hd pKkzDcqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYnpMiQAKCRCcnaoHP2RA2eKBB/ 9WYSaWxHRuhFC9cc6PDQgCQV4EBwVzea8Qq1odxzB0W4fQtYjSeshgBJ/Jw69wT/5wLJ8StxI5G78G YWgiP/3yrnTn1n2YRAcDbYrqxt6t5tv4Kdbn1rS7nqD8pEjj1Bj72/xKnZOaty41bCe/tszRtYyjKu PJpxdNaXhxWNUnFYrJYXzDP77LXYQgEmgwM8ZPBHw254UwCQ3stS5/1+gGpjEp56l13rOVcX7Mo2DG OrUp6o5AoxnkjzwfVSGXJl90getCvA/4SZUyRE0FAZnXo8/cTgXdTqJhtQEjMOo/s0ixKD0g5km3dK IOjwmQT4Ab8OFxE8JsbeVf75ZqMRCY
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

udf_write_fi() uses lengthOfImpUse of the entry it is writing to.
However this field has not yet been initialized so it either contains
completely bogus value or value from last directory entry at that place.
In either case this is wrong and can lead to filesystem corruption or
kernel crashes.

Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
CC: stable@vger.kernel.org
Fixes: 979a6e28dd96 ("udf: Get rid of 0-length arrays in struct fileIdentDesc")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/namei.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index 0ed4861b038f..b3d5f97f16cd 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -75,11 +75,11 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 
 	if (fileident) {
 		if (adinicb || (offset + lfi < 0)) {
-			memcpy(udf_get_fi_ident(sfi), fileident, lfi);
+			memcpy(sfi->impUse + liu, fileident, lfi);
 		} else if (offset >= 0) {
 			memcpy(fibh->ebh->b_data + offset, fileident, lfi);
 		} else {
-			memcpy(udf_get_fi_ident(sfi), fileident, -offset);
+			memcpy(sfi->impUse + liu, fileident, -offset);
 			memcpy(fibh->ebh->b_data, fileident - offset,
 				lfi + offset);
 		}
@@ -88,11 +88,11 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 	offset += lfi;
 
 	if (adinicb || (offset + padlen < 0)) {
-		memset(udf_get_fi_ident(sfi) + lfi, 0x00, padlen);
+		memset(sfi->impUse + liu + lfi, 0x00, padlen);
 	} else if (offset >= 0) {
 		memset(fibh->ebh->b_data + offset, 0x00, padlen);
 	} else {
-		memset(udf_get_fi_ident(sfi) + lfi, 0x00, -offset);
+		memset(sfi->impUse + liu + lfi, 0x00, -offset);
 		memset(fibh->ebh->b_data, 0x00, padlen + offset);
 	}
 
-- 
2.35.3

