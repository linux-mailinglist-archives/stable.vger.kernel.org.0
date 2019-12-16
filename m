Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F6512141D
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfLPSIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730124AbfLPSIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:08:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50DF22072B;
        Mon, 16 Dec 2019 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519698;
        bh=WSQUyA0Xex8fQZML6qSyOtUq3dH3w80jNaQVKkPJlGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rwj56AhjRoAm82EyChkHZybxpWeVqYs4X7hevkhvaTBoRWKx50sLfpURYRBWrvVAO
         VHU2cPyjdNQgoH7f0BbOIamZmNSBB1FaRWX59ant++oFWvw2bmUkHd4JViMr8STnxz
         ytrcjuKv2tuX7JeAb1asdSyAn1n/vsSY4CYktsPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.3 007/180] media: venus: remove invalid compat_ioctl32 handler
Date:   Mon, 16 Dec 2019 18:47:27 +0100
Message-Id: <20191216174807.376288047@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 4adc0423de92cf850d1ef5c0e7cb28fd7a38219e upstream.

v4l2_compat_ioctl32() is the function that calls into
v4l2_file_operations->compat_ioctl32(), so setting that back to the same
function leads to a trivial endless loop, followed by a kernel
stack overrun.

Remove the incorrect assignment.

Cc: stable@vger.kernel.org
Fixes: 7472c1c69138 ("[media] media: venus: vdec: add video decoder files")
Fixes: aaaa93eda64b ("[media] media: venus: venc: add video encoder files")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/qcom/venus/vdec.c |    3 ---
 drivers/media/platform/qcom/venus/venc.c |    3 ---
 2 files changed, 6 deletions(-)

--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1104,9 +1104,6 @@ static const struct v4l2_file_operations
 	.unlocked_ioctl = video_ioctl2,
 	.poll = v4l2_m2m_fop_poll,
 	.mmap = v4l2_m2m_fop_mmap,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl32 = v4l2_compat_ioctl32,
-#endif
 };
 
 static int vdec_probe(struct platform_device *pdev)
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1230,9 +1230,6 @@ static const struct v4l2_file_operations
 	.unlocked_ioctl = video_ioctl2,
 	.poll = v4l2_m2m_fop_poll,
 	.mmap = v4l2_m2m_fop_mmap,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl32 = v4l2_compat_ioctl32,
-#endif
 };
 
 static int venc_probe(struct platform_device *pdev)


