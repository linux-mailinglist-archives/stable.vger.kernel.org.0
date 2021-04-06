Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00EC355459
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243376AbhDFM57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 08:57:59 -0400
Received: from www.linuxtv.org ([130.149.80.248]:54914 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243426AbhDFM55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 08:57:57 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lTlHB-00EYjm-3c; Tue, 06 Apr 2021 12:57:49 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 06 Apr 2021 12:50:32 +0000
Subject: [git:media_tree/master] media: venus: hfi_parser: Check for instance after hfi platform get
To:     linuxtv-commits@linuxtv.org
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lTlHB-00EYjm-3c@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: hfi_parser: Check for instance after hfi platform get
Author:  Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date:    Sun Mar 7 12:17:27 2021 +0100

The inst function argument is != NULL only for Venus v1 and
we did not migrate v1 to a hfi_platform abstraction yet. So
check for instance != NULL only after hfi_platform_get returns
no error.

Fixes: e29929266be1 ("media: venus: Get codecs and capabilities from hfi platform")
Cc: stable@vger.kernel.org # v5.12
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/qcom/venus/hfi_parser.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c b/drivers/media/platform/qcom/venus/hfi_parser.c
index ce230974761d..5b8389b98299 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -235,13 +235,13 @@ static int hfi_platform_parser(struct venus_core *core, struct venus_inst *inst)
 	u32 enc_codecs, dec_codecs, count = 0;
 	unsigned int entries;
 
-	if (inst)
-		return 0;
-
 	plat = hfi_platform_get(core->res->hfi_version);
 	if (!plat)
 		return -EINVAL;
 
+	if (inst)
+		return 0;
+
 	if (plat->codecs)
 		plat->codecs(&enc_codecs, &dec_codecs, &count);
 
