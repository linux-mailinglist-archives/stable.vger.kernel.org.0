Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5271147B2C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732216AbgAXJl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:41:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731098AbgAXJl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:41:27 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E43120718;
        Fri, 24 Jan 2020 09:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858886;
        bh=a26bR0eyZ3OmcnnUGX2n20H33BxPG6gZJMNQPKVL05Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=La/pRA22jUtw6G91oVuZnfVOwWx/W1y+Wspa2+VURqRaZYFaO7j9zi9dNvT9mpSCA
         TNYOUL1VWVu1pPYJ6HSgr4WagvxJaPlqK5WXAQGAVn51Ue6JlYMDR652dR26O7zRUA
         SqtCAsNPam1Oqtn+bNZ3PY6/vZ29jinOgbaGfsPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wbob <wbob@jify.de>,
        Roman Yeryomin <roman@advem.lv>,
        Daniel Golle <daniel@makrotopia.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/102] rt2800: remove errornous duplicate condition
Date:   Fri, 24 Jan 2020 10:31:15 +0100
Message-Id: <20200124092817.829726960@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit a1f7c2cabf701a17b1a05d6526bbdadc3d05e05c ]

On 2019-10-28 06:07, wbob wrote:
> Hello Roman,
>
> while reading around drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> I stumbled on what I think is an edit of yours made in error in march
> 2017:
>
> https://github.com/torvalds/linux/commit/41977e86#diff-dae5dc10da180f3b055809a48118e18aR5281
>
> RT6352 in line 5281 should not have been introduced as the "else if"
> below line 5291 can then not take effect for a RT6352 device. Another
> possibility is for line 5291 to be not for RT6352, but this seems
> very unlikely. Are you able to clarify still after this substantial time?
>
> 5277: static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
> ...
> 5279:  } else if (rt2x00_rt(rt2x00dev, RT5390) ||
> 5280:         rt2x00_rt(rt2x00dev, RT5392) ||
> 5281:         rt2x00_rt(rt2x00dev, RT6352)) {
> ...
> 5291:  } else if (rt2x00_rt(rt2x00dev, RT6352)) {
> ...

Hence remove errornous line 5281 to make the driver actually
execute the correct initialization routine for MT7620 chips.

As it was requested by Stanislaw Gruszka remove setting values of
MIMO_PS_CFG and TX_PIN_CFG. MIMO_PS_CFG is responsible for MIMO
power-safe mode (which is disabled), hence we can drop setting it.
TX_PIN_CFG is set correctly in other functions, and as setting this
value breaks some devices, rather don't set it here during init, but
only modify it later on.

Fixes: 41977e86c984 ("rt2x00: add support for MT7620")
Reported-by: wbob <wbob@jify.de>
Reported-by: Roman Yeryomin <roman@advem.lv>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index f1cdcd61c54a5..c99f1912e2660 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5839,8 +5839,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_TXBF_CFG_0, 0x8000fc21);
 		rt2800_register_write(rt2x00dev, TX_TXBF_CFG_3, 0x00009c40);
 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
-		   rt2x00_rt(rt2x00dev, RT5392) ||
-		   rt2x00_rt(rt2x00dev, RT6352)) {
+		   rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -5854,8 +5853,6 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
-		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
-		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
 		rt2800_register_write(rt2x00dev, TX1_BB_GAIN_ATTEN, 0x0);
-- 
2.20.1



