Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342623D32C2
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhGWDSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233911AbhGWDRx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC72260ED7;
        Fri, 23 Jul 2021 03:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012707;
        bh=HhutYgOaa5z1eUJlqj32AP75dNC2FByMbDCKDQa5GlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEmjuq209D0OAVp35XoRAX5hn3aAIiPV5sW+3aNHGm3MBtpPmkowRA5Phdy1A0cqS
         26DGA3y2trNBJj7FE+jVJw8q6suwru/eMQfanjTZS5u6aCAbhWSc8S/kyIjDklZBrz
         n0nVjmTaiecxCFaPHOuLjiCGN0334oRW8+m/RGgyV6G2MNk4mrFuodNnoB/gVuvPIA
         1vo3sq6ZLWdYeZk52yW5jHLHyfp17fGqX2C/X17oK9kF28R/BU6FSDh9U1f0HxqpL1
         j4E2RSj9E1euwRpVN9dx5ikcIG29YZE6MwZjnNSl65yQaa6F0337jH8Iyg2FtDlyrA
         Yf1kv7D17Ru+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 09/14] firmware: arm_scmi: Fix possible scmi_linux_errmap buffer overflow
Date:   Thu, 22 Jul 2021 23:58:08 -0400
Message-Id: <20210723035813.531837-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035813.531837-1-sashal@kernel.org>
References: <20210723035813.531837-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 7a691f16ccad05d770f813d9c4b4337a30c6d63f ]

The scmi_linux_errmap buffer access index is supposed to depend on the
array size to prevent element out of bounds access. It uses SCMI_ERR_MAX
to check bounds but that can mismatch with the array size. It also
changes the success into -EIO though scmi_linux_errmap is never used in
case of success, it is expected to work for success case too.

It is slightly confusing code as the negative of the error code
is used as index to the buffer. Fix it by negating it at the start and
make it more readable.

Link: https://lore.kernel.org/r/20210707135028.1869642-1-sudeep.holla@arm.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 11078199abed..629f57795a9b 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -54,7 +54,6 @@ enum scmi_error_codes {
 	SCMI_ERR_GENERIC = -8,	/* Generic Error */
 	SCMI_ERR_HARDWARE = -9,	/* Hardware Error */
 	SCMI_ERR_PROTOCOL = -10,/* Protocol Error */
-	SCMI_ERR_MAX
 };
 
 /* List of all SCMI devices active in system */
@@ -176,8 +175,10 @@ static const int scmi_linux_errmap[] = {
 
 static inline int scmi_to_linux_errno(int errno)
 {
-	if (errno < SCMI_SUCCESS && errno > SCMI_ERR_MAX)
-		return scmi_linux_errmap[-errno];
+	int err_idx = -errno;
+
+	if (err_idx >= SCMI_SUCCESS && err_idx < ARRAY_SIZE(scmi_linux_errmap))
+		return scmi_linux_errmap[err_idx];
 	return -EIO;
 }
 
-- 
2.30.2

