Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4C33D32AD
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 05:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbhGWDSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 23:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233995AbhGWDRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 23:17:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D602160F47;
        Fri, 23 Jul 2021 03:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627012685;
        bh=KMDVrAF8BCbBNUKIuAiS0V6cWP4flQUxVAPOTiBewzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvCpANedTREiAHvvJmye1CnUqfNdwskL4S/NfBkddvTJQJ1fZ+LPoe8q3ZmgvpI0C
         4q/3NcM5Fo6LSUgYOhwCxmlfPJA9aX5JTpJik98jxNi6lX3J3rTv8hGaHUpvQmZ1rT
         7d02ZRMr2KeQ3J5tUIscefdFtFmxEDv06JuGvGmOkD9ZXGqAOLrD95EqVL1U+1sn1O
         F6N/Skpkj8cY5SfPvehEI5NinZGfy7idjfawyA3nuFt2rYc/iYu3QQbuHZWZLZ9CBW
         FdsJm+l96cJlqam33LtEFpgUiNAsQACYd4Aw6E+m+1tJUOEOS6FVnnC+zarXu0N+zU
         mKi8EVIJglnTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 12/17] firmware: arm_scmi: Fix possible scmi_linux_errmap buffer overflow
Date:   Thu, 22 Jul 2021 23:57:43 -0400
Message-Id: <20210723035748.531594-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210723035748.531594-1-sashal@kernel.org>
References: <20210723035748.531594-1-sashal@kernel.org>
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
index 6b2ce3f28f7b..c396b1d9a3b7 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -43,7 +43,6 @@ enum scmi_error_codes {
 	SCMI_ERR_GENERIC = -8,	/* Generic Error */
 	SCMI_ERR_HARDWARE = -9,	/* Hardware Error */
 	SCMI_ERR_PROTOCOL = -10,/* Protocol Error */
-	SCMI_ERR_MAX
 };
 
 /* List of all SCMI devices active in system */
@@ -118,8 +117,10 @@ static const int scmi_linux_errmap[] = {
 
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

