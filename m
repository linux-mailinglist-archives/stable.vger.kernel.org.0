Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1591977E8
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 11:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgC3JcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 05:32:16 -0400
Received: from www.linuxtv.org ([130.149.80.248]:51372 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727376AbgC3JcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 05:32:16 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jIqjl-00GL8a-PB; Mon, 30 Mar 2020 09:29:41 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 30 Mar 2020 09:28:18 +0000
Subject: [git:media_tree/master] media: venus: firmware: Ignore secure call error on first resume
To:     linuxtv-commits@linuxtv.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jIqjl-00GL8a-PB@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: firmware: Ignore secure call error on first resume
Author:  Stanimir Varbanov <stanimir.varbanov@linaro.org>
Date:    Wed Mar 4 11:09:49 2020 +0100

With the latest cleanup in qcom scm driver the secure monitor
call for setting the remote processor state returns EINVAL when
it is called for the first time and after another scm call
auth_and_reset. The error returned from scm call could be ignored
because the state transition is already done in auth_and_reset.

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/qcom/venus/firmware.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
index de6812fb55f4..8801a6a7543d 100644
--- a/drivers/media/platform/qcom/venus/firmware.c
+++ b/drivers/media/platform/qcom/venus/firmware.c
@@ -44,8 +44,14 @@ static void venus_reset_cpu(struct venus_core *core)
 
 int venus_set_hw_state(struct venus_core *core, bool resume)
 {
-	if (core->use_tz)
-		return qcom_scm_set_remote_state(resume, 0);
+	int ret;
+
+	if (core->use_tz) {
+		ret = qcom_scm_set_remote_state(resume, 0);
+		if (resume && ret == -EINVAL)
+			ret = 0;
+		return ret;
+	}
 
 	if (resume)
 		venus_reset_cpu(core);
