Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372F1378914
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237619AbhEJLZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:25:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237839AbhEJLQS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:16:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D77FA6121E;
        Mon, 10 May 2021 11:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645103;
        bh=Xxto7Mn+feCmue7/GFmefvMv7poktspTATqO55nPEhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vs8RKTyIN0dpfd2MD6/m5KNhlNIWo5YD+MKAGZ6g354Vkks6Eb1oBhb+vpkh8NsNk
         6pom6/FZAng7yZNRmbrBg8sS6rwxMZAaOvaTy+5HvAlLZZgU1G6Igs8YngbgT6NvM2
         Ia3b5fnTMBbxK7VozyCzHNl5wpspAJ/nBV3NOMKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 354/384] media: venus: pm_helpers: Set opp clock name for v1
Date:   Mon, 10 May 2021 12:22:23 +0200
Message-Id: <20210510102026.425573254@linuxfoundation.org>
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

commit 3215887167af7db9af9fa23d61321ebfbd6ed6d3 upstream.

The rate of the core clock is set through devm_pm_opp_set_rate and
to avoid errors from it we have to set the name of the clock via
dev_pm_opp_set_clkname.

Fixes: 9a538b83612c ("media: venus: core: Add support for opp tables/perf voting")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/pm_helpers.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -279,7 +279,22 @@ set_freq:
 
 static int core_get_v1(struct venus_core *core)
 {
-	return core_clks_get(core);
+	int ret;
+
+	ret = core_clks_get(core);
+	if (ret)
+		return ret;
+
+	core->opp_table = dev_pm_opp_set_clkname(core->dev, "core");
+	if (IS_ERR(core->opp_table))
+		return PTR_ERR(core->opp_table);
+
+	return 0;
+}
+
+static void core_put_v1(struct venus_core *core)
+{
+	dev_pm_opp_put_clkname(core->opp_table);
 }
 
 static int core_power_v1(struct venus_core *core, int on)
@@ -296,6 +311,7 @@ static int core_power_v1(struct venus_co
 
 static const struct venus_pm_ops pm_ops_v1 = {
 	.core_get = core_get_v1,
+	.core_put = core_put_v1,
 	.core_power = core_power_v1,
 	.load_scale = load_scale_v1,
 };
@@ -368,6 +384,7 @@ static int venc_power_v3(struct device *
 
 static const struct venus_pm_ops pm_ops_v3 = {
 	.core_get = core_get_v1,
+	.core_put = core_put_v1,
 	.core_power = core_power_v1,
 	.vdec_get = vdec_get_v3,
 	.vdec_power = vdec_power_v3,


