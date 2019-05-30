Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC72EBB9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbfE3DPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730357AbfE3DPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:33 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F6FA24557;
        Thu, 30 May 2019 03:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186133;
        bh=wNIIGNdY+3Ff5ByT6wZINYkqc6SV4Xy+MelFjAUT/GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmHJmoDF9jErKUYofZgWa1vUzDHHkUg//l5ZDgbMMGj7B2LCyHvuQi9NrjV9fPY9G
         qIfFhyRXL9WBMArNG3qw0taTEXbPQ+7mc4M7fMnWory2Zvlr0uZzJKF2KOLfGQi1fd
         cIGizZ1a/oL5Kk1MejTwwe+NEDEB0enEa0EkQC3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 297/346] media: si2165: fix a missing check of return value
Date:   Wed, 29 May 2019 20:06:10 -0700
Message-Id: <20190530030555.908707442@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0ab34a08812a3334350dbaf69a018ee0ab3d2ddd ]

si2165_readreg8() may fail. Looking into si2165_readreg8(), we will find
that "val_tmp" will be an uninitialized value when regmap_read() fails.
"val_tmp" is then assigned to "val". So if si2165_readreg8() fails,
"val" will be a random value. Further use will lead to undefined
behaviors. The fix checks if si2165_readreg8() fails, and if so, returns
its error code upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Matthias Schwarzott <zzam@gentoo.org>
Tested-by: Matthias Schwarzott <zzam@gentoo.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/si2165.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index feacd8da421da..d55d8f169dca6 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -275,18 +275,20 @@ static u32 si2165_get_fe_clk(struct si2165_state *state)
 
 static int si2165_wait_init_done(struct si2165_state *state)
 {
-	int ret = -EINVAL;
+	int ret;
 	u8 val = 0;
 	int i;
 
 	for (i = 0; i < 3; ++i) {
-		si2165_readreg8(state, REG_INIT_DONE, &val);
+		ret = si2165_readreg8(state, REG_INIT_DONE, &val);
+		if (ret < 0)
+			return ret;
 		if (val == 0x01)
 			return 0;
 		usleep_range(1000, 50000);
 	}
 	dev_err(&state->client->dev, "init_done was not set\n");
-	return ret;
+	return -EINVAL;
 }
 
 static int si2165_upload_firmware_block(struct si2165_state *state,
-- 
2.20.1



