Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F8C6AEB37
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjCGRlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjCGRlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:41:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CF2CA23
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:37:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 903E4B8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C08C433EF;
        Tue,  7 Mar 2023 17:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210634;
        bh=MUOHKuQMRzPRKuSOb7CRGUTd/lPl6UIDytM4e072ABA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtNiQBAQKRoajgI4iCiIrev+8uS+m/RtALEimd3w9CLuX5xpSwczZnqqrWDRzWgEz
         NysIKp+NyU1zMivVAm8qC/GZL7yDYWIDDHjAK6xjT9FQ/rWmQCdC1/YAVrK7H4VBgb
         yEzeXtlEDlmssOEGolXc2Dhf/4P6zFIaI+oXaPkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0605/1001] media: v4l2-jpeg: ignore the unknown APP14 marker
Date:   Tue,  7 Mar 2023 17:56:17 +0100
Message-Id: <20230307170047.771133001@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 251c0ea6efd3c3ea0f8a55fdd96c749a98639bd3 ]

The legal identifier of APP14 is "Adobe\0",
but sometimes it may be
"This is an unknown APP marker . Compliant decoders must ignore it."
In this case, just ignore it.
It won't affect the decode result.

Fixes: b8035f7988a8 ("media: Add parsing for APP14 data segment in jpeg helpers")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-jpeg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-jpeg.c b/drivers/media/v4l2-core/v4l2-jpeg.c
index 75c2af763d55e..94435a7b68169 100644
--- a/drivers/media/v4l2-core/v4l2-jpeg.c
+++ b/drivers/media/v4l2-core/v4l2-jpeg.c
@@ -460,7 +460,7 @@ static int jpeg_parse_app14_data(struct jpeg_stream *stream,
 	/* Check for "Adobe\0" in Ap1..6 */
 	if (stream->curr + 6 > stream->end ||
 	    strncmp(stream->curr, "Adobe\0", 6))
-		return -EINVAL;
+		return jpeg_skip(stream, lp - 2);
 
 	/* get to Ap12 */
 	ret = jpeg_skip(stream, 11);
-- 
2.39.2



