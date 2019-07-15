Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E16F69690
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733307AbfGOPFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 11:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387762AbfGOOGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:06:16 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40AFA21842;
        Mon, 15 Jul 2019 14:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199575;
        bh=lGlfXHAiLZJovgA4DCHybcCib4O3ArvHEh86TD1QZiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGIcFKVR5myEHxWQbdCi2YRJ2SwqHrikVO1pRIKyNDgiAehkvMXOCTrjSYkw/0ork
         Qz/B4y5v3c9scxcVdfmA51YBHSe/8HEsPnRFB6HtaG9KzmiDm9g7icRabPSek4BCiJ
         AU8Y/RAbYnrca1fL0a675agDhzszKLHK+LVJkR28=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shailendra Verma <shailendra.v@samsung.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.1 046/219] media: staging: media: davinci_vpfe: - Fix for memory leak if decoder initialization fails.
Date:   Mon, 15 Jul 2019 10:00:47 -0400
Message-Id: <20190715140341.6443-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shailendra Verma <shailendra.v@samsung.com>

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
index 510202a3b091..84cca18e3e9d 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -419,6 +419,9 @@ static int vpfe_open(struct file *file)
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

