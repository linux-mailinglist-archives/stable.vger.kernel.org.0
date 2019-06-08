Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661E339F44
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfFHLkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbfFHLj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:39:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB1DA214C6;
        Sat,  8 Jun 2019 11:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559993998;
        bh=Cc9QeE+vfVmX61/UnF1YtxWvha4NlWEhKtuGb1GNbSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLz6pnazXAWrnaf84A/vwPiXUnHTN1K6l36yKH8Zv43g+Ec5hLdYEFRX3BPEnvV31
         eV/PAK7bZAt4GImyxCDiTaM/R5jKBkbZNOPq93Ot6HGjyn6PGEH1qXw/j4K/eNT1Pt
         hFdo6qYBNi16B2ynDQ7Y13M5dxn2na1kE7UVWroY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.1 06/70] Staging: vc04_services: Fix a couple error codes
Date:   Sat,  8 Jun 2019 07:38:45 -0400
Message-Id: <20190608113950.8033-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ca4e4efbefbbdde0a7bb3023ea08d491f4daf9b9 ]

These are accidentally returning positive EINVAL instead of negative
-EINVAL.  Some of the callers treat positive values as success.

Fixes: 7b3ad5abf027 ("staging: Import the BCM2835 MMAL-based V4L2 camera driver.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/bcm2835-camera/controls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/controls.c b/drivers/staging/vc04_services/bcm2835-camera/controls.c
index a2c55cb2192a..52f3c4be5ff8 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/controls.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/controls.c
@@ -576,7 +576,7 @@ exit:
 				dev->colourfx.enable ? "true" : "false",
 				dev->colourfx.u, dev->colourfx.v,
 				ret, (ret == 0 ? 0 : -EINVAL));
-	return (ret == 0 ? 0 : EINVAL);
+	return (ret == 0 ? 0 : -EINVAL);
 }
 
 static int ctrl_set_colfx(struct bm2835_mmal_dev *dev,
@@ -600,7 +600,7 @@ static int ctrl_set_colfx(struct bm2835_mmal_dev *dev,
 		 "%s: After: mmal_ctrl:%p ctrl id:0x%x ctrl val:%d ret %d(%d)\n",
 			__func__, mmal_ctrl, ctrl->id, ctrl->val, ret,
 			(ret == 0 ? 0 : -EINVAL));
-	return (ret == 0 ? 0 : EINVAL);
+	return (ret == 0 ? 0 : -EINVAL);
 }
 
 static int ctrl_set_bitrate(struct bm2835_mmal_dev *dev,
-- 
2.20.1

