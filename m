Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C609260A690
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiJXMf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbiJXMfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:35:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C263E57BEE;
        Mon, 24 Oct 2022 05:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D1A7B811F3;
        Mon, 24 Oct 2022 12:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9747DC433C1;
        Mon, 24 Oct 2022 12:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612975;
        bh=AnpJOvKIYkYcjJKzinlWrtkIErjeO2lFOTxCU7ONgSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qbwkoaz8N2BJEvUCIJ13PnwvaaL3+GZYWQ/zXq8v8ipiGxsY3aGYRMKfhrPskAZok
         gZ9enuX/7rPbkpSGY0nBQMSPS2uLngJFGtHt3jVQ4aDGENyhalDGKOUtHnYaIq8TS6
         3owYfwg3Lae+BZ3tknjH1/NfuvHJNqrYn5qMcKxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/229] mfd: intel_soc_pmic: Fix an error handling path in intel_soc_pmic_i2c_probe()
Date:   Mon, 24 Oct 2022 13:31:08 +0200
Message-Id: <20221024113003.832209259@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 48749cabba109397b4e7dd556e85718ec0ec114d ]

The commit in Fixes: has added a pwm_add_table() call in the probe() and
a pwm_remove_table() call in the remove(), but forget to update the error
handling path of the probe.

Add the missing pwm_remove_table() call.

Fixes: a3aa9a93df9f ("mfd: intel_soc_pmic_core: ADD PWM lookup table for CRC PMIC based PWM")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20220801114211.36267-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/intel_soc_pmic_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
index 274306d98ac1..75a2a793ac14 100644
--- a/drivers/mfd/intel_soc_pmic_core.c
+++ b/drivers/mfd/intel_soc_pmic_core.c
@@ -118,6 +118,7 @@ static int intel_soc_pmic_i2c_probe(struct i2c_client *i2c,
 	return 0;
 
 err_del_irq_chip:
+	pwm_remove_table(crc_pwm_lookup, ARRAY_SIZE(crc_pwm_lookup));
 	regmap_del_irq_chip(pmic->irq, pmic->irq_chip_data);
 	return ret;
 }
-- 
2.35.1



