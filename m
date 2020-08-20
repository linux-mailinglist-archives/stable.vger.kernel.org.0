Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E9724B2C8
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgHTJgy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgHTJgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:36:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B55052075E;
        Thu, 20 Aug 2020 09:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916213;
        bh=qSvUBKDi00WIyAyry/sv6rrACXvKCMoL036mv2tgZ7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twaGhq5pcbfFrgjJN4sEq33JRCSTbRfYHeZ/nx/IXIDhRxs35mp1UoNhxilwrUfgl
         OsWb/D8/+P8+HQhjA4+h65eTAajYkrOUrAncnlvYU93L3ErRoTOkMyjYhBqNG6fAs/
         eM/4Q4xdGyIxKQi6P2n3HrqAtVdHjJl1c9TKrc1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Mansur Alisha Shaik <mansur@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.7 049/204] media: venus: fix multiple encoder crash
Date:   Thu, 20 Aug 2020 11:19:06 +0200
Message-Id: <20200820091608.728610360@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansur Alisha Shaik <mansur@codeaurora.org>

commit e0eb34810113dbbf1ace57440cf48d514312a373 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/qcom/venus/pm_helpers.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -496,6 +496,10 @@ min_loaded_core(struct venus_inst *inst,
 	list_for_each_entry(inst_pos, &core->instances, list) {
 		if (inst_pos == inst)
 			continue;
+
+		if (inst_pos->state != INST_START)
+			continue;
+
 		vpp_freq = inst_pos->clk_data.codec_freq_data->vpp_freq;
 		coreid = inst_pos->clk_data.core_id;
 


