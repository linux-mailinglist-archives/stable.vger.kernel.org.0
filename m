Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69C847FF2B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbhL0Pfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:35:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35842 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbhL0Pfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:35:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BEB6610D5;
        Mon, 27 Dec 2021 15:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B1CC36AE7;
        Mon, 27 Dec 2021 15:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619329;
        bh=QLq6F91EER/1J0U8IiJIRYSy5rZqtJRHtkFAV8eDHr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0EhbwYbJV7xHs9Z6OWG0PsPBQ5/0Xv4QjcYHB9ozBBPAVuoAQ99Sqlmd5zOhoa4F
         d7hR3bP1J9eUkL1FajsSpJVKW/tdkAOKk9BLhxvFZLOmsyaV/al5xqkdYILxGfp8fo
         Qb0omx+h7Ar9dP/5sWzfB9YkcyToHZ6PFuLU1XwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Cooper <alcooperx@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 33/47] mmc: core: Disable card detect during shutdown
Date:   Mon, 27 Dec 2021 16:31:09 +0100
Message-Id: <20211227151321.934865917@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 66c915d09b942fb3b2b0cb2f56562180901fba17 upstream.

It's seems prone to problems by allowing card detect and its corresponding
mmc_rescan() work to run, during platform shutdown. For example, we may end
up turning off the power while initializing a card, which potentially could
damage it.

To avoid this scenario, let's add ->shutdown_pre() callback for the mmc host
class device and then turn of the card detect from there.

Reported-by: Al Cooper <alcooperx@gmail.com>
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20211203141555.105351-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/core.c |    7 ++++++-
 drivers/mmc/core/core.h |    1 +
 drivers/mmc/core/host.c |    9 +++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -2364,7 +2364,7 @@ void mmc_start_host(struct mmc_host *hos
 	_mmc_detect_change(host, 0, false);
 }
 
-void mmc_stop_host(struct mmc_host *host)
+void __mmc_stop_host(struct mmc_host *host)
 {
 	if (host->slot.cd_irq >= 0) {
 		mmc_gpio_set_cd_wake(host, false);
@@ -2373,6 +2373,11 @@ void mmc_stop_host(struct mmc_host *host
 
 	host->rescan_disable = 1;
 	cancel_delayed_work_sync(&host->detect);
+}
+
+void mmc_stop_host(struct mmc_host *host)
+{
+	__mmc_stop_host(host);
 
 	/* clear pm flags now and let card drivers set them as needed */
 	host->pm_flags = 0;
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -69,6 +69,7 @@ static inline void mmc_delay(unsigned in
 
 void mmc_rescan(struct work_struct *work);
 void mmc_start_host(struct mmc_host *host);
+void __mmc_stop_host(struct mmc_host *host);
 void mmc_stop_host(struct mmc_host *host);
 
 void _mmc_detect_change(struct mmc_host *host, unsigned long delay,
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -76,9 +76,18 @@ static void mmc_host_classdev_release(st
 	kfree(host);
 }
 
+static int mmc_host_classdev_shutdown(struct device *dev)
+{
+	struct mmc_host *host = cls_dev_to_mmc_host(dev);
+
+	__mmc_stop_host(host);
+	return 0;
+}
+
 static struct class mmc_host_class = {
 	.name		= "mmc_host",
 	.dev_release	= mmc_host_classdev_release,
+	.shutdown_pre	= mmc_host_classdev_shutdown,
 	.pm		= MMC_HOST_CLASS_DEV_PM_OPS,
 };
 


