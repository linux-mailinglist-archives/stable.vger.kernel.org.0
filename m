Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157F53A0262
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbhFHTDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235701AbhFHTBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 711E06191D;
        Tue,  8 Jun 2021 18:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177881;
        bh=3Knt/p6gxjwP3rHduVf86R+bAs5epNkKlJqzv2gft4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnpburDvgekDvEbitYtdDw1AfLL0FEsrcX1jiwxpWafoREY8MYIYuJNYwAYU5JndQ
         QFvQS300tz0PpiBBsq/OFFPukOp6sWIB1N+pzLNxf+vaas2qHRnH8pq+R0fYVreOVH
         n8RsB43bsgP4yeRJzys3L6y/ApuxfAmk9ERKjGls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roja Rani Yarubandi <rojay@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 134/137] i2c: qcom-geni: Suspend and resume the bus during SYSTEM_SLEEP_PM ops
Date:   Tue,  8 Jun 2021 20:27:54 +0200
Message-Id: <20210608175946.913126731@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
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
@@ -702,6 +702,8 @@ static int __maybe_unused geni_i2c_suspe
 {
 	struct geni_i2c_dev *gi2c = dev_get_drvdata(dev);
 
+	i2c_mark_adapter_suspended(&gi2c->adap);
+
 	if (!gi2c->suspended) {
 		geni_i2c_runtime_suspend(dev);
 		pm_runtime_disable(dev);
@@ -711,8 +713,16 @@ static int __maybe_unused geni_i2c_suspe
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


