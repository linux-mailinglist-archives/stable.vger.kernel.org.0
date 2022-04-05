Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A194F4618
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380680AbiDEMNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357942AbiDEK1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C509939B6;
        Tue,  5 Apr 2022 03:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4B6FB81C88;
        Tue,  5 Apr 2022 10:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D2CC385A1;
        Tue,  5 Apr 2022 10:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153487;
        bh=sRY6U65i0znfe3KehcP3ZybCJpLi0ibCWb/vy8ikJbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ksSywIJvrslXgM9ZFm7DF79ErCOVgdP/eve+Ftl2OAavzAHhFDbmK5KmtgmSTLEh
         Afd8A0Ic3WIMGdgpsThZo5m2TZ800dUFQf7iZfXIlEwA0X7vQN5RQAKeV56X04AT5h
         MJCk/q5FkzTFQrexSrcR7uIXYe9IgA6dGPsW0e/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/599] media: vidtv: Check for null return of vzalloc
Date:   Tue,  5 Apr 2022 09:28:52 +0200
Message-Id: <20220405070305.922931016@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit e6a21a14106d9718aa4f8e115b1e474888eeba44 ]

As the possible failure of the vzalloc(), e->encoder_buf might be NULL.
Therefore, it should be better to check it in order
to guarantee the success of the initialization.
If fails, we need to free not only 'e' but also 'e->name'.
Also, if the allocation for ctx fails, we need to free 'e->encoder_buf'
else.

Fixes: f90cf6079bf6 ("media: vidtv: add a bridge driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vidtv/vidtv_s302m.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_s302m.c b/drivers/media/test-drivers/vidtv/vidtv_s302m.c
index d79b65854627..4676083cee3b 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_s302m.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_s302m.c
@@ -455,6 +455,9 @@ struct vidtv_encoder
 		e->name = kstrdup(args.name, GFP_KERNEL);
 
 	e->encoder_buf = vzalloc(VIDTV_S302M_BUF_SZ);
+	if (!e->encoder_buf)
+		goto out_kfree_e;
+
 	e->encoder_buf_sz = VIDTV_S302M_BUF_SZ;
 	e->encoder_buf_offset = 0;
 
@@ -467,10 +470,8 @@ struct vidtv_encoder
 	e->is_video_encoder = false;
 
 	ctx = kzalloc(priv_sz, GFP_KERNEL);
-	if (!ctx) {
-		kfree(e);
-		return NULL;
-	}
+	if (!ctx)
+		goto out_kfree_buf;
 
 	e->ctx = ctx;
 	ctx->last_duration = 0;
@@ -498,6 +499,14 @@ struct vidtv_encoder
 	e->next = NULL;
 
 	return e;
+
+out_kfree_buf:
+	kfree(e->encoder_buf);
+
+out_kfree_e:
+	kfree(e->name);
+	kfree(e);
+	return NULL;
 }
 
 void vidtv_s302m_encoder_destroy(struct vidtv_encoder *e)
-- 
2.34.1



