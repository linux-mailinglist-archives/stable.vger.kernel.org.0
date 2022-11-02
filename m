Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB55615A1E
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiKBDZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKBDZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:25:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606A024962
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:25:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17A80B8205C
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CADAC433D6;
        Wed,  2 Nov 2022 03:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359498;
        bh=SdT3todHNvgD1zKgt1D90KfGhK406q4k0OY43WF3OVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyjZeV4hCg9eIByt+nR5IiV5tFQZkuD5gsPwgTbwgEQWnrOC/FFVgSrDQVLI4d9k2
         5sWL901/7YKqa9IjAX+9Js+Ds/1nbNYcHAiiIwQhNPfeLSny7ROBvsTbLuNQtEjtPc
         nYjVJDegTyO8ofPC4Ul4r2ZtA/qfcCI0/9Ap1jZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/64] media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check interlaced
Date:   Wed,  2 Nov 2022 03:34:16 +0100
Message-Id: <20221102022053.435538258@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 8da7f0976b9071b528c545008de9d10cc81883b1 ]

If it is a progressive (non-interlaced) format, then ignore the
interlaced timing values.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 7f68127fa11f ([media] videodev2.h: defines to calculate blanking and frame sizes)
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/videodev2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3210b3c82a4a..9c89429f3113 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1496,7 +1496,8 @@ struct v4l2_bt_timings {
 	((bt)->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
 #define V4L2_DV_BT_BLANKING_HEIGHT(bt) \
 	((bt)->vfrontporch + (bt)->vsync + (bt)->vbackporch + \
-	 (bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch)
+	 ((bt)->interlaced ? \
+	  ((bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch) : 0))
 #define V4L2_DV_BT_FRAME_HEIGHT(bt) \
 	((bt)->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
 
-- 
2.35.1



