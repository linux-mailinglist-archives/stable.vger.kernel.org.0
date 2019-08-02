Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77EBE7F4AA
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730790AbfHBKGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 06:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390974AbfHBJbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:31:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE144217D6;
        Fri,  2 Aug 2019 09:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738259;
        bh=y/tFP1q6ez118d5g/w5ccfPqluyoGvl2LPmw7pO1EuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clDCEXECu1Tlob09B8vgsG/aKPYLpwb0VT4DasevdBCRoPQKEmohSX4QFUzMfSogQ
         6VryZXwS+3HesOVYzmWQ0y6813IUpGvOlnPwAy4MroYr/xTt60bu80n22lfRAcWRnA
         32FBtqNukO/9fwoNZfiOxXfyp1dcl0uoElzozrOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 017/158] media: staging: media: davinci_vpfe: - Fix for memory leak if decoder initialization fails.
Date:   Fri,  2 Aug 2019 11:27:18 +0200
Message-Id: <20190802092206.971621102@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6995a659101bd4effa41cebb067f9dc18d77520d ]

Fix to avoid possible memory leak if the decoder initialization
got failed.Free the allocated memory for file handle object
before return in case decoder initialization fails.

Signed-off-by: Shailendra Verma <shailendra.v@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 0fdff91624fd..43474f562b43 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -406,6 +406,9 @@ static int vpfe_open(struct file *file)
 	/* If decoder is not initialized. initialize it */
 	if (!video->initialized && vpfe_update_pipe_state(video)) {
 		mutex_unlock(&video->lock);
+		v4l2_fh_del(&handle->vfh);
+		v4l2_fh_exit(&handle->vfh);
+		kfree(handle);
 		return -ENODEV;
 	}
 	/* Increment device users counter */
-- 
2.20.1



