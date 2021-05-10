Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B799237897F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhEJLZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237967AbhEJLQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0561F61353;
        Mon, 10 May 2021 11:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645110;
        bh=/iQjd1ykf2bloP9F7xz47ROi+StHkNhizecZjYWQNVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sf25gloBSJWsGc2HggboZ/oniBMOUxjnr8Xew+k1DzMYlXLpyOCwWTVhKZbeuv/og
         NRmAgFOySgrD8jJyw9SUeJQSY/Ln0+bwgV+28qtySFbSCRlelznUQB58HETy5dWzOV
         vqKl6DMra6BoVJNBJeonLpElBVwlZ/cExlGDGtjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 357/384] media: venus: hfi_parser: Dont initialize parser on v1
Date:   Mon, 10 May 2021 12:22:26 +0200
Message-Id: <20210510102026.527362776@linuxfoundation.org>
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

commit 834124c596e2dddbbdba06620835710ccca32fd0 upstream.

The Venus v1 behaves differently comparing with the other Venus
version in respect to capability parsing and when they are send
to the driver. So we don't need to initialize hfi parser for
multiple invocations like what we do for > v1 Venus versions.

Fixes: 10865c98986b ("media: venus: parser: Prepare parser for multiple invocations")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_parser.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -277,8 +277,10 @@ u32 hfi_parser(struct venus_core *core,
 
 	parser_init(inst, &codecs, &domain);
 
-	core->codecs_count = 0;
-	memset(core->caps, 0, sizeof(core->caps));
+	if (core->res->hfi_version > HFI_VERSION_1XX) {
+		core->codecs_count = 0;
+		memset(core->caps, 0, sizeof(core->caps));
+	}
 
 	while (words_count) {
 		data = word + 1;


