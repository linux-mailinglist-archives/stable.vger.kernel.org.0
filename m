Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCE91ACA0E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731001AbgDPPaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633363AbgDPNnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:43:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28AA920732;
        Thu, 16 Apr 2020 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044604;
        bh=idCS/o2KJWKLuG5YYj/PRV53FPx4L/x7Hh2m9+2AenI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEH/Hx+KuGW5oivGsub5aiPzBsMdY0IEfJOMH0LiBvs1z74OlGdbNa6j1YXjDj6O4
         N/xNT7jBYMqQnMMTKRWYscuGw8L6Xc9fHVolbdBYjCHuvGnmQjaaoCsE/E3ywuK4qJ
         mq2ChIxtXCiu3+0Qv9Qy07ZuWzZ6ffyAFxaygZZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/232] media: venus: hfi_parser: Ignore HEVC encoding for V1
Date:   Thu, 16 Apr 2020 15:22:01 +0200
Message-Id: <20200416131319.579361414@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



