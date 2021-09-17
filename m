Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5093640EF6E
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242934AbhIQCgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242930AbhIQCfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C5D06113A;
        Fri, 17 Sep 2021 02:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846065;
        bh=O0WLU4mBqJ8Z7pDrUaFp5opU4oP9uzVp27uW3NDH0X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7WhHNnHpEQ89BufnY6AzCO7j1W5mUCm8/crASh5Tks4Yfdrr87PPvMmwYYbQF1d2
         GhVzafVzkfVBNfkU/SA5TMtSip1v+GWL+rMHNtbPpWdMoTL1ohz1bGm6v91Mr0JM2b
         4yn1k9SmIzQxE3rkv0NFMPPSdzRRhIhtsvmvG7WO3qwgKFdpIDgPt+LQNNxX2j5iZW
         m3oMj6kdRNexxuyTkKyZ8KcXVVUws67QucKDBUIosXzpTge5fO+nCmZ1nC2An/n0c2
         X45WGs5eIDmHoV6qDY4l0TpSMX83Y0xw394WB9YVZt3grQTUuT1Eena3dffjXsP3kA
         SIhLMS5Frqatw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, Christoph@vger.kernel.org,
        sagi@grimberg.me, kch@nvidia.com
Subject: [PATCH AUTOSEL 5.14 14/21] nvmet: fixup buffer overrun in nvmet_subsys_attr_serial()
Date:   Thu, 16 Sep 2021 22:33:08 -0400
Message-Id: <20210917023315.816225-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit f04064814c2a15c22ed9c803f9b634ef34f91092 ]

The serial number is copied into the buffer via memcpy_and_pad()
with the length NVMET_SN_MAX_SIZE. So when printing out we also
need to take just that length as anything beyond that will be
uninitialized.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 273555127188..fa88bf9cba4d 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1067,7 +1067,8 @@ static ssize_t nvmet_subsys_attr_serial_show(struct config_item *item,
 {
 	struct nvmet_subsys *subsys = to_subsys(item);
 
-	return snprintf(page, PAGE_SIZE, "%s\n", subsys->serial);
+	return snprintf(page, PAGE_SIZE, "%*s\n",
+			NVMET_SN_MAX_SIZE, subsys->serial);
 }
 
 static ssize_t
-- 
2.30.2

