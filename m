Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561FE40E7D2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbhIPRnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353979AbhIPRh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE03E63231;
        Thu, 16 Sep 2021 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811005;
        bh=2KRvm6aTvUu4pu1QHXu6z4YnVYGYLqDrbklMn0PN8Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zBxwcjdNIUTsb6E4/s2mZKyDenqvvl3wIMHmCPOfFt/xZN/VoXdn41HJYEhXs4P3E
         Vh57hfVkpF5f4aaBVcw9UfeIz5jU2W6+FDMAj4J0gQO7SoAtwo0O7ZyB9au6XAIwmC
         SyfkYpdB6O9QYwia2jm8kSZeIpa+ZQhy/Dcu7SeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishad Kamdar <nishadkamdar@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 349/432] mmc: core: Return correct emmc response in case of ioctl error
Date:   Thu, 16 Sep 2021 18:01:38 +0200
Message-Id: <20210916155822.651614739@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a9ad9f5fa949..c3ecec3f6ddc 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -518,6 +518,7 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 		return mmc_sanitize(card, idata->ic.cmd_timeout_ms);
 
 	mmc_wait_for_req(card->host, &mrq);
+	memcpy(&idata->ic.response, cmd.resp, sizeof(cmd.resp));
 
 	if (cmd.error) {
 		dev_err(mmc_dev(card->host), "%s: cmd error %d\n",
@@ -567,8 +568,6 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 	if (idata->ic.postsleep_min_us)
 		usleep_range(idata->ic.postsleep_min_us, idata->ic.postsleep_max_us);
 
-	memcpy(&(idata->ic.response), cmd.resp, sizeof(cmd.resp));
-
 	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
 		/*
 		 * Ensure RPMB/R1B command has completed by polling CMD13
-- 
2.30.2



