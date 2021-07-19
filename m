Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FB13CE3BA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbhGSPkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349112AbhGSPfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 424F660E0C;
        Mon, 19 Jul 2021 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711377;
        bh=X4R8njL5MKAV0dEdvOS42Ab4MCRqJX2J981Bla5RjiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpZu0Xh4qyznph8SjexLnL2P3dkJyDiE1HGBJvDFBKzu0IMHgcwtOq5Ri3VKgIbiK
         qKPALZGivOV5X/avg+qS5kMGDL7qFA3TNkJUjcc11Je1WJL0AD/tMWDM8jriQFwKXD
         R1hkmmAtM55IlCglwqy4sJPBBdMOZWzBh3LpiHOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 331/351] firmware: turris-mox-rwtm: fix reply status decoding function
Date:   Mon, 19 Jul 2021 16:54:37 +0200
Message-Id: <20210719144956.017603440@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit e34e60253d9272311831daed8a2d967cf80ca3dc ]

The status decoding function mox_get_status() currently contains an
incorrect check: if the error status is not MBOX_STS_SUCCESS, it always
returns -EIO, so the comparison to MBOX_STS_FAIL is never executed and
we don't get the actual error code sent by the firmware.

Fix this.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 389711b37493 ("firmware: Add Turris Mox rWTM firmware driver")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/turris-mox-rwtm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/turris-mox-rwtm.c b/drivers/firmware/turris-mox-rwtm.c
index 62f0d1a5dd32..f85acdb3130c 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -147,11 +147,14 @@ MOX_ATTR_RO(pubkey, "%s\n", pubkey);
 
 static int mox_get_status(enum mbox_cmd cmd, u32 retval)
 {
-	if (MBOX_STS_CMD(retval) != cmd ||
-	    MBOX_STS_ERROR(retval) != MBOX_STS_SUCCESS)
+	if (MBOX_STS_CMD(retval) != cmd)
 		return -EIO;
 	else if (MBOX_STS_ERROR(retval) == MBOX_STS_FAIL)
 		return -(int)MBOX_STS_VALUE(retval);
+	else if (MBOX_STS_ERROR(retval) == MBOX_STS_BADCMD)
+		return -ENOSYS;
+	else if (MBOX_STS_ERROR(retval) != MBOX_STS_SUCCESS)
+		return -EIO;
 	else
 		return MBOX_STS_VALUE(retval);
 }
-- 
2.30.2



