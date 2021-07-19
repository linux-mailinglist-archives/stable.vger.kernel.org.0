Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6320C3CDFEA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345816AbhGSPMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343905AbhGSPKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC89A606A5;
        Mon, 19 Jul 2021 15:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709894;
        bh=akWJEMxAsxv5NtMBhCQHrv5cI+M+jQxWlXYXs7RetEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xczERFnxYGlo2ufEnSIBDxXelbBm9D/SNNcvNksKI3ZYI/E9wcq87DtMJ33HTPNdT
         gkS5r4AOOZzP9NpcxyOxLdWJ+AB7yboZpfdJj9IHqwo6rhufQLSoy7S01A3HNe2bPK
         G9s0Km9SX5LNnPEVMdm7AXpZZbD8SiwVIXsqWFnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 141/149] firmware: turris-mox-rwtm: report failures better
Date:   Mon, 19 Jul 2021 16:54:09 +0200
Message-Id: <20210719144934.680046621@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 72f99888944c44de1c899bbe44db1e53bdc9d994 ]

Report a notice level message if a command is not supported by the rWTM
firmware.

This should not be an error, merely a notice, because the firmware can
be used on boards that do not have manufacturing information burned.

Fixes: 389711b37493 ("firmware: Add Turris Mox rWTM firmware driver")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/turris-mox-rwtm.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index ecc9e2de6492..e22ad73d4c86 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -191,11 +191,14 @@ static int mox_get_board_info(struct mox_rwtm *rwtm)
 		return ret;
 
 	ret = mox_get_status(MBOX_CMD_BOARD_INFO, reply->retval);
-	if (ret < 0 && ret != -ENODATA) {
-		return ret;
-	} else if (ret == -ENODATA) {
+	if (ret == -ENODATA) {
 		dev_warn(rwtm->dev,
 			 "Board does not have manufacturing information burned!\n");
+	} else if (ret == -ENOSYS) {
+		dev_notice(rwtm->dev,
+			   "Firmware does not support the BOARD_INFO command\n");
+	} else if (ret < 0) {
+		return ret;
 	} else {
 		rwtm->serial_number = reply->status[1];
 		rwtm->serial_number <<= 32;
@@ -224,10 +227,13 @@ static int mox_get_board_info(struct mox_rwtm *rwtm)
 		return ret;
 
 	ret = mox_get_status(MBOX_CMD_ECDSA_PUB_KEY, reply->retval);
-	if (ret < 0 && ret != -ENODATA) {
-		return ret;
-	} else if (ret == -ENODATA) {
+	if (ret == -ENODATA) {
 		dev_warn(rwtm->dev, "Board has no public key burned!\n");
+	} else if (ret == -ENOSYS) {
+		dev_notice(rwtm->dev,
+			   "Firmware does not support the ECDSA_PUB_KEY command\n");
+	} else if (ret < 0) {
+		return ret;
 	} else {
 		u32 *s = reply->status;
 
-- 
2.30.2



