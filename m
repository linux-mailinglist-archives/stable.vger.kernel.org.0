Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AC53BB173
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhGDXMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232070AbhGDXJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:09:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 702F661452;
        Sun,  4 Jul 2021 23:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440029;
        bh=RMOrC1frwt1UylxJ7TKcgEozTKZQbIES9glVwdgUp2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Epw8v9A3MiNHYL/pOwrSsGJdRddUrDk62S20NNCpjWWmsKyDRsmpi+xJxAiCvsTck
         nTTbkmwENOfDKPrPI4/YdNlR+9kkC6b3NJRrcGOvWw8fAVVtaAjIaOhgS6sanFW1g0
         fqGYq906iapfwkNKZOVhkkYn1S4VI/4yMPyieqO/w5+59imXwKNHOOhMhFGZYvaM10
         xLnHXMBNun/VNowdws3L2wySd24/mei5U/T0tk4vnB1usyFbYZayr0FzdJvGih54lJ
         ebkaL08SoJVzRAoEYQy9thIy8B2sHaDPahGjlEnkK0ClRQA9+9Y8dxmHPBOrihpEID
         TtYGGJ21F947A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 38/80] media: bt878: do not schedule tasklet when it is not setup
Date:   Sun,  4 Jul 2021 19:05:34 -0400
Message-Id: <20210704230616.1489200-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit a3a54bf4bddaecda8b5767209cfc703f0be2841d ]

There is a problem with the tasklet in bt878. bt->tasklet is set by
dvb-bt8xx.ko, and bt878.ko can be loaded independently.
In this case if interrupt comes it may cause null-ptr-dereference.
To solve this issue, we check if the tasklet is actually set before
calling tasklet_schedule.

[    1.750438] bt878(0): irq FDSR FBUS risc_pc=
[    1.750728] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    1.752969] RIP: 0010:0x0
[    1.757526] Call Trace:
[    1.757659]  <IRQ>
[    1.757770]  tasklet_action_common.isra.0+0x107/0x110
[    1.758041]  tasklet_action+0x22/0x30
[    1.758237]  __do_softirq+0xe0/0x29b
[    1.758430]  irq_exit_rcu+0xa4/0xb0
[    1.758618]  common_interrupt+0x8d/0xa0
[    1.758824]  </IRQ>

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/bt8xx/bt878.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index 78dd35c9b65d..7ca309121fb5 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -300,7 +300,8 @@ static irqreturn_t bt878_irq(int irq, void *dev_id)
 		}
 		if (astat & BT878_ARISCI) {
 			bt->finished_block = (stat & BT878_ARISCS) >> 28;
-			tasklet_schedule(&bt->tasklet);
+			if (bt->tasklet.callback)
+				tasklet_schedule(&bt->tasklet);
 			break;
 		}
 		count++;
-- 
2.30.2

