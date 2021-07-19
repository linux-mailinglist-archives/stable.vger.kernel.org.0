Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D265F3CDFE6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345791AbhGSPMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245550AbhGSPKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C146601FD;
        Mon, 19 Jul 2021 15:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709891;
        bh=NvV02mpsXpNnAufUF1CImLF3Rt/ztiUzL2sA8jWiPRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nb6iSpXgK4jSxGtV6G2eI17MAnOPyJXpHXiSFRNpUfcmjw5UphPdoNPZsPfdS33KE
         +A88xL0uWCY71vgWJ6DGULlPiMGY6tOROxL2894HwsbyCx0t4zT+3HTne0FWhFDJRh
         zPeiXEy/kY3/g1bG5KqDauGHlBg+6caFfMwQMDYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/149] firmware: turris-mox-rwtm: fix reply status decoding function
Date:   Mon, 19 Jul 2021 16:54:08 +0200
Message-Id: <20210719144934.460147984@linuxfoundation.org>
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
index 72be58960e54..ecc9e2de6492 100644
--- a/drivers/firmware/turris-mox-rwtm.c
+++ b/drivers/firmware/turris-mox-rwtm.c
@@ -134,11 +134,14 @@ MOX_ATTR_RO(pubkey, "%s\n", pubkey);
 
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



