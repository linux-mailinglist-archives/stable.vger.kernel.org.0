Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2E5799B4
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387693AbfG2TYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388179AbfG2TYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:24:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA7D32070B;
        Mon, 29 Jul 2019 19:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428278;
        bh=CjlvBsiFhwAUEMeUHdDLO23FbcGoZf9Zz4/59VqwbkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQAyZFnSDf+bTRA5a2U8Lba7wB6ufsLmW2Qa/01HXXMqBeSt5WwheISWlofRr3JSG
         2pLgqbhSuB6cpGfhRIky5/nUcj7m5nnxZpxOjvpLVLeaOP8LMJJ1MnA2l/dAHzY+9n
         6buj0cDPp7rdd/4Pmpki3HzAriactJj2Ur76nAu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shailendra Verma <shailendra.v@samsung.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 026/293] media: staging: media: davinci_vpfe: - Fix for memory leak if decoder initialization fails.
Date:   Mon, 29 Jul 2019 21:18:37 +0200
Message-Id: <20190729190823.499575110@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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
index 155e8c758e4b..346e60d230f3 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -422,6 +422,9 @@ static int vpfe_open(struct file *file)
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



