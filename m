Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB09106E6B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbfKVLEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:04:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731490AbfKVLEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:04:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0CB020659;
        Fri, 22 Nov 2019 11:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420641;
        bh=omDMWs7oiMbcZbsR6yFJC92lzmGq0/GwmcRPEeaGxKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOSOKxdAnSjPzjnIogXYwPgHC0y+m74DO2byflhGvPWlXg8xlQr6CxS4m36NyiYlf
         godrbU2KRqSjmhhOYnGWinUBJIRulS7/KCcbY+wzhARCwsN6BSSbbR6fe+IbRqChN0
         2U8fLZrvEFNofnGgZfkQdevqs4becMkyZMC3wTks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/220] media: venus: vdec: fix decoded data size
Date:   Fri, 22 Nov 2019 11:29:02 +0100
Message-Id: <20191122100925.580614080@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



