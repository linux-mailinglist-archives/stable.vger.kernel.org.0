Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A056E1744
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 00:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjDMWV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 18:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjDMWV4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 18:21:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00A38A78;
        Thu, 13 Apr 2023 15:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7675664202;
        Thu, 13 Apr 2023 22:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75E0C433EF;
        Thu, 13 Apr 2023 22:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681424505;
        bh=LHf3EdbUfTHiiFAiofVbn0QT35RrzQGBC8v1K1+GCk8=;
        h=From:To:Cc:Subject:Date:From;
        b=dp0T5VJURoF7M0+EMhR4DY3owQX2XHIcBn191ytxWsQ3VtGxGbO45reUl1USj9c3j
         XGiieKLaPGOoBMaAFEp2BdJ/RXwajsp8JkwV88hNKu16Bh6cEsHbtmYtEYBVTBgAFk
         +jJ58cx8Ck6ykfJYC7T1N70hfOZPrf3s4S9Axlzy2++FPvnsoVRBz1cUtf/vg42PDo
         i/nGU1YzjqIsiqYNXePWOqecQnOoXyjHVJv8kIUBlhXASNUxrPK7LRBpKLC5nDYyZb
         bNAzXfVNvx2cqDpYqvaCGtuzoTPMXW8dzuyGW0y9vmq9ntuiENjvymlCiv28GezIca
         TsiEOgbuYa7tQ==
From:   Conor Dooley <conor@kernel.org>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     conor@kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        stable@vger.kernel.org,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] clk: microchip: fix potential UAF in auxdev release callback
Date:   Thu, 13 Apr 2023 23:20:45 +0100
Message-Id: <20230413-critter-synopsis-dac070a86cb4@spud>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1803; i=conor.dooley@microchip.com; h=from:subject:message-id; bh=4o5FqEparnIFOIeeg2rKzW8byGnby2Xg9Ye2UA6HtQY=; b=owGbwMvMwCFWscWwfUFT0iXG02pJDCkWDZbXVvqGiJ3V3JfLUmQ16bfqZK+A53I7Dz7/vbXzy /ZXFtxnO0pZGMQ4GGTFFFkSb/e1SK3/47LDuectzBxWJpAhDFycAjARgxkM/4NzF4pxpEXah75X Ck/mVKi/v6D2+dU3/AYLRNJ+WmzrfMLwv1jLb+mXz38vOvs+OLLyG6/IrMc/ja8UfucT5Vpvdch rBw8A
X-Developer-Key: i=conor.dooley@microchip.com; a=openpgp; fpr=F9ECA03CF54F12CD01F1655722E2C55B37CF380C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

Similar to commit 1c11289b34ab ("peci: cpu: Fix use-after-free in
adev_release()"), the auxiliary device is not torn down in the correct
order. If auxiliary_device_add() fails, the release callback will be
called twice, resulting in a UAF. Due to timing, the auxdev code in this
driver "took inspiration" from the aforementioned commit, and thus its
bugs too!

Moving auxiliary_device_uninit() to the unregister callback instead
avoids the issue.

CC: stable@vger.kernel.org
Fixes: b56bae2dd6fd ("clk: microchip: mpfs: add reset controller")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
Stephen,
Claudiu is on leave at the moment, and although I can push stuff to the
at-91 tree etc, it's probably simpler if you just take this yourself?

CC: Stephen Boyd <sboyd@kernel.org>
CC: Conor Dooley <conor.dooley@microchip.com>
CC: Daire McNamara <daire.mcnamara@microchip.com>
CC: Michael Turquette <mturquette@baylibre.com>
CC: Stephen Boyd <sboyd@kernel.org>
CC: Claudiu Beznea <claudiu.beznea@microchip.com>
CC: linux-clk@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/clk/microchip/clk-mpfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/microchip/clk-mpfs.c b/drivers/clk/microchip/clk-mpfs.c
index 4f0a19db7ed7..cc5d7dee59f0 100644
--- a/drivers/clk/microchip/clk-mpfs.c
+++ b/drivers/clk/microchip/clk-mpfs.c
@@ -374,14 +374,13 @@ static void mpfs_reset_unregister_adev(void *_adev)
 	struct auxiliary_device *adev = _adev;
 
 	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
 }
 
 static void mpfs_reset_adev_release(struct device *dev)
 {
 	struct auxiliary_device *adev = to_auxiliary_dev(dev);
 
-	auxiliary_device_uninit(adev);
-
 	kfree(adev);
 }
 
-- 
2.39.2

