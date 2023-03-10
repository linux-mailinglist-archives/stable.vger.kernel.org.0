Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023F56B49DE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbjCJPQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234058AbjCJPQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:16:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EDD134AEB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:07:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D31A61964
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6497AC433D2;
        Fri, 10 Mar 2023 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460779;
        bh=SJ2h/f4CPJM9sjsEjp37Z0Bnw/TnuBiqry36BW1c61E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5N28Z0Oee4/x9Pg9BJXCszOLrJ3uvOOWjga91FIAxyQRd+xOSoru0BbHuBMw7dzt
         0bnzqRm0flSRxP6u8/hnIqShaT4BDJ+s1UPrpLjBOO9JZXYhbvsMD9/VYhEoy1rwRD
         m+L6YFldlVNrAjlqvqsv2WAzuLsmpjqUbDHnqxT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Hua <hucool.lihua@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 441/529] ubifs: Fix build errors as symbol undefined
Date:   Fri, 10 Mar 2023 14:39:44 +0100
Message-Id: <20230310133825.358811535@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Hua <hucool.lihua@huawei.com>

[ Upstream commit aa6d148e6d6270274e3d5a529b71c54cd329d17f ]

With CONFIG_UBIFS_FS_AUTHENTICATION not set, the compiler can assume that
ubifs_node_check_hash() is never true and drops the call to ubifs_bad_hash().
Is CONFIG_CC_OPTIMIZE_FOR_SIZE enabled this optimization does not happen anymore.

So When CONFIG_UBIFS_FS and CONFIG_CC_OPTIMIZE_FOR_SIZE is enabled but
CONFIG_UBIFS_FS_AUTHENTICATION is not set, the build errors is as followd:
    ERROR: modpost: "ubifs_bad_hash" [fs/ubifs/ubifs.ko] undefined!

Fix it by add no-op ubifs_bad_hash() for the CONFIG_UBIFS_FS_AUTHENTICATION=n case.

Fixes: 16a26b20d2af ("ubifs: authentication: Add hashes to index nodes")
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/ubifs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index e7e48f3b179ab..b66ebab5c5dec 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1594,8 +1594,13 @@ static inline int ubifs_check_hmac(const struct ubifs_info *c,
 	return crypto_memneq(expected, got, c->hmac_desc_len);
 }
 
+#ifdef CONFIG_UBIFS_FS_AUTHENTICATION
 void ubifs_bad_hash(const struct ubifs_info *c, const void *node,
 		    const u8 *hash, int lnum, int offs);
+#else
+static inline void ubifs_bad_hash(const struct ubifs_info *c, const void *node,
+				  const u8 *hash, int lnum, int offs) {};
+#endif
 
 int __ubifs_node_check_hash(const struct ubifs_info *c, const void *buf,
 			  const u8 *expected);
-- 
2.39.2



