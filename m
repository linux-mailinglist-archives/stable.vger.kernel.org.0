Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4391A40EA
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgDJDqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbgDJDqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:46:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F68212CC;
        Fri, 10 Apr 2020 03:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490406;
        bh=idCS/o2KJWKLuG5YYj/PRV53FPx4L/x7Hh2m9+2AenI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVUk49vO0Tzai0p37Gmy8vRynYZPMDvlWRYSgqivmpU9PasEwgNFhaBtJCNMIp+rw
         iUUxAjXRsooaIl+Vs/235Vp8e7oCePfdNkid1CJ/xbs1jvWgB1oFG3Fju+bM87jwSk
         z1opBEiq1eYmD27sFyERs1GrFwGoDs56qXw7+6E0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 09/68] media: venus: hfi_parser: Ignore HEVC encoding for V1
Date:   Thu,  9 Apr 2020 23:45:34 -0400
Message-Id: <20200410034634.7731-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit c50cc6dc6c48300af63a6fbc71b647053c15fc80 ]

Some older MSM8916 Venus firmware versions also seem to indicate
support for encoding HEVC, even though they really can't.
This will lead to errors later because hfi_session_init() fails
in this case.

HEVC is already ignored for "dec_codecs", so add the same for
"enc_codecs" to make these old firmware versions work correctly.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c b/drivers/media/platform/qcom/venus/hfi_parser.c
index 2293d936e49ca..7f515a4b9bd12 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -181,6 +181,7 @@ static void parse_codecs(struct venus_core *core, void *data)
 	if (IS_V1(core)) {
 		core->dec_codecs &= ~HFI_VIDEO_CODEC_HEVC;
 		core->dec_codecs &= ~HFI_VIDEO_CODEC_SPARK;
+		core->enc_codecs &= ~HFI_VIDEO_CODEC_HEVC;
 	}
 }
 
-- 
2.20.1

