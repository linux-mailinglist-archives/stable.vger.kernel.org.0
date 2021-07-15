Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5A3CA79B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhGOSzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:55:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242195AbhGOSyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:54:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C663613CA;
        Thu, 15 Jul 2021 18:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375120;
        bh=vrWCRUN54XIlnAEmBXlL3XZX3sR5uelmfCjCD5jFokg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuhtJtcFJzPC4KRemse/ZwGG4XMkbmLqR9HxUkXWlcuZulXV4pX8LDV4gIahs8eFO
         yuNXh6LtfpTYUUi36XcAZAcjFgXQr8TOH5tjYbnKPmnb74HpcFLj9YQmQZ1C0qWLh4
         IJ/YjAgKkVfdjzCR2LVqTKOpGSmiLjoB8nSBxOgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 168/215] mmc: core: clear flags before allowing to retune
Date:   Thu, 15 Jul 2021 20:39:00 +0200
Message-Id: <20210715182629.279205806@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit 77347eda64ed5c9383961d1de9165f9d0b7d8df6 upstream.

It might be that something goes wrong during tuning so the MMC core will
immediately trigger a retune. In our case it was:

 - we sent a tuning block
 - there was an error so we need to send an abort cmd to the eMMC
 - the abort cmd had a CRC error
 - retune was set by the MMC core

This lead to a vicious circle causing a performance regression of 75%.
So, clear retuning flags before we enable retuning to start with a known
cleared state.

Reported-by Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Fixes: bd11e8bd03ca ("mmc: core: Flag re-tuning is needed on CRC errors")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210624151616.38770-2-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -936,11 +936,14 @@ int mmc_execute_tuning(struct mmc_card *
 
 	err = host->ops->execute_tuning(host, opcode);
 
-	if (err)
+	if (err) {
 		pr_err("%s: tuning execution failed: %d\n",
 			mmc_hostname(host), err);
-	else
+	} else {
+		host->retune_now = 0;
+		host->need_retune = 0;
 		mmc_retune_enable(host);
+	}
 
 	return err;
 }


