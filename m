Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5921027FB76
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 10:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgJAI3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 04:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgJAI3N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 04:29:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1D6520739;
        Thu,  1 Oct 2020 08:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601540951;
        bh=T+VPl0a2kpy3leQnt8WFAgE0mdEC1GTw0sfhMyIKPis=;
        h=Subject:To:From:Date:From;
        b=uO06j53BiR3ya86jTq1/AHZec3lE1a6FC0koUqfILGh/mMcLy7pg7zwCc+LHRvABu
         g/oOynOKkdtxpo9LAJLXNc0HwBKPUEXemklPT+iwWFXhKA2rzu1YKQqohfFFcKVHk5
         JZA1qOYgX5rEJ8vk4oYv81kAJAOdDRJqwDBimpGk=
Subject: patch "serial: qcom_geni_serial: To correct QUP Version detection logic" added to tty-next
To:     parashar@codeaurora.org, akashast@codeaurora.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 01 Oct 2020 10:29:13 +0200
Message-ID: <16015409532185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: qcom_geni_serial: To correct QUP Version detection logic

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From c9ca43d42ed8d5fd635d327a664ed1d8579eb2af Mon Sep 17 00:00:00 2001
From: Paras Sharma <parashar@codeaurora.org>
Date: Wed, 30 Sep 2020 11:35:26 +0530
Subject: serial: qcom_geni_serial: To correct QUP Version detection logic

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
 drivers/tty/serial/qcom_geni_serial.c | 2 +-
 include/linux/qcom-geni-se.h          | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 8da2eb2d1090..291649f02821 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1000,7 +1000,7 @@ static void qcom_geni_serial_set_termios(struct uart_port *uport,
 	sampling_rate = UART_OVERSAMPLING;
 	/* Sampling rate is halved for IP versions >= 2.5 */
 	ver = geni_se_get_qup_hw_version(&port->se);
-	if (GENI_SE_VERSION_MAJOR(ver) >= 2 && GENI_SE_VERSION_MINOR(ver) >= 5)
+	if (ver >= QUP_SE_VERSION_2_5)
 		sampling_rate /= 2;
 
 	clk_rate = get_clk_div_rate(baud, sampling_rate, &clk_div);
diff --git a/include/linux/qcom-geni-se.h b/include/linux/qcom-geni-se.h
index 8f385fbe5a0e..1c31f26ccc7a 100644
--- a/include/linux/qcom-geni-se.h
+++ b/include/linux/qcom-geni-se.h
@@ -248,6 +248,9 @@ struct geni_se {
 #define GENI_SE_VERSION_MINOR(ver) ((ver & HW_VER_MINOR_MASK) >> HW_VER_MINOR_SHFT)
 #define GENI_SE_VERSION_STEP(ver) (ver & HW_VER_STEP_MASK)
 
+/* QUP SE VERSION value for major number 2 and minor number 5 */
+#define QUP_SE_VERSION_2_5                  0x20050000
+
 /*
  * Define bandwidth thresholds that cause the underlying Core 2X interconnect
  * clock to run at the named frequency. These baseline values are recommended
-- 
2.28.0


