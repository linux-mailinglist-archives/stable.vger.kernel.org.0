Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA366AF252
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbjCGSw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbjCGSwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:52:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72556234EB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:40:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEAF16150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34D4C4339B;
        Tue,  7 Mar 2023 18:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214395;
        bh=QLoHlVKf2vRK4Dcxxia3Mon4beBYDqM7U+AgMkz1IgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Akp081fKFhpMRw1+EaTYcmQCgLKyVA4V5PqjQEylTiIUz3Vrw4cAEag3er+pscp7m
         xT7TPA71xJ1C5SrR9v2IM3NdT2N/bBjVj+ljhRS7Iz7SEQPGf4RFhr6D3ASbUW9rYf
         N3wlQmvjqHsuojM8aWrSRESURAf8nMlFrh+Zny28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zev Weiss <zev@bewilderbeest.net>,
        Guenter Roeck <linux@roeck-us.net>, stable@kernel.org
Subject: [PATCH 6.1 809/885] hwmon: (nct6775) Fix incorrect parenthesization in nct6775_write_fan_div()
Date:   Tue,  7 Mar 2023 18:02:23 +0100
Message-Id: <20230307170037.032326368@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

commit 2fbb848b65cde5b876cce52ebcb34de4aaa5a94a upstream.

Commit 4ef2774511dc ("hwmon: (nct6775) Convert register access to
regmap API") fumbled the shifting & masking of the fan_div values such
that odd-numbered fan divisors would always be set to zero.  Fix it so
that we actually OR in the bits we meant to.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: 4ef2774511dc ("hwmon: (nct6775) Convert register access to regmap API")
Cc: stable@kernel.org # v5.19+
Link: https://lore.kernel.org/r/20230102212857.5670-1-zev@bewilderbeest.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nct6775-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index da9ec6983e13..c54233f0369b 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -1150,7 +1150,7 @@ static int nct6775_write_fan_div(struct nct6775_data *data, int nr)
 	if (err)
 		return err;
 	reg &= 0x70 >> oddshift;
-	reg |= data->fan_div[nr] & (0x7 << oddshift);
+	reg |= (data->fan_div[nr] & 0x7) << oddshift;
 	return nct6775_write_value(data, fandiv_reg, reg);
 }
 
-- 
2.39.2



