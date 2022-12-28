Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607DF657B7E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbiL1PXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbiL1PWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:22:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2310E14028
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:22:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6B01B8170E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2414CC433EF;
        Wed, 28 Dec 2022 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240935;
        bh=8ulE3xdIl3AR5duLY964L4RyNp7VI6pFUjXAAX4C410=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZA0F0IVfd2YgeI0CQg424N3nHk2ptjoa2L31V0kfYAcRzaQ96UoQZzoGRSyyZBI/Q
         hKahhGnLe7rQZwJoGJf6XpqII9hmFATvcU0SMjEL3VwynRjI+2sXl10Ci3gWTKp0Jv
         hBxHD0sBNmXU5btGaWPpxf85gcbm+E+qzLcoUNRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0186/1146] fs: sysv: Fix sysv_nblocks() returns wrong value
Date:   Wed, 28 Dec 2022 15:28:45 +0100
Message-Id: <20221228144335.204469171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit e0c49bd2b4d3cd1751491eb2d940bce968ac65e9 ]

sysv_nblocks() returns 'blocks' rather than 'res', which only counting
the number of triple-indirect blocks and causing sysv_getattr() gets a
wrong result.

[AV: this is actually a sysv counterpart of minixfs fix -
0fcd426de9d0 "[PATCH] minix block usage counting fix" in
historical tree; mea culpa, should've thought to check
fs/sysv back then...]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sysv/itree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index d4ec9bb97de9..3b8567564e7e 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -438,7 +438,7 @@ static unsigned sysv_nblocks(struct super_block *s, loff_t size)
 		res += blocks;
 		direct = 1;
 	}
-	return blocks;
+	return res;
 }
 
 int sysv_getattr(struct user_namespace *mnt_userns, const struct path *path,
-- 
2.35.1



