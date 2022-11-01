Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C90761495A
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 12:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiKALgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 07:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiKALfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 07:35:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718EF1CFE7;
        Tue,  1 Nov 2022 04:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E65826152E;
        Tue,  1 Nov 2022 11:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B433C433D6;
        Tue,  1 Nov 2022 11:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667302242;
        bh=e/ERjoiqj9SBS9S9TNQSyDwu7c7I9CjXS4MtNJSj+9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gz18uaHutI6kJ/ywPdf17cezw4CiHZ6QmXPCEuuhE8QuEi/BVcaaecRhZDsSVCJ/p
         YqB0DgsrcZlx+umAGxdHVvLyYXxjl4P7CgGgUp/D0eYhAcqFbCQ3JkjPj1ayvkXGJP
         1k8Ni/zcfzR25YiQbhZ2Zd7x1zAYFFcXyt9W/7v2G2MqyyQVJ42vbuDVkAljA3c9hM
         we+QoRiSVpUhx2J0ewh9VRhicRc04l7vu2B66BJqgP6y/XtE/1gPTv9MWyVw6KMIZH
         ueBfRXK1VQpWcJmWAlgMZ8vA25J9CLNV1km0Eod1cTSXJWFj8H7aCQezF0BnVDJ7Ci
         jTExIuqtUOGqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, olivia@selenic.com,
        rjui@broadcom.com, sbranden@broadcom.com,
        linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 10/14] hwrng: bcm2835 - use hwrng_msleep() instead of cpu_relax()
Date:   Tue,  1 Nov 2022 07:30:06 -0400
Message-Id: <20221101113012.800271-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221101113012.800271-1-sashal@kernel.org>
References: <20221101113012.800271-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 96cb9d0554457086664d3bd10630b11193d863f1 ]

Rather than busy looping, yield back to the scheduler and sleep for a
bit in the event that there's no data. This should hopefully prevent the
stalls that Mark reported:

<6>[    3.362859] Freeing initrd memory: 16196K
<3>[   23.160131] rcu: INFO: rcu_sched self-detected stall on CPU
<3>[   23.166057] rcu:  0-....: (2099 ticks this GP) idle=03b4/1/0x40000002 softirq=28/28 fqs=1050
<4>[   23.174895]       (t=2101 jiffies g=-1147 q=2353 ncpus=4)
<4>[   23.180203] CPU: 0 PID: 49 Comm: hwrng Not tainted 6.0.0 #1
<4>[   23.186125] Hardware name: BCM2835
<4>[   23.189837] PC is at bcm2835_rng_read+0x30/0x6c
<4>[   23.194709] LR is at hwrng_fillfn+0x71/0xf4
<4>[   23.199218] pc : [<c07ccdc8>]    lr : [<c07cb841>]    psr: 40000033
<4>[   23.205840] sp : f093df70  ip : 00000000  fp : 00000000
<4>[   23.211404] r10: c3c7e800  r9 : 00000000  r8 : c17e6b20
<4>[   23.216968] r7 : c17e6b64  r6 : c18b0a74  r5 : c07ccd99  r4 : c3f171c0
<4>[   23.223855] r3 : 000fffff  r2 : 00000040  r1 : c3c7e800  r0 : c3f171c0
<4>[   23.230743] Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment none
<4>[   23.238426] Control: 50c5387d  Table: 0020406a  DAC: 00000051
<4>[   23.244519] CPU: 0 PID: 49 Comm: hwrng Not tainted 6.0.0 #1

Link: https://lore.kernel.org/all/Y0QJLauamRnCDUef@sirena.org.uk/
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/bcm2835-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 1a7c43b43c6b..8e10a4d753f7 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -69,7 +69,7 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
 	while ((rng_readl(priv, RNG_STATUS) >> 24) == 0) {
 		if (!wait)
 			return 0;
-		cpu_relax();
+		hwrng_msleep(rng, 1000);
 	}
 
 	num_words = rng_readl(priv, RNG_STATUS) >> 24;
-- 
2.35.1

