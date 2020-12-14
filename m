Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E982D9DD3
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395152AbgLNRgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502080AbgLNRfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:35:51 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zliua@micron.com>,
        Bean Huo <beanhuo@micron.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 27/36] mmc: block: Fixup condition for CMD13 polling for RPMB requests
Date:   Mon, 14 Dec 2020 18:28:11 +0100
Message-Id: <20201214172544.634468072@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
References: <20201214172543.302523401@linuxfoundation.org>
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
@@ -630,7 +630,7 @@ static int __mmc_blk_ioctl_cmd(struct mm
 
 	memcpy(&(idata->ic.response), cmd.resp, sizeof(cmd.resp));
 
-	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B)) {
+	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
 		/*
 		 * Ensure RPMB/R1B command has completed by polling CMD13
 		 * "Send Status".


