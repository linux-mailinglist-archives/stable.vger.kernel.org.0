Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9A8EAC92
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 10:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfJaJf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 05:35:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38094 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbfJaJf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 05:35:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id w8so2465466plq.5
        for <stable@vger.kernel.org>; Thu, 31 Oct 2019 02:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DpBkpuyfEz89me+buFs+WwtT8XRjvBF3yFBftzqlsQk=;
        b=JdLYApaHHSdUFo4j1OUWJrbghTLy5sNyEB5YolVD7rb4pjkaCXORZ6YsgpbuJrlo/V
         tvEBmGb12tib+aqhP4RKjJlaJURPv05T12dWome0EoDMZk6g2GiuCOLpyreiYTFdP8bq
         +xMNuDjKk97ONXGcpxwQQ2atL3vymdgSlRC2fqUwrH3+/m605N+EH8wvpFfCfltDOyEh
         AlAVWF4FLDs9arQtYXkNFDNZyzLcnc68HEV4e5RUxtvpfuXI5feUTnUgM5YwuURQfidK
         W1Ct8JUM3rdyYYHN2IYoDYqXYZLhWkIn+uZ3HuSvTlU4m/K1RMEm/URF2xTfWTUYBXYx
         xciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DpBkpuyfEz89me+buFs+WwtT8XRjvBF3yFBftzqlsQk=;
        b=N8GG1hAerDs6X3uuNi77qNvhsWzGI0fiuiP9n0/+TmTSEFz3QlVfIwYWTxELwR9V1U
         oLEZh2DcmmiSDYM33tSyRuvYzBzH5aOs1ri9UswB0U7lVUombLdGSnuvF3ihE76rSb1A
         7LzbAM7zL0KHpPF3+LyufKhXu7onL2IU/+pTooLK8qENuerU7Wda/XFgGQUAGBLy+W5M
         6cMLdJzSFv4yhxNoEpBP/1gVYFJQ8KfyZTUMIU9u5mom+FfIGvJqlapCbk3hof4akh5c
         p6iNqHBkPSigZk1Qc3K5/A7ir9zeweI6aEqz4V2rA9MzKFMQhi3CBG6IRkCDRLZUNO2f
         p4TA==
X-Gm-Message-State: APjAAAWkD643EiSAeSXczazK13dKh5ElQ8SN1fCA9amPNBcx/oFLPO/v
        cMjetI4vDp5ime5O5GuP5UU3QQ==
X-Google-Smtp-Source: APXvYqwnFWHm7nPbOa+XzFm1q9aR2vjbqEZF/KUN16CVmZa8X1+clj8plDglCup4NMBtOxDqkW3Y3A==
X-Received: by 2002:a17:902:9347:: with SMTP id g7mr5320801plp.291.1572514557950;
        Thu, 31 Oct 2019 02:35:57 -0700 (PDT)
Received: from starnight.endlessm-sf.com (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id b23sm5240079pju.16.2019.10.31.02.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 02:35:57 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Jian-Hong Pan <jian-hong@endlessm.com>, stable@vger.kernel.org
Subject: [PATCH v2] Revert "nvme: Add quirk for Kingston NVME SSD running FW E8FK11.T"
Date:   Thu, 31 Oct 2019 17:34:09 +0800
Message-Id: <20191031093408.9322-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 253eaf4faaaa ("PCI/MSI: Fix incorrect MSI-X masking on
resume") is merged, we can revert the previous quirk now.

This reverts commit 19ea025e1d28c629b369c3532a85b3df478cc5c6.

Fixes: 19ea025e1d28 ("nvme: Add quirk for Kingston NVME SSD running FW E8FK11.T")
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204887
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: stable@vger.kernel.org
---
v2:
  Re-send for mailing failure

 drivers/nvme/host/core.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index fa7ba09dca77..94bfbee1e5f7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2404,16 +2404,6 @@ static const struct nvme_core_quirk_entry core_quirks[] = {
 		.vid = 0x14a4,
 		.fr = "22301111",
 		.quirks = NVME_QUIRK_SIMPLE_SUSPEND,
-	},
-	{
-		/*
-		 * This Kingston E8FK11.T firmware version has no interrupt
-		 * after resume with actions related to suspend to idle
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=204887
-		 */
-		.vid = 0x2646,
-		.fr = "E8FK11.T",
-		.quirks = NVME_QUIRK_SIMPLE_SUSPEND,
 	}
 };
 
-- 
2.23.0

