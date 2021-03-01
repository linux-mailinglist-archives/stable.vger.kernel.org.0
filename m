Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C03328A75
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbhCASRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238893AbhCASJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:09:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3C6665310;
        Mon,  1 Mar 2021 17:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620563;
        bh=STL845UrxJhNLm0e/zR40InxbvWZTFLt4lYcaQAfd+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhJaVv6x91juXoTGpIBnA6PV1D0QxkHteFnid7VXTA1gmMgUS7pf2BX+O6Mb6IeRz
         IOt8gQWUEvOneM7kxmd1ZRgwnYDOcC8RBnBIRYHzu9pazNaVPLw2KyipJ5E+bZz1xc
         B7+rIkjGazwUifHvFG71mo814AhSzorVd3qcJJ0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 197/775] media: mtk-vcodec: fix error return code in vdec_vp9_decode()
Date:   Mon,  1 Mar 2021 17:06:05 +0100
Message-Id: <20210301161211.378776692@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 4397efebf039be58e98c81a194a26100eba597bb ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: dea42fb79f4f ("media: mtk-vcodec: reset segment data then trig decoder")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
index 5ea153a685225..d9880210b2ab6 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
@@ -890,7 +890,8 @@ static int vdec_vp9_decode(void *h_vdec, struct mtk_vcodec_mem *bs,
 			memset(inst->seg_id_buf.va, 0, inst->seg_id_buf.size);
 
 			if (vsi->show_frame & BIT(2)) {
-				if (vpu_dec_start(&inst->vpu, NULL, 0)) {
+				ret = vpu_dec_start(&inst->vpu, NULL, 0);
+				if (ret) {
 					mtk_vcodec_err(inst, "vpu trig decoder failed");
 					goto DECODE_ERROR;
 				}
-- 
2.27.0



