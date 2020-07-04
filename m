Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5002144D7
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 12:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgGDK07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jul 2020 06:26:59 -0400
Received: from www.linuxtv.org ([130.149.80.248]:39228 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgGDK07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jul 2020 06:26:59 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jrfJT-0023h7-CA; Sat, 04 Jul 2020 10:22:27 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Sat, 04 Jul 2020 10:25:55 +0000
Subject: [git:media_tree/master] media: venus: fix multiple encoder crash
To:     linuxtv-commits@linuxtv.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jrfJT-0023h7-CA@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: fix multiple encoder crash
Author:  Mansur Alisha Shaik <mansur@codeaurora.org>
Date:    Fri May 1 08:28:00 2020 +0200

Currently we are considering the instances which are available
in core->inst list for load calculation in min_loaded_core()
function, but this is incorrect because by the time we call
decide_core() for second instance, the third instance not
filled yet codec_freq_data pointer.

Solve this by considering the instances whose session has started.

Cc: stable@vger.kernel.org # v5.7+
Fixes: 4ebf969375bc ("media: venus: introduce core selection")
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Mansur Alisha Shaik <mansur@codeaurora.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/qcom/venus/pm_helpers.c | 4 ++++
 1 file changed, 4 insertions(+)

---

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index abf93158857b..531e7a41658f 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -496,6 +496,10 @@ min_loaded_core(struct venus_inst *inst, u32 *min_coreid, u32 *min_load)
 	list_for_each_entry(inst_pos, &core->instances, list) {
 		if (inst_pos == inst)
 			continue;
+
+		if (inst_pos->state != INST_START)
+			continue;
+
 		vpp_freq = inst_pos->clk_data.codec_freq_data->vpp_freq;
 		coreid = inst_pos->clk_data.core_id;
 
