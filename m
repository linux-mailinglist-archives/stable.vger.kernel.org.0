Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD7D405748
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357470AbhIINdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:33:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353807AbhIIM7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 283EE63263;
        Thu,  9 Sep 2021 11:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188723;
        bh=MkRrwpA1NkbgaRmTQtUIZgPFnFVbhsKD2oo50eySxws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1N9H+h04PHzGdIeg4hzCdCPzqhaMrPQ/mOdkGa7sFecKhvecOe5TTjOaFAOjEEK5
         W1gGbRreyNS7PnisSKZh9tHh/rfXBRzoq4mzIculI8ppcyJXZAyijd0HMezKBi0XIv
         khaMC4YmFjYZQECRBWW5eh4MD0myHRKksFmE+6e+MamLiOeUJHq0iPkskKgT/Plwhg
         eomCJhXP2JDTGmbfT7DUTgILdbSkNsRnGAVEYv8FR726WvYQ3AX/v/ezyV1hbcPIG2
         SNe39J3x2v9UFqjatJboth2AFFdHvGhI3xWN3DULPUjBRKOJOPoRJLKxhIypVmIjes
         iJzKY3QwFjvVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nishad Kamdar <nishadkamdar@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 62/74] mmc: core: Return correct emmc response in case of ioctl error
Date:   Thu,  9 Sep 2021 07:57:14 -0400
Message-Id: <20210909115726.149004-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishad Kamdar <nishadkamdar@gmail.com>

[ Upstream commit e72a55f2e5ddcfb3dce0701caf925ce435b87682 ]

When a read/write command is sent via ioctl to the kernel,
and the command fails, the actual error response of the emmc
is not sent to the user.

IOCTL read/write tests are carried out using commands
17 (Single BLock Read), 24 (Single Block Write),
18 (Multi Block Read), 25 (Multi Block Write)

The tests are carried out on a 64Gb emmc device. All of these
tests try to access an "out of range" sector address (0x09B2FFFF).

It is seen that without the patch the response received by the user
is not OUT_OF_RANGE error (R1 response 31st bit is not set) as per
JEDEC specification. After applying the patch proper response is seen.
This is because the function returns without copying the response to
the user in case of failure. This patch fixes the issue.

Hence, this memcpy is required whether we get an error response or not.
Therefor it is moved up from the current position up to immediately
after we have called mmc_wait_for_req().

The test code and the output of only the CMD17 is included in the
commit to limit the message length.

CMD17 (Test Code Snippet):
==========================
        printf("Forming CMD%d\n", opt_idx);
        /*  single block read */
        cmd.blksz = 512;
        cmd.blocks = 1;
        cmd.write_flag = 0;
        cmd.opcode = 17;
        //cmd.arg = atoi(argv[3]);
        cmd.arg = 0x09B2FFFF;
        /* Expecting response R1B */
        cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;

        memset(data, 0, sizeof(__u8) * 512);
        mmc_ioc_cmd_set_data(cmd, data);

        printf("Sending CMD%d: ARG[0x%08x]\n", opt_idx, cmd.arg);
        if(ioctl(fd, MMC_IOC_CMD, &cmd))
                perror("Error");

        printf("\nResponse: %08x\n", cmd.response[0]);

CMD17 (Output without patch):
=============================
test@test-LIVA-Z:~$ sudo ./mmc cmd_test /dev/mmcblk0 17
Entering the do_mmc_commands:Device: /dev/mmcblk0 nargs:4
Entering the do_mmc_commands:Device: /dev/mmcblk0 options[17, 0x09B2FFF]
Forming CMD17
Sending CMD17: ARG[0x09b2ffff]
Error: Connection timed out

Response: 00000000
(Incorrect response)

CMD17 (Output with patch):
==========================
test@test-LIVA-Z:~$ sudo ./mmc cmd_test /dev/mmcblk0 17
[sudo] password for test:
Entering the do_mmc_commands:Device: /dev/mmcblk0 nargs:4
Entering the do_mmc_commands:Device: /dev/mmcblk0 options[17, 09B2FFFF]
Forming CMD17
Sending CMD17: ARG[0x09b2ffff]
Error: Connection timed out

Response: 80000900
(Correct OUT_OF_ERROR response as per JEDEC specification)

Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20210824191726.8296-1-nishadkamdar@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 7b2bb32e3555..d1cc0fdbc51c 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -592,6 +592,7 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 	}
 
 	mmc_wait_for_req(card->host, &mrq);
+	memcpy(&idata->ic.response, cmd.resp, sizeof(cmd.resp));
 
 	if (cmd.error) {
 		dev_err(mmc_dev(card->host), "%s: cmd error %d\n",
@@ -641,8 +642,6 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 	if (idata->ic.postsleep_min_us)
 		usleep_range(idata->ic.postsleep_min_us, idata->ic.postsleep_max_us);
 
-	memcpy(&(idata->ic.response), cmd.resp, sizeof(cmd.resp));
-
 	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
 		/*
 		 * Ensure RPMB/R1B command has completed by polling CMD13
-- 
2.30.2

