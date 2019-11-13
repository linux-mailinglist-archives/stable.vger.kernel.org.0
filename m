Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB1FA4E8
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfKMBzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbfKMBzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFF0B222CD;
        Wed, 13 Nov 2019 01:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610108;
        bh=omDMWs7oiMbcZbsR6yFJC92lzmGq0/GwmcRPEeaGxKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvu1CRB66BCA1qVPVKg/LxQ3hfQOYrZNBA428VgY2vleJWdS5ByGts0AnVVf1P6Q1
         OTbdVrmcpmZJJZqatIIPAiNWmZSkaBtaCBZ7MvTACvsUJx8EFU84v+0pO6qbncryvH
         Dgujz9NUbw9520pHWA72ZRPqBq3+FhxYx9lQ6ZAU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 166/209] media: venus: vdec: fix decoded data size
Date:   Tue, 12 Nov 2019 20:49:42 -0500
Message-Id: <20191113015025.9685-166-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vikash Garodia <vgarodia@codeaurora.org>

[ Upstream commit ce32c0a530bd955206fe45c2eff77e581202d699 ]

Existing code returns the max of the decoded size and buffer size.
It turns out that buffer size is always greater due to hardware
alignment requirement. As a result, payload size given to client
is incorrect. This change ensures that the bytesused is assigned
to actual payload size, when available.

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index dfbbbf0f746f9..e40fdf97b0f03 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -888,8 +888,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 		unsigned int opb_sz = venus_helper_get_opb_size(inst);
 
 		vb = &vbuf->vb2_buf;
-		vb->planes[0].bytesused =
-			max_t(unsigned int, opb_sz, bytesused);
+		vb2_set_plane_payload(vb, 0, bytesused ? : opb_sz);
 		vb->planes[0].data_offset = data_offset;
 		vb->timestamp = timestamp_us * NSEC_PER_USEC;
 		vbuf->sequence = inst->sequence_cap++;
-- 
2.20.1

