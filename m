Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB131364258
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhDSNIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232027AbhDSNIL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02BCE61246;
        Mon, 19 Apr 2021 13:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837659;
        bh=PK/f3piFEHR7+z6I+MB9xu8EuH+I9pjHhmHWLvhaCjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqC7spC3STYW5umcPMUSVS6BWOhi46CS/W4+0L61uuRYnI8YptgsvGFo5j9u8H1vB
         aUjnfz/sJJKw1HnpyQpUPdhNdvKhQ9R05x2deb21b/rfFrgHjbD4ARidZiHTk4rpqn
         mzV9hGY7MAL+8CtIKdoASLvNMjevcOZ6MdBgEjDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 001/122] AMD_SFH: Removed unused activecontrolstatus member from the amd_mp2_dev struct
Date:   Mon, 19 Apr 2021 15:04:41 +0200
Message-Id: <20210419130530.214973155@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a9e54f4b62dcfed4432a5a89b1cd5903737f6e83 ]

This value is only used once inside amd_mp2_get_sensor_num(),
so there is no need to store this in the amd_mp2_dev struct,
amd_mp2_get_sensor_num() can simple use a local variable for this.

Fixes: 4f567b9f8141 ("SFH: PCIe driver to add support of AMD sensor fusion hub")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Sandeep Singh <sandeep.singh@amd.com
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 6 ++++--
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.h | 1 -
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index dbac16641662..f3cdb4ea33da 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -76,9 +76,11 @@ void amd_stop_all_sensors(struct amd_mp2_dev *privdata)
 int amd_mp2_get_sensor_num(struct amd_mp2_dev *privdata, u8 *sensor_id)
 {
 	int activestatus, num_of_sensors = 0;
+	u32 activecontrolstatus;
+
+	activecontrolstatus = readl(privdata->mmio + AMD_P2C_MSG3);
+	activestatus = activecontrolstatus >> 4;
 
-	privdata->activecontrolstatus = readl(privdata->mmio + AMD_P2C_MSG3);
-	activestatus = privdata->activecontrolstatus >> 4;
 	if (ACEL_EN  & activestatus)
 		sensor_id[num_of_sensors++] = accel_idx;
 
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
index 8f8d19b2cfe5..489415f7c22c 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.h
@@ -61,7 +61,6 @@ struct amd_mp2_dev {
 	struct pci_dev *pdev;
 	struct amdtp_cl_data *cl_data;
 	void __iomem *mmio;
-	u32 activecontrolstatus;
 };
 
 struct amd_mp2_sensor_info {
-- 
2.30.2



