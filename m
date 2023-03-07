Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F466AEB3A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjCGRll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231904AbjCGRlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:41:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AE0A6BCC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5DAF614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE68C433EF;
        Tue,  7 Mar 2023 17:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210643;
        bh=dUpq22EcPIUXhWVJWeCv7GvmWOePXscZy5LHRVYAUE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2q/AKNYmUASn2zqitQMLf1AeMYepZ9EofxIR9L+jAcJYt45eeC+Vml7pzvKqCPmNk
         tcDrH/5gg/iKpdLrgtwID4n/xDRHQjwNFYK4O0S7ONZgdn3yp9xDqTbNwPODD+Zqdp
         mf2wmtMEO12BaLF5bwvVUSXSObKLu/BrjvHDISfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0608/1001] media: amphion: correct the unspecified color space
Date:   Tue,  7 Mar 2023 17:56:20 +0100
Message-Id: <20230307170047.890239189@linuxfoundation.org>
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

[ Upstream commit 809060c8a357e020010dd8f797a5efd3c5432b13 ]

in the E.2.1 of Rec. ITU-T H.264 (06/2019),
0 of colour primaries is reserved, and 2 is unspecified.
driver can map V4L2_COLORSPACE_LAST to 0,
and map V4L2_COLORSPACE_DEFAULT to 2.

v4l2_xfer_func and v4l2_ycbcr_encoding are similar case.

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_color.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_color.c b/drivers/media/platform/amphion/vpu_color.c
index 80b9a53fd1c14..4ae435cbc5cda 100644
--- a/drivers/media/platform/amphion/vpu_color.c
+++ b/drivers/media/platform/amphion/vpu_color.c
@@ -17,7 +17,7 @@
 #include "vpu_helpers.h"
 
 static const u8 colorprimaries[] = {
-	0,
+	V4L2_COLORSPACE_LAST,
 	V4L2_COLORSPACE_REC709,         /*Rec. ITU-R BT.709-6*/
 	0,
 	0,
@@ -31,7 +31,7 @@ static const u8 colorprimaries[] = {
 };
 
 static const u8 colortransfers[] = {
-	0,
+	V4L2_XFER_FUNC_LAST,
 	V4L2_XFER_FUNC_709,             /*Rec. ITU-R BT.709-6*/
 	0,
 	0,
@@ -53,7 +53,7 @@ static const u8 colortransfers[] = {
 };
 
 static const u8 colormatrixcoefs[] = {
-	0,
+	V4L2_YCBCR_ENC_LAST,
 	V4L2_YCBCR_ENC_709,              /*Rec. ITU-R BT.709-6*/
 	0,
 	0,
-- 
2.39.2



