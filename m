Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D1E604400
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiJSL4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbiJSLyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:54:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD621B94CA;
        Wed, 19 Oct 2022 04:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2B4BCE20EA;
        Wed, 19 Oct 2022 09:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89AAC433C1;
        Wed, 19 Oct 2022 09:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170241;
        bh=1Ex0IhPVO/kdm+4mY+F4aJIeYW5QUwl8qdfY4dthjZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3Ar/MPv7RVXaYR1KdIjxJqg4CDkBUD5gug8ZM7ZxXao8ilBRwZpT0nHtRgbelNie
         FEoG33fb/is3D4VDA4EEfIIquzNGPl7g1lq5HdRmATfTGzw5uXU0oHXjGwXGCrduMi
         q0kgOD8QZsFeUyD617fA0CkyMG3RvXJhAPfqu4+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Hillenstedt <jens.hillenstedt@ise.de>,
        Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 580/862] mfd: da9061: Fix Failed to set Two-Wire Bus Mode.
Date:   Wed, 19 Oct 2022 10:31:07 +0200
Message-Id: <20221019083315.577464035@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Hillenstedt <jens.hillenstedt@ise.de>

[ Upstream commit 834382ea32865a4bdeae83ec2dcb9321dc9489f2 ]

In da9062_i2c_probe() regmap_clear_bits() tries to access CONFIG_J
register. As CONFIG_J is not present in da9061_aa_writeable_ranges[] probe
of da9061 fails:

  da9062 2-0058: Entering I2C mode!
  da9062 2-0058: Failed to set Two-Wire Bus Mode.
  da9062: probe of 2-0058 failed with error -5

Add CONFIG_J register to da9061_aa_writeable_ranges[].

Fixes: 5c6f0f456351 ("mfd: da9062: Support SMBus and I2C mode")
Signed-off-by: Jens Hillenstedt <jens.hillenstedt@ise.de>
Reviewed-by: Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20220915092004.168744-1-jens.hillenstedt@ise.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9062-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/da9062-core.c b/drivers/mfd/da9062-core.c
index 2774b2cbaea6..c2acdbcd5d6b 100644
--- a/drivers/mfd/da9062-core.c
+++ b/drivers/mfd/da9062-core.c
@@ -453,6 +453,7 @@ static const struct regmap_range da9061_aa_writeable_ranges[] = {
 	regmap_reg_range(DA9062AA_VBUCK1_B, DA9062AA_VBUCK4_B),
 	regmap_reg_range(DA9062AA_VBUCK3_B, DA9062AA_VBUCK3_B),
 	regmap_reg_range(DA9062AA_VLDO1_B, DA9062AA_VLDO4_B),
+	regmap_reg_range(DA9062AA_CONFIG_J, DA9062AA_CONFIG_J),
 	regmap_reg_range(DA9062AA_GP_ID_0, DA9062AA_GP_ID_19),
 };
 
-- 
2.35.1



