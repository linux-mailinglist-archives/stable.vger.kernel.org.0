Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C25C3C4C55
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbhGLHDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233721AbhGLHCg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37ABB61108;
        Mon, 12 Jul 2021 06:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073187;
        bh=RMOrC1frwt1UylxJ7TKcgEozTKZQbIES9glVwdgUp2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoSTW0xVuLiycbbB+rOTsjjKQkUmmYB0I7AINMeWVWSi7dAbr7wkP4EarJf6Q/HCv
         D9XwRXkq0Ni9y/DGjAWiwOdiD4bDQNig1rOXh47ohd02dEQxqEHD3Q32AwuAvbAAQQ
         ylkk8DeP3vzFc4Q6XmKzhELI57qSaM/kD1OO3iWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 155/700] media: bt878: do not schedule tasklet when it is not setup
Date:   Mon, 12 Jul 2021 08:03:58 +0200
Message-Id: <20210712060947.494102365@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



