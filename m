Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2CB2A1700
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgJaLtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:49:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgJaLme (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68C2206D5;
        Sat, 31 Oct 2020 11:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144554;
        bh=Py3exZaPTOyxbs/1mseBYlDqZei1FpyWXwSXtBTBpzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ploo/IxuKpwkK6Yzogf9LsqKyLOpVCQsvW1LDy+j++RbiXorsXwO7fpo5+92uxj8e
         8XdPEDMZxRYi3BBTOLUIQUGgqr2o2XC5H9YGuWzJ70535eki7MCUYgPFnVbelKg7EX
         2ad75W8iCIIf5kMpb/Vv17zASDiFvykvnWf8IJVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paras Sharma <parashar@codeaurora.org>,
        Akash Asthana <akashast@codeaurora.org>
Subject: [PATCH 5.8 63/70] serial: qcom_geni_serial: To correct QUP Version detection logic
Date:   Sat, 31 Oct 2020 12:36:35 +0100
Message-Id: <20201031113502.510767215@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paras Sharma <parashar@codeaurora.org>

commit c9ca43d42ed8d5fd635d327a664ed1d8579eb2af upstream.

For QUP IP versions 2.5 and above the oversampling rate is
halved from 32 to 16.

Commit ce734600545f ("tty: serial: qcom_geni_serial: Update
the oversampling rate") is pushed to handle this scenario.
But the existing logic is failing to classify QUP Version 3.0
into the correct group ( 2.5 and above).

As result Serial Engine clocks are not configured properly for
baud rate and garbage data is sampled to FIFOs from the line.

So, fix the logic to detect QUP with versions 2.5 and above.

Fixes: ce734600545f ("tty: serial: qcom_geni_serial: Update the oversampling rate")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Paras Sharma <parashar@codeaurora.org>
Reviewed-by: Akash Asthana <akashast@codeaurora.org>
Link: https://lore.kernel.org/r/1601445926-23673-1-git-send-email-parashar@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/qcom_geni_serial.c |    2 +-
 include/linux/qcom-geni-se.h          |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -954,7 +954,7 @@ static void qcom_geni_serial_set_termios
 	sampling_rate = UART_OVERSAMPLING;
 	/* Sampling rate is halved for IP versions >= 2.5 */
 	ver = geni_se_get_qup_hw_version(&port->se);
-	if (GENI_SE_VERSION_MAJOR(ver) >= 2 && GENI_SE_VERSION_MINOR(ver) >= 5)
+	if (ver >= QUP_SE_VERSION_2_5)
 		sampling_rate /= 2;
 
 	clk_rate = get_clk_div_rate(baud, sampling_rate, &clk_div);
--- a/include/linux/qcom-geni-se.h
+++ b/include/linux/qcom-geni-se.h
@@ -229,6 +229,9 @@ struct geni_se {
 #define GENI_SE_VERSION_MINOR(ver) ((ver & HW_VER_MINOR_MASK) >> HW_VER_MINOR_SHFT)
 #define GENI_SE_VERSION_STEP(ver) (ver & HW_VER_STEP_MASK)
 
+/* QUP SE VERSION value for major number 2 and minor number 5 */
+#define QUP_SE_VERSION_2_5                  0x20050000
+
 #if IS_ENABLED(CONFIG_QCOM_GENI_SE)
 
 u32 geni_se_get_qup_hw_version(struct geni_se *se);


