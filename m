Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CFE498B1D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344518AbiAXTMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345976AbiAXTEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:04:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB83560010;
        Mon, 24 Jan 2022 19:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B116FC340E8;
        Mon, 24 Jan 2022 19:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051091;
        bh=S7ZEIWzMdk4Sc8mk01LSm9diY0irORwMdlm88oUPVS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcQgnORZX/03iGmftvoPct94vI+YfJTkR0RnQpuCH402oHGDybaBdnPYJW973Sw5x
         K8u++PV9RzV5SfF32SnVBdY5VtjnTrHJTjUJ2TY5mC04/ZvcfT9om2Dz8D/rVJf9XU
         w3EQpmk+rA8jIjS2nkUqCUv5JoemcqgE5tgwm45w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Schlabbach <robert_s@gmx.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 052/186] media: si2157: Fix "warm" tuner state detection
Date:   Mon, 24 Jan 2022 19:42:07 +0100
Message-Id: <20220124183938.804948234@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Schlabbach <robert_s@gmx.net>

[ Upstream commit a6441ea29cb2c9314654e093a1cd8020b9b851c8 ]

Commit e955f959ac52 ("media: si2157: Better check for running tuner in
init") completely broke the "warm" tuner detection of the si2157 driver
due to a simple endian error: The Si2157 CRYSTAL_TRIM property code is
0x0402 and needs to be transmitted LSB first. However, it was inserted
MSB first, causing the warm detection to always fail and spam the kernel
log with tuner initialization messages each time the DVB frontend
device was closed and reopened:

[  312.215682] si2157 16-0060: found a 'Silicon Labs Si2157-A30'
[  312.264334] si2157 16-0060: firmware version: 3.0.5
[  342.248593] si2157 16-0060: found a 'Silicon Labs Si2157-A30'
[  342.295743] si2157 16-0060: firmware version: 3.0.5
[  372.328574] si2157 16-0060: found a 'Silicon Labs Si2157-A30'
[  372.385035] si2157 16-0060: firmware version: 3.0.5

Also, the reinitializations were observed disturb _other_ tuners on
multi-tuner cards such as the Hauppauge WinTV-QuadHD, leading to missed
or errored packets when one of the other DVB frontend devices on that
card was opened.

Fix the order of the property code bytes to make the warm detection work
again, also reducing the tuner initialization message in the kernel log
to once per power-on, as well as fixing the interference with other
tuners.

Link: https://lore.kernel.org/linux-media/trinity-2a86eb9d-6264-4387-95e1-ba7b79a4050f-1638392923493@3c-app-gmx-bap03

Fixes: e955f959ac52 ("media: si2157: Better check for running tuner in init")
Reported-by: Robert Schlabbach <robert_s@gmx.net>
Signed-off-by: Robert Schlabbach <robert_s@gmx.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/tuners/si2157.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index c826997f54330..229fea019e99e 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -89,7 +89,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "\n");
 
 	/* Try to get Xtal trim property, to verify tuner still running */
-	memcpy(cmd.args, "\x15\x00\x04\x02", 4);
+	memcpy(cmd.args, "\x15\x00\x02\x04", 4);
 	cmd.wlen = 4;
 	cmd.rlen = 4;
 	ret = si2157_cmd_execute(client, &cmd);
-- 
2.34.1



