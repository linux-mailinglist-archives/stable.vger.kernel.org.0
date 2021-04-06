Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0E535545B
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 14:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243423AbhDFM57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 08:57:59 -0400
Received: from www.linuxtv.org ([130.149.80.248]:54916 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243430AbhDFM55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 08:57:57 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lTlHB-00EYkA-5p; Tue, 06 Apr 2021 12:57:49 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 06 Apr 2021 12:50:12 +0000
Subject: [git:media_tree/master] media: venus: hfi_parser: Don't initialize parser on v1
To:     linuxtv-commits@linuxtv.org
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        stable@vger.kernel.org,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lTlHB-00EYkA-5p@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: hfi_parser: Don't initialize parser on v1
Author:  Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date:    Sun Mar 7 12:16:03 2021 +0100

The Venus v1 behaves differently comparing with the other Venus
version in respect to capability parsing and when they are send
to the driver. So we don't need to initialize hfi parser for
multiple invocations like what we do for > v1 Venus versions.

Fixes: 10865c98986b ("media: venus: parser: Prepare parser for multiple invocations")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/qcom/venus/hfi_parser.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c b/drivers/media/platform/qcom/venus/hfi_parser.c
index 7263c0c32695..ce230974761d 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -277,8 +277,10 @@ u32 hfi_parser(struct venus_core *core, struct venus_inst *inst, void *buf,
 
 	parser_init(inst, &codecs, &domain);
 
-	core->codecs_count = 0;
-	memset(core->caps, 0, sizeof(core->caps));
+	if (core->res->hfi_version > HFI_VERSION_1XX) {
+		core->codecs_count = 0;
+		memset(core->caps, 0, sizeof(core->caps));
+	}
 
 	while (words_count) {
 		data = word + 1;
