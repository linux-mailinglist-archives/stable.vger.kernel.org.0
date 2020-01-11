Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B947137E91
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgAKKLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbgAKKLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:11:20 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F6F4206DA;
        Sat, 11 Jan 2020 10:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737479;
        bh=9GiLoNbMM/tBdB11IAaadoOkT3QvFpk8aTjuRVKEeDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUmiyPJVzKLUjnX7rtXTE/GuS+AWWFquUFdQH5XaT7GREaqIIOV7ZoAAQ84+jb5sJ
         Un4bU78O50v350zP900KK+KCbM8jrQa/stDAGVC95nB7caBCiWfu4s48dmUsq4ZFRX
         YibjIhvTy4/iSPfBFxQy59gPaQRawYyFZ80UekN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Kappner <agk@godking.net>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Subject: [PATCH 4.14 46/62] mmc: core: Prevent bus reference leak in mmc_blk_init()
Date:   Sat, 11 Jan 2020 10:50:28 +0100
Message-Id: <20200111094851.228049308@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Kappner <agk@godking.net>

commit d0a0852b9f81cf5f793bf2eae7336ed40a1a1815 upstream.

Upon module load, mmc_block allocates a bus with bus_registeri() in
mmc_blk_init(). This reference never gets freed during module unload, which
leads to subsequent re-insertions of the module fails and a WARN() splat is
triggered.

Fix the bug by dropping the reference for the bus in mmc_blk_exit().

Signed-off-by: Alexander Kappner <agk@godking.net>
Fixes: 97548575bef3 ("mmc: block: Convert RPMB to a character device")
Cc: <stable@vger.kernel.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/block.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2904,6 +2904,7 @@ static void __exit mmc_blk_exit(void)
 	mmc_unregister_driver(&mmc_driver);
 	unregister_blkdev(MMC_BLOCK_MAJOR, "mmc");
 	unregister_chrdev_region(mmc_rpmb_devt, MAX_DEVICES);
+	bus_unregister(&mmc_rpmb_bus_type);
 }
 
 module_init(mmc_blk_init);


