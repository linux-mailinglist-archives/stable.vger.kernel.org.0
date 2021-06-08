Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62B33A0158
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhFHSvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235165AbhFHStI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:49:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F03E661463;
        Tue,  8 Jun 2021 18:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177528;
        bh=Nop9Vx39Z+8pKW20rBUxFHd6dZwSS3Yu2xp4oxhpkOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTRDi2JqbS385HOH965lY+ZEZauElX5OOruIWUp2qUxqD5wipmWTSl+DPYdER7rTG
         jvGfM28bNL+8hEd8FLGXhGkcnO3UCGaVdM9JELh+GlBI9YaixHsvIk0e1apadd25eD
         qqhgLnuCbqyQwg/aGSNYISxZ4lzUfISv/XZNQyPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roja Rani Yarubandi <rojay@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.4 77/78] i2c: qcom-geni: Suspend and resume the bus during SYSTEM_SLEEP_PM ops
Date:   Tue,  8 Jun 2021 20:27:46 +0200
Message-Id: <20210608175937.863047645@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roja Rani Yarubandi <rojay@codeaurora.org>

commit 57648e860485de39c800a89f849fdd03c2d31d15 upstream.

Mark bus as suspended during system suspend to block the future
transfers. Implement geni_i2c_resume_noirq() to resume the bus.

Fixes: 37692de5d523 ("i2c: i2c-qcom-geni: Add bus driver for the Qualcomm GENI I2C controller")
Signed-off-by: Roja Rani Yarubandi <rojay@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-geni.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-qcom-geni.c
+++ b/drivers/i2c/busses/i2c-qcom-geni.c
@@ -685,6 +685,8 @@ static int __maybe_unused geni_i2c_suspe
 {
 	struct geni_i2c_dev *gi2c = dev_get_drvdata(dev);
 
+	i2c_mark_adapter_suspended(&gi2c->adap);
+
 	if (!gi2c->suspended) {
 		geni_i2c_runtime_suspend(dev);
 		pm_runtime_disable(dev);
@@ -694,8 +696,16 @@ static int __maybe_unused geni_i2c_suspe
 	return 0;
 }
 
+static int __maybe_unused geni_i2c_resume_noirq(struct device *dev)
+{
+	struct geni_i2c_dev *gi2c = dev_get_drvdata(dev);
+
+	i2c_mark_adapter_resumed(&gi2c->adap);
+	return 0;
+}
+
 static const struct dev_pm_ops geni_i2c_pm_ops = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(geni_i2c_suspend_noirq, NULL)
+	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(geni_i2c_suspend_noirq, geni_i2c_resume_noirq)
 	SET_RUNTIME_PM_OPS(geni_i2c_runtime_suspend, geni_i2c_runtime_resume,
 									NULL)
 };


