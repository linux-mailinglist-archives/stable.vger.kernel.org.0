Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80DE323D8D
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbhBXNNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:13:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234888AbhBXNF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D67464F75;
        Wed, 24 Feb 2021 12:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171248;
        bh=h58OgRccbDxtyFA2G4IeO7kYsX2GyMKKHHc7TnjjtQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmTsGSrbbPGKVgYdqQ+VOXeiVnE8DInzTeob1Vh+8sHVDIBn4nJDIkghRg0ZwpcCB
         QfRmRIo6iSGB80sh330eqOuf2ayr/HFx5ntAk6v1MNAOxompYjtxYphnLAYJhD48NQ
         mkDI9ZVguWqoLXbGrG+Z+zpyXt/rW8gvjZlRpJVi1sDxv7XG4DKrYP/Nl1iW1dVmru
         ObCYCekiS6pe++HJmbBwX+TJI2m7oVCcPDbpycUcyiWPZA6z3gQ1zij4Pzh2jI7PW+
         SLXXpE97PCpRdMz5qWYuq9J/SfigZ2mgjeH32mfL4ec23NIEWCIFKgi+lWLg5EX+Gt
         AXMnA6VRWQ1WA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        syzbot+6d31bf169a8265204b8d@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/40] media: mceusb: sanity check for prescaler value
Date:   Wed, 24 Feb 2021 07:53:20 -0500
Message-Id: <20210224125340.483162-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125340.483162-1-sashal@kernel.org>
References: <20210224125340.483162-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit 9dec0f48a75e0dadca498002d25ef4e143e60194 ]

prescaler larger than 8 would mean the carrier is at most 152Hz,
which does not make sense for IR carriers.

Reported-by: syzbot+6d31bf169a8265204b8d@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/mceusb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index f9616158bcf44..ca8995595c028 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -701,11 +701,18 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, u8 *buf, int buf_len,
 				data[0], data[1]);
 			break;
 		case MCE_RSP_EQIRCFS:
+			if (!data[0] && !data[1]) {
+				dev_dbg(dev, "%s: no carrier", inout);
+				break;
+			}
+			// prescaler should make sense
+			if (data[0] > 8)
+				break;
 			period = DIV_ROUND_CLOSEST((1U << data[0] * 2) *
 						   (data[1] + 1), 10);
 			if (!period)
 				break;
-			carrier = (1000 * 1000) / period;
+			carrier = USEC_PER_SEC / period;
 			dev_dbg(dev, "%s carrier of %u Hz (period %uus)",
 				 inout, carrier, period);
 			break;
-- 
2.27.0

