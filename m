Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F873CD9E6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244822AbhGSOcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244695AbhGSO37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:29:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AD2760249;
        Mon, 19 Jul 2021 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707439;
        bh=4fA1DIJpHhuLpLOXmJLqpey2PRkp+EX8qRxl3w/HR0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mq9vFWjQSNO8Tzly+Klb2yjqNNzK/ke6+YAq3ld1E5FE+WO6wdfKp8IaUQgOcmWI3
         K5dueGj7kcu+/Bb/8H4HddaXCDpBrrw6l/Qz5RZ4ykkacjda+1TVfBALu2VLIyhtJH
         UeheDY55H+L6JicuRlEPJzHaraRy4dXJYr0WusJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.9 164/245] mmc: core: clear flags before allowing to retune
Date:   Mon, 19 Jul 2021 16:51:46 +0200
Message-Id: <20210719144945.715860992@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
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
@@ -1171,11 +1171,14 @@ int mmc_execute_tuning(struct mmc_card *
 
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


