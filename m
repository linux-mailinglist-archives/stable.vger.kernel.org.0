Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA52E6679
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733172AbgL1QNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387541AbgL1NUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:20:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5938B22A84;
        Mon, 28 Dec 2020 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161609;
        bh=ioJolGDsEiRfj9kGkq4M0fg2pckBsmbqcey0JYHsZZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoZINvalRaJxcLn5gRSaQV1wBknHtvFl7suapAT83t7CdtdZSkGNXfdf5tIr1wwDO
         W/qXxhWIUb/8UeIPJWyxHlDl028umzyamyR3CEKEOxjzPtX6gW55One2P/3BcdjcG/
         LLdoVEKtlXSdiWDsTQOYdid7WuAiSXQ0Lo3op0DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zliua@micron.com>,
        Bean Huo <beanhuo@micron.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 020/346] mmc: block: Fixup condition for CMD13 polling for RPMB requests
Date:   Mon, 28 Dec 2020 13:45:39 +0100
Message-Id: <20201228124920.748053050@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

commit 6246d7c9d15aaff0bc3863f67900c6a6e6be921b upstream.

The CMD13 polling is needed for commands with R1B responses. In commit
a0d4c7eb71dd ("mmc: block: Add CMD13 polling for MMC IOCTLS with R1B
response"), the intent was to introduce this for requests targeted to the
RPMB partition. However, the condition to trigger the polling loop became
wrong, leading to unnecessary polling. Let's fix the condition to avoid
this.

Fixes: a0d4c7eb71dd ("mmc: block: Add CMD13 polling for MMC IOCTLS with R1B response")
Cc: stable@vger.kernel.org
Reported-by: Zhan Liu <zliua@micron.com>
Signed-off-by: Zhan Liu <zliua@micron.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Link: https://lore.kernel.org/r/20201202202320.22165-1-huobean@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -631,7 +631,7 @@ static int __mmc_blk_ioctl_cmd(struct mm
 
 	memcpy(&(idata->ic.response), cmd.resp, sizeof(cmd.resp));
 
-	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B)) {
+	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
 		/*
 		 * Ensure RPMB/R1B command has completed by polling CMD13
 		 * "Send Status".


