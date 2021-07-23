Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6193D328D
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbhGWDRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233769AbhGWDRH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D3FC60E9C;
        Fri, 23 Jul 2021 03:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012661;
        bh=bNmhk1dCWlP014YFke38+oz54ZQ9+wuW83V6snIsmYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTjpURdeBsbO0jTvi7CCpGwCisKDtZyhWM3IkLVOoJdqHRkZNhlGFxiszynvSzfs0
         WZjkt7XV3SNlsqDckmWRtPZJchO6P1OlLQu22c0FCrioiKIg4jl91UA+BhVuLKFGZ5
         aPrU7cHV7N4J72IU880x1Jf8pJvHQknwYDmA2e3YyO4WViY8CluagBuydIv/yEIVU0
         +pL30vADTyTNOz+kjEBq8K12BnYGSOVVUfXtpYhQt38ZAc4bacJGIcwvh7tvy1ZlKe
         Y5RdChjf6p1ksn4Eab7NJWKQo5SjXgOILogLAzk0BM7mLx3Lo0zidjNYxEXoELdwFT
         97v4vw+r7YWCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 14/19] firmware: arm_scmi: Fix possible scmi_linux_errmap buffer overflow
Date:   Thu, 22 Jul 2021 23:57:15 -0400
Message-Id: <20210723035721.531372-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035721.531372-1-sashal@kernel.org>
References: <20210723035721.531372-1-sashal@kernel.org>
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
index 66eb3f0e5daf..ce81ed053876 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -47,7 +47,6 @@ enum scmi_error_codes {
 	SCMI_ERR_GENERIC = -8,	/* Generic Error */
 	SCMI_ERR_HARDWARE = -9,	/* Hardware Error */
 	SCMI_ERR_PROTOCOL = -10,/* Protocol Error */
-	SCMI_ERR_MAX
 };
 
 /* List of all SCMI devices active in system */
@@ -166,8 +165,10 @@ static const int scmi_linux_errmap[] = {
 
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

