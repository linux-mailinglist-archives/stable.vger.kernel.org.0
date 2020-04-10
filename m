Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7052F1A4134
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgDJDsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbgDJDsE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:48:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC55A2137B;
        Fri, 10 Apr 2020 03:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490484;
        bh=waxjwsUxMpAJQV3TodVhI9ljrf0utE6GoyP7N1UZFnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYVxAW3g9xPBnNZikz0T2jy/rWpH3ZmyR8U/ca376sItnnRgFJsTmMjZKe2pyvXXu
         HZZesHVC1IduKo1qiW3wnL+3qVZesP4ivAuij+C2XG6VYQvscIsbonDYvjyvVLU3J3
         8KaO4CHNNoGZVtfT1bO7/bh79t2sIUVLY/HKHrQk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ajay Gupta <ajayg@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 03/56] usb: ucsi: ccg: disable runtime pm during fw flashing
Date:   Thu,  9 Apr 2020 23:47:07 -0400
Message-Id: <20200410034800.8381-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034800.8381-1-sashal@kernel.org>
References: <20200410034800.8381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

[ Upstream commit 57a5e5f936be583d2c6cef3661c169e3ea4bf922 ]

Ucsi ppm is unregistered during fw flashing so disable
runtime pm also and reenable after fw flashing is completed
and ppm is re-registered.

Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20200217144913.55330-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index 3370b3fc37b10..bd374cea3ba6c 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -1032,6 +1032,7 @@ static int ccg_restart(struct ucsi_ccg *uc)
 		return status;
 	}
 
+	pm_runtime_enable(uc->dev);
 	return 0;
 }
 
@@ -1047,6 +1048,7 @@ static void ccg_update_firmware(struct work_struct *work)
 
 	if (flash_mode != FLASH_NOT_NEEDED) {
 		ucsi_unregister(uc->ucsi);
+		pm_runtime_disable(uc->dev);
 		free_irq(uc->irq, uc);
 
 		ccg_fw_update(uc, flash_mode);
-- 
2.20.1

