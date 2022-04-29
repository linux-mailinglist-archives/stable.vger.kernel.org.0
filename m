Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87743514720
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 12:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357562AbiD2Koy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 06:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357553AbiD2Kox (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 06:44:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B126B6E6F;
        Fri, 29 Apr 2022 03:41:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B741B8344E;
        Fri, 29 Apr 2022 10:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809CAC385A7;
        Fri, 29 Apr 2022 10:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651228893;
        bh=3HFI7ZCCjny0LVTTOnCpUz+JntGBIBJ+SwPEtVCMWQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wBU6QzwDkh76bpDzLtpNZ3Q60ECf6t68IJAoCYxr2mxmf9iBhpQ2qXdgVzbLzxCWz
         slciM6/FErjB+ClOg0s+Yw3Z+d7zsanKAzVUr+yjwbZMMIAEy+Q5mMzMwcLsV5UCcy
         BGXQieCFMchyXYS8xwCF2cxg/Id2KZvCTz/083u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dafna Hirschfeld <dafna3@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Minh Yuan <yuanmingbuaa@gmail.com>
Subject: [PATCH 4.19 01/12] media: vicodec: upon release, call m2m release before freeing ctrl handler
Date:   Fri, 29 Apr 2022 12:41:18 +0200
Message-Id: <20220429104048.503287650@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220429104048.459089941@linuxfoundation.org>
References: <20220429104048.459089941@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna3@gmail.com>

commit 4d10452cd1ed619d95fde81cef837069f4c754cd upstream.

'v4l2_m2m_ctx_release' calls request complete
so it should be called before 'v4l2_ctrl_handler_free'.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Minh Yuan <yuanmingbuaa@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/vicodec/vicodec-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1297,12 +1297,12 @@ static int vicodec_release(struct file *
 	struct video_device *vfd = video_devdata(file);
 	struct vicodec_ctx *ctx = file2ctx(file);
 
-	v4l2_fh_del(&ctx->fh);
-	v4l2_fh_exit(&ctx->fh);
-	v4l2_ctrl_handler_free(&ctx->hdl);
 	mutex_lock(vfd->lock);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	mutex_unlock(vfd->lock);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	v4l2_ctrl_handler_free(&ctx->hdl);
 	kfree(ctx);
 
 	return 0;


