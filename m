Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9996799DE
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbjAXNmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbjAXNm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:42:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7177745BEE;
        Tue, 24 Jan 2023 05:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F5F8B811D8;
        Tue, 24 Jan 2023 13:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878B6C433A0;
        Tue, 24 Jan 2023 13:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567722;
        bh=3KKifScuk1hhvnnfmlwGuRuD5jQ4e0Nucu2H8lY9BBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQ/XkeBHLv9it+1z4dw0NjGVvkYjlKf8h3awo5XZlX9U+vmlWtwAyilHa+3jLGJmd
         ByWBvvy4IrTp8ZEP9DmExC4Q46F5tpT7IrC3qVgM0ToCs1Uj4aTsa9ugUivXGHq5P0
         FNDbL0JSgAqzSAVN2b8hhbmQocQhZnxCP1yvG3jcTM54HI+faeIf4s88/x3yrA72Al
         kL0EsZsYYhw3cRuh8Khc9h9gQ16UJFGombplMJ7lAuI1eKhgzIQlXTBF/OpSfiz5C/
         0QggT+0FkZ+aDlRCyJ4txtQwEvfTEiEzaun+HUcOD4qO76Wme/YRuQ652b95zwGndM
         df+OQGHpNG4UQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingbo Xu <jefflexu@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Yue Hu <huyue2@coolpad.com>, Chao Yu <chao@kernel.org>,
        Sasha Levin <sashal@kernel.org>, xiang@kernel.org,
        linux-erofs@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.1 13/35] erofs: clean up parsing of fscache related options
Date:   Tue, 24 Jan 2023 08:41:09 -0500
Message-Id: <20230124134131.637036-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit e02ac3e7329f76c5de40cba2746cbe165f571dff ]

... to avoid the mess of conditional preprocessing as we are continually
adding fscache related mount options.

Reviewd-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230112065431.124926-3-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 481788c24a68..626a615dafc2 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -577,26 +577,25 @@ static int erofs_fc_parse_param(struct fs_context *fc,
 		}
 		++ctx->devs->extra_devices;
 		break;
-	case Opt_fsid:
 #ifdef CONFIG_EROFS_FS_ONDEMAND
+	case Opt_fsid:
 		kfree(ctx->fsid);
 		ctx->fsid = kstrdup(param->string, GFP_KERNEL);
 		if (!ctx->fsid)
 			return -ENOMEM;
-#else
-		errorfc(fc, "fsid option not supported");
-#endif
 		break;
 	case Opt_domain_id:
-#ifdef CONFIG_EROFS_FS_ONDEMAND
 		kfree(ctx->domain_id);
 		ctx->domain_id = kstrdup(param->string, GFP_KERNEL);
 		if (!ctx->domain_id)
 			return -ENOMEM;
+		break;
 #else
-		errorfc(fc, "domain_id option not supported");
-#endif
+	case Opt_fsid:
+	case Opt_domain_id:
+		errorfc(fc, "%s option not supported", erofs_fs_parameters[opt].name);
 		break;
+#endif
 	default:
 		return -ENOPARAM;
 	}
-- 
2.39.0

