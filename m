Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1221B408F27
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242051AbhIMNkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243112AbhIMNiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:38:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22A52613CE;
        Mon, 13 Sep 2021 13:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539696;
        bh=54opRNZffh/YZmHEJUAs+p6fS++AsL+5onCIpjO2XTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyLpb4+mF+bYHWhKmdkqbArGO0vaWLf7nxOz5NNbWYVwK9Ug7KDxJ/PU57QWRSL0j
         3Fzsm+Ju6CkQNA96lcILodjizg7aXl90JT5/xInbO5efMs8tXByYdTjQ46MCtrBxw6
         wYSUMOcfFq4wvv9OwFoWZb6ftfexER4ttKN6D36Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/236] media: venus: venc: Fix potential null pointer dereference on pointer fmt
Date:   Mon, 13 Sep 2021 15:13:49 +0200
Message-Id: <20210913131104.578335783@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 09ea9719a423fc675d40dd05407165e161ea0c48 ]

Currently the call to find_format can potentially return a NULL to
fmt and the nullpointer is later dereferenced on the assignment of
pixmp->num_planes = fmt->num_planes.  Fix this by adding a NULL pointer
check and returning NULL for the failure case.

Addresses-Coverity: ("Dereference null return")

Fixes: aaaa93eda64b ("[media] media: venus: venc: add video encoder files")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/venc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 47246528ac7e..e2d0fd5eaf29 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -183,6 +183,8 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
+		if (!fmt)
+			return NULL;
 	}
 
 	pixmp->width = clamp(pixmp->width, frame_width_min(inst),
-- 
2.30.2



