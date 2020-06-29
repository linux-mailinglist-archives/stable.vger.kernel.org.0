Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364EC20DDFE
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgF2UVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732590AbgF2TZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D79A253FB;
        Mon, 29 Jun 2020 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445346;
        bh=cKDiOq3ZvzBhL2L6Dbu7KNUxFI/87qtPbFZqATkHA0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEneXf7G2vTAAX8/y4YypANxuac6oVy5hmEYuF5US9cZcdCxPTW0d+QAIRfKAjF+u
         aZ+gG/vbSLfVQgvknq14IvxhrTYWeBkOQb5r4AlZ2K8SnOeP2smd2Z68hl/oUxtQBv
         tc0vz32VOvmhZ2ef0YVKekKIXQv/zBjrmbM2+UiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Honza Petrous <jpetrous@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 104/191] media: stv6110: get rid of a srate dead code
Date:   Mon, 29 Jun 2020 11:38:40 -0400
Message-Id: <20200629154007.2495120-105-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 282996925b4d78f9795d176f7fb409281c98d56d upstream

The stv6110 has a weird code that checks if get_property
and set_property ioctls are defined. If they're, it initializes
a "srate" var from properties cache. Otherwise, it sets to
15MBaud, with won't make any sense.

Thankfully, it seems that someone else discovered the issue in
the past, as "srate" is currently not used anywhere!

So, get rid of that really weird dead code logic.

Reported-by: Honza Petrous <jpetrous@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/stv6110.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index 66a5a7f2295c0..93262b13c6447 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -263,11 +263,9 @@ static int stv6110_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 {
 	struct stv6110_priv *priv = fe->tuner_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 ret = 0x04;
 	u32 divider, ref, p, presc, i, result_freq, vco_freq;
 	s32 p_calc, p_calc_opt = 1000, r_div, r_div_opt = 0, p_val;
-	s32 srate;
 
 	dprintk("%s, freq=%d kHz, mclk=%d Hz\n", __func__,
 						frequency, priv->mclk);
@@ -278,13 +276,6 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 				((((priv->mclk / 1000000) - 16) & 0x1f) << 3);
 
 	/* BB_GAIN = db/2 */
-	if (fe->ops.set_property && fe->ops.get_property) {
-		srate = c->symbol_rate;
-		dprintk("%s: Get Frontend parameters: srate=%d\n",
-							__func__, srate);
-	} else
-		srate = 15000000;
-
 	priv->regs[RSTV6110_CTRL2] &= ~0x0f;
 	priv->regs[RSTV6110_CTRL2] |= (priv->gain & 0x0f);
 
-- 
2.25.1

