Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4245213E49F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389718AbgAPRJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:09:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:45898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389714AbgAPRJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7789D206D9;
        Thu, 16 Jan 2020 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194577;
        bh=nHsaHORAAIrn4V6ey3gogkCaLw6Zk+kGN7xxnfo8EpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTQm/SOC/E4XtKSlnWJqQ3jwdeRVcIQxkHqmQ//JU4f4HabY/KWguAtq311Ye8QQI
         VBl+kaL4ZsNgI3QVVAawL86yxfGGPTXr3cDOEHEpXXjSQe9zPke+J3q3OGpx+NQmCU
         xsYtHBTgMrXn3GeNFHTbFAE97iYT5PIuvFkDKfWI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eddie James <eajames@linux.ibm.com>, Joel Stanley <joel@jms.id.au>,
        Alistair Popple <alistair@popple.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsi@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 452/671] fsi: sbefifo: Don't fail operations when in SBE IPL state
Date:   Thu, 16 Jan 2020 12:01:30 -0500
Message-Id: <20200116170509.12787-189-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 7ce98fb6c53d2311b3e9faae90b1a9c1a96534db ]

SBE fifo operations should be allowed while the SBE is in any of the
"IPL" states. Operations should succeed in this state.

Fixes: 9f4a8a2d7f9d fsi/sbefifo: Add driver for the SBE FIFO
Reviewed-by: Joel Stanley <joel@jms.id.au>
Tested-by: Alistair Popple <alistair@popple.id.au>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/1561575415-3282-1-git-send-email-eajames@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-sbefifo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/fsi/fsi-sbefifo.c b/drivers/fsi/fsi-sbefifo.c
index ae861342626e..9fa3959e0855 100644
--- a/drivers/fsi/fsi-sbefifo.c
+++ b/drivers/fsi/fsi-sbefifo.c
@@ -289,11 +289,11 @@ static int sbefifo_check_sbe_state(struct sbefifo *sbefifo)
 	switch ((sbm & CFAM_SBM_SBE_STATE_MASK) >> CFAM_SBM_SBE_STATE_SHIFT) {
 	case SBE_STATE_UNKNOWN:
 		return -ESHUTDOWN;
+	case SBE_STATE_DMT:
+		return -EBUSY;
 	case SBE_STATE_IPLING:
 	case SBE_STATE_ISTEP:
 	case SBE_STATE_MPIPL:
-	case SBE_STATE_DMT:
-		return -EBUSY;
 	case SBE_STATE_RUNTIME:
 	case SBE_STATE_DUMP: /* Not sure about that one */
 		break;
-- 
2.20.1

