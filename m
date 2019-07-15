Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9A168C41
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbfGONuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731525AbfGONuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:50:22 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6980C2067C;
        Mon, 15 Jul 2019 13:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198620;
        bh=sNcdxI9uFkrxYRDNAh8DXHsfCzWHPhTy+f+d4yfvJZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yg0l77q82lf4g6nnW9SCVr7511c0ead7H84ss2Z5aRxQFtY/6uLo8b5s8Xj0ZLucb
         GOHgWIAmuDwppEqi+BGNqYyERTx7hyBRcWtQ9Nn7MPqp+pIQs+ALg5QjNlIFWjlfUU
         9KWe+yjQoW+ziDw9xI3i19PPKzo4OeZnIvGV+4GI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.2 062/249] media: platform: ao-cec-g12a: disable regmap fast_io for cec bus regmap
Date:   Mon, 15 Jul 2019 09:43:47 -0400
Message-Id: <20190715134655.4076-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit 9f7406d6b56b4b71a12480b68221755ea7b3e0ee ]

With fast_io enabled, spinlock_irq is used for read/write operations,
thus leading to :
BUG: sleeping function called from invalid context at [snip]/ao-cec-g12a.c:379
 in_atomic(): 1, irqs_disabled(): 128, pid: 1451, name: irq/14-ff800280
[snip]
Call trace:
 dump_backtrace+0x0/0x180
 show_stack+0x14/0x1c
 dump_stack+0xa8/0xe0
 ___might_sleep+0xf4/0x104
 __might_sleep+0x4c/0x80
 meson_ao_cec_g12a_read+0x7c/0x164
 regmap_read+0x16c/0x1b0
 meson_ao_cec_g12a_irq_thread+0xcc/0x200
 irq_thread_fn+0x2c/0x60
 irq_thread+0x14c/0x1fc
 kthread+0x11c/0x12c
 ret_from_fork+0x10/0x18

Simply remove fast_io to use mutexes instead.

Fixes: b7778c46683c ("media: platform: meson: Add Amlogic Meson G12A AO CEC Controller driver")

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/meson/ao-cec-g12a.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/meson/ao-cec-g12a.c b/drivers/media/platform/meson/ao-cec-g12a.c
index 3620a1e310f5..ddfd060625da 100644
--- a/drivers/media/platform/meson/ao-cec-g12a.c
+++ b/drivers/media/platform/meson/ao-cec-g12a.c
@@ -415,7 +415,6 @@ static const struct regmap_config meson_ao_cec_g12a_cec_regmap_conf = {
 	.reg_read = meson_ao_cec_g12a_read,
 	.reg_write = meson_ao_cec_g12a_write,
 	.max_register = 0xffff,
-	.fast_io = true,
 };
 
 static inline void
-- 
2.20.1

