Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DAF3B6119
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhF1OcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234865AbhF1Oaf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:30:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01B0561CA0;
        Mon, 28 Jun 2021 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890418;
        bh=mQXANN3w5cpLmYEMqIngYVYU2dsvDwqsCtr/alL564U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIHz+C+po21/Y2ZzjNkZLBGaNQNMwml5wywpgr0vdinwEkSGK0z9+2zvD6IpGBxww
         ePZJ3TN+D2ssGm7qMSzpiOouokC86O+I76ee/uTmzup+18VrsoImQZr4leV2Ucc+Dg
         Yw9/o0cIDITyYTX8PhyCuWVkF4gg9adrnwW6Kcn5XkVBIeGup2jTQs8qS7wEEiQhrO
         B0sEzmnb5QuT7wCXydOaoY02x7p6bVmAwR7etQAUe7m4fogSfxbdjXBaLAFJvrcNFN
         zsKc+fGDV12re3v82J3si0KPOVGriEAedZsGZZudLNt1MY74BM/e7HiFUitOgy9vEP
         MIEROXU0CIhGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Hector Martin <marcan@marcan.st>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/101] i2c: i801: Ensure that SMBHSTSTS_INUSE_STS is cleared when leaving i801_access
Date:   Mon, 28 Jun 2021 10:25:25 -0400
Message-Id: <20210628142607.32218-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 065b6211a87746e196b56759a70c7851418dd741 ]

As explained in [0] currently we may leave SMBHSTSTS_INUSE_STS set,
thus potentially breaking ACPI/BIOS usage of the SMBUS device.

Seems patch [0] needs a little bit more of review effort, therefore
I'd suggest to apply a part of it as quick win. Just clearing
SMBHSTSTS_INUSE_STS when leaving i801_access() should fix the
referenced issue and leaves more time for discussing a more
sophisticated locking handling.

[0] https://www.spinics.net/lists/linux-i2c/msg51558.html

Fixes: 01590f361e94 ("i2c: i801: Instantiate SPD EEPROMs automatically")
Suggested-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Tested-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index e42b87e96f74..eab6fd6b890e 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -974,6 +974,9 @@ static s32 i801_access(struct i2c_adapter *adap, u16 addr,
 	}
 
 out:
+	/* Unlock the SMBus device for use by BIOS/ACPI */
+	outb_p(SMBHSTSTS_INUSE_STS, SMBHSTSTS(priv));
+
 	pm_runtime_mark_last_busy(&priv->pci_dev->dev);
 	pm_runtime_put_autosuspend(&priv->pci_dev->dev);
 	mutex_unlock(&priv->acpi_lock);
-- 
2.30.2

