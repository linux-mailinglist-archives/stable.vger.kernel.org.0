Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB101C43B7
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbgEDSAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730575AbgEDSAy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:00:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D0F2078C;
        Mon,  4 May 2020 18:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615253;
        bh=w/JwMb7JVHqYplPPoNYvno00KImVTLDxu+5qtPyfeg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmlMd9JOYay/mzFcDxHYvxfiY1iR5LVyQjTQqQvsJuJSPqSlTWjchCAvonTD8ZWEn
         Gx9VIziShyDeraMFW48jLboF2p0pAYF5QR7h4sNyQtFKJ3JOSt1OXZnQ4uhiFHNkxz
         kF8BzWx5EJtL05NB4veNrFkzMvuURANKUJqYnrLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 08/26] mmc: sdhci-xenon: fix annoying 1.8V regulator warning
Date:   Mon,  4 May 2020 19:57:22 +0200
Message-Id: <20200504165444.563485569@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.494398840@linuxfoundation.org>
References: <20200504165442.494398840@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <marek.behun@nic.cz>

commit bb32e1987bc55ce1db400faf47d85891da3c9b9f upstream.

For some reason the Host Control2 register of the Xenon SDHCI controller
sometimes reports the bit representing 1.8V signaling as 0 when read
after it was written as 1. Subsequent read reports 1.

This causes the sdhci_start_signal_voltage_switch function to report
  1.8V regulator output did not become stable

When CONFIG_PM is enabled, the host is suspended and resumend many
times, and in each resume the switch to 1.8V is called, and so the
kernel log reports this message annoyingly often.

Do an empty read of the Host Control2 register in Xenon's
.voltage_switch method to circumvent this.

This patch fixes this particular problem on Turris MOX.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Fixes: 8d876bf472db ("mmc: sdhci-xenon: wait 5ms after set 1.8V...")
Cc: stable@vger.kernel.org # v4.16+
Link: https://lore.kernel.org/r/20200420080444.25242-1-marek.behun@nic.cz
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-xenon.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/mmc/host/sdhci-xenon.c
+++ b/drivers/mmc/host/sdhci-xenon.c
@@ -238,6 +238,16 @@ static void xenon_voltage_switch(struct
 {
 	/* Wait for 5ms after set 1.8V signal enable bit */
 	usleep_range(5000, 5500);
+
+	/*
+	 * For some reason the controller's Host Control2 register reports
+	 * the bit representing 1.8V signaling as 0 when read after it was
+	 * written as 1. Subsequent read reports 1.
+	 *
+	 * Since this may cause some issues, do an empty read of the Host
+	 * Control2 register here to circumvent this.
+	 */
+	sdhci_readw(host, SDHCI_HOST_CONTROL2);
 }
 
 static const struct sdhci_ops sdhci_xenon_ops = {


