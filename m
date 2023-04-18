Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C458E6E6302
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjDRMhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjDRMhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:37:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5449613864
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6742632AD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE07C433D2;
        Tue, 18 Apr 2023 12:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821427;
        bh=4Qw3BGlNM2fmwGtPxT0weAgNI7WTvONXczuAN3z5Jzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QChUEAB6vEjmKtKyGVqMa5SRa7Nl5EZLel+qiz+d1ABtyjW5SQLivZHuC0yFdzsa2
         TzyI6XYL84shKAjpNXwU2vUkzy5qsydg3aFTgB/6UdhwE+xn715v0p3jrUSmSRYo09
         F/qDl7N2EpMNGCV7BHBDP1rcOmrNB5HT3BlmDCAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 094/124] net: sfp: initialize sfp->i2c_block_size at sfp allocation
Date:   Tue, 18 Apr 2023 14:21:53 +0200
Message-Id: <20230418120313.262122201@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Bornyakov <i.bornyakov@metrotek.ru>

commit 813c2dd78618f108fdcf9cd726ea90f081ee2881 upstream.

sfp->i2c_block_size is initialized at SFP module insertion in
sfp_sm_mod_probe(). Because of that, if SFP module was never inserted
since boot, sfp_read() call will lead to zero-length I2C read attempt,
and not all I2C controllers are happy with zero-length reads.

One way to issue sfp_read() on empty SFP cage is to execute ethtool -m.
If SFP module was never plugged since boot, there will be a zero-length
I2C read attempt.

  # ethtool -m xge0
  i2c i2c-3: adapter quirk: no zero length (addr 0x0050, size 0, read)
  Cannot get Module EEPROM data: Operation not supported

If SFP module was plugged then removed at least once,
sfp->i2c_block_size will be initialized and ethtool -m will fail with
different exit code and without I2C error

  # ethtool -m xge0
  Cannot get Module EEPROM data: Remote I/O error

Fix this by initializing sfp->i2_block_size at struct sfp allocation
stage so no wild sfp_read() could issue zero-length I2C read.

Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
Fixes: 0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround")
Cc: stable@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/sfp.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -207,6 +207,12 @@ static const enum gpiod_flags gpio_flags
  */
 #define SFP_PHY_ADDR	22
 
+/* SFP_EEPROM_BLOCK_SIZE is the size of data chunk to read the EEPROM
+ * at a time. Some SFP modules and also some Linux I2C drivers do not like
+ * reads longer than 16 bytes.
+ */
+#define SFP_EEPROM_BLOCK_SIZE	16
+
 struct sff_data {
 	unsigned int gpios;
 	bool (*module_supported)(const struct sfp_eeprom_id *id);
@@ -1754,11 +1760,7 @@ static int sfp_sm_mod_probe(struct sfp *
 	u8 check;
 	int ret;
 
-	/* Some SFP modules and also some Linux I2C drivers do not like reads
-	 * longer than 16 bytes, so read the EEPROM in chunks of 16 bytes at
-	 * a time.
-	 */
-	sfp->i2c_block_size = 16;
+	sfp->i2c_block_size = SFP_EEPROM_BLOCK_SIZE;
 
 	ret = sfp_read(sfp, false, 0, &id.base, sizeof(id.base));
 	if (ret < 0) {
@@ -2385,6 +2387,7 @@ static struct sfp *sfp_alloc(struct devi
 		return ERR_PTR(-ENOMEM);
 
 	sfp->dev = dev;
+	sfp->i2c_block_size = SFP_EEPROM_BLOCK_SIZE;
 
 	mutex_init(&sfp->sm_mutex);
 	mutex_init(&sfp->st_mutex);


