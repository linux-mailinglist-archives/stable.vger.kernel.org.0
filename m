Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FAB378918
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbhEJLZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237934AbhEJLQf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48F8C6120D;
        Mon, 10 May 2021 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645105;
        bh=La/9fJdwqyHPxEgvbDSiDBg95HtLXgDRSNr+8j9RoYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikUgQTzCsKdPsjkwBQ0QYFM7RMHYHcNxkxpHqk/SSqT3J2zjomUxGDK+3yELRgSVI
         Wmqx2/dRg1s3KOq0KH34oKlr8AXrLyfjtuHAsV0G7GkkvvaEqSuPVnWch111CKSt5O
         s3gS0OaT/vU4PcjSLmcSd+mjgJww244YyOSiUrow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 355/384] media: venus: venc_ctrls: Change default header mode
Date:   Mon, 10 May 2021 12:22:24 +0200
Message-Id: <20210510102026.458021643@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

commit 39a6b9185d305d236bff625509ee63801b50301b upstream.

It is observed that on Venus v1 the default header-mode is producing
a bitstream which is not playble. Change the default header-mode to
joined with 1st frame.

Fixes: 002c22bd360e ("media: venus: venc: set inband mode property to FW.")
Cc: stable@vger.kernel.org # v5.12
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/venc_ctrls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/venus/venc_ctrls.c
+++ b/drivers/media/platform/qcom/venus/venc_ctrls.c
@@ -359,7 +359,7 @@ int venc_ctrl_init(struct venus_inst *in
 		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
 		~((1 << V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE) |
 		(1 << V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME)),
-		V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE);
+		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME);
 
 	v4l2_ctrl_new_std_menu(&inst->ctrl_handler, &venc_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,


