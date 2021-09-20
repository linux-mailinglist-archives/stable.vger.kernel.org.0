Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9130411F8D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352839AbhITRmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348726AbhITRkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA6B161B4D;
        Mon, 20 Sep 2021 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157685;
        bh=oaM9gqEkDMFrfCAXnzQaMwhPjwbOtbUBM4CxGZCdwvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiLjVL6IzzHt72MLQXXVH0EDAuURa+gjHBHCrIS7N/6CT81QBC+2O6nQj8WvMUnl5
         BJsxUccLo0/f4SX7JVE+txeGGjzrowYNkj1DgGg60+dPtDO7LosXKfeSMGIeWdxSuY
         erArgrFrWuvTfnkIxqOdW3EldbDnLchTJWW9By/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/293] media: venus: venc: Fix potential null pointer dereference on pointer fmt
Date:   Mon, 20 Sep 2021 18:40:34 +0200
Message-Id: <20210920163935.727773001@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
index 420897241248..4197b311cff4 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -316,6 +316,8 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
+		if (!fmt)
+			return NULL;
 	}
 
 	pixmp->width = clamp(pixmp->width, frame_width_min(inst),
-- 
2.30.2



