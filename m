Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB53B126C90
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfLSTEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729068AbfLSSq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:46:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5822222C2;
        Thu, 19 Dec 2019 18:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781216;
        bh=fNccwqWA+SRuS5QnXcv5KmJy7FvExzlUIFIQAkUaYT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVLnQebRz1Vh0+k8sQyMrvHajZ+H/ZQzVwgARxZQnuuzwkAW6/O3Cphugc8NLV+8c
         V/9il/9R6W+XFMJTp+xsdalRFp87CRhDmmU0yIrzdCufnQyScCCpQFrw1+kwEz6pVf
         9b0Sr5Mvf39kbqtymi9NSCvKLQF16y8zOGs9TMsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.9 131/199] media: bdisp: fix memleak on release
Date:   Thu, 19 Dec 2019 19:33:33 +0100
Message-Id: <20191219183222.299466691@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 11609a7e21f8cea42630350aa57662928fa4dc63 upstream.

If a process is interrupted while accessing the video device and the
device lock is contended, release() could return early and fail to free
related resources.

Note that the return value of the v4l2 release file operation is
ignored.

Fixes: 28ffeebbb7bd ("[media] bdisp: 2D blitter driver using v4l2 mem2mem framework")
Cc: stable <stable@vger.kernel.org>     # 4.2
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -651,8 +651,7 @@ static int bdisp_release(struct file *fi
 
 	dev_dbg(bdisp->dev, "%s\n", __func__);
 
-	if (mutex_lock_interruptible(&bdisp->lock))
-		return -ERESTARTSYS;
+	mutex_lock(&bdisp->lock);
 
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 


