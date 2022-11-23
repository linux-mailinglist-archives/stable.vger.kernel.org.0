Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2638363552C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbiKWJO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbiKWJOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:14:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6192B107E74
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:14:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C78B361B59
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F5BC433D6;
        Wed, 23 Nov 2022 09:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194845;
        bh=D12S1QJOCBDz/sO5Wa0HDRc7+ODBM7WKRmkzoARuMkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQNHHBrb7OrHNCD29P/RNwhGEwRB6fL3uMDvXFj5LhNHpcSuNq/KyzeMmLsMbnc7/
         4COjSL6XWLGYFWH5V/jBaXkL+QLaaykO27kWMotT8nrCAlVnXwgD+5w8savG1hrXMb
         MWc/pyL/yyEStLlJQBBOPPNyDkx70kF5H87sLe6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nam Cao <namcaov@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/156] i2c: i801: add lis3lv02ds I2C address for Vostro 5568
Date:   Wed, 23 Nov 2022 09:50:34 +0100
Message-Id: <20221123084600.791082188@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nam Cao <namcaov@gmail.com>

[ Upstream commit d6643d7207c572c1b0305ed505101f15502c6c87 ]

Dell Vostro 5568 laptop has lis3lv02d, but its i2c address is not known
to the kernel. Add this address.

Output of "cat /sys/devices/platform/lis3lv02d/position" on Dell Vostro
5568 laptop:
    - Horizontal: (-18,0,1044)
    - Front elevated: (522,-18,1080)
    - Left elevated: (-18,-360,1080)
    - Upside down: (36,108,-1134)

Signed-off-by: Nam Cao <namcaov@gmail.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 4e6d0b722ddc..2b84db59ab3c 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1253,6 +1253,7 @@ static const struct {
 	 * Additional individual entries were added after verification.
 	 */
 	{ "Vostro V131",        0x1d },
+	{ "Vostro 5568",        0x29 },
 };
 
 static void register_dell_lis3lv02d_i2c_device(struct i801_priv *priv)
-- 
2.35.1



