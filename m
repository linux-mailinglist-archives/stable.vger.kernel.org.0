Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EE4689587
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbjBCKWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjBCKWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:22:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEA89EE28
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:21:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51636B82A70
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE76C4339B;
        Fri,  3 Feb 2023 10:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419709;
        bh=3KKifScuk1hhvnnfmlwGuRuD5jQ4e0Nucu2H8lY9BBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9hb3QZ2G3YSP5e/EZ7qS9pnCLgScyFJnISNexXePbYdl6B3uYUBjdn1SPSIHBjsc
         S0hiYA+i0jDVJfepnZ9C8031cteEnmxBKpFJvyN1X28pgfwdFBtM13Iao8/qHcez2R
         WQE18HL/pfklXlmCMORyQAJWS6TbivcBKMXbLtYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yue Hu <huyue2@coolpad.com>,
        Chao Yu <chao@kernel.org>,
        Jingbo Xu <jefflexu@linux.alibaba.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/28] erofs: clean up parsing of fscache related options
Date:   Fri,  3 Feb 2023 11:13:00 +0100
Message-Id: <20230203101010.485999238@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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



