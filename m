Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC0F615817
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiKBCpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiKBCpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:45:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39DC20F5F
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96B8CB82075
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD4DC433C1;
        Wed,  2 Nov 2022 02:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357099;
        bh=iJ8EtD98C3Ll4eZDM8JbU1z5twsSVrPWQWEskaR037w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdXN0ktfzT2Pdq5RA4DX04PQ5XFz2mdrHILdyGzlQ825DxdXHMiy8/YjEk/3ZxpL3
         1X8/0NS2rX+WZT14/z5LL/PV5N1/G+CgjpBssgU7U5xYK4ois+6NY37mG8vauz1Rcc
         w7JK+vukOnLbpexwoaqSAgxeByiMM/erjaQx83kc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.0 112/240] media: ar0521: Fix return value check in writing initial registers
Date:   Wed,  2 Nov 2022 03:31:27 +0100
Message-Id: <20221102022113.921869824@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 54bb7671ca6de58929b3994468c330bedb9a3b7e upstream.

The return value from register writes is ignored apart from the last
value. Fix this.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ar0521.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -756,11 +756,12 @@ static int ar0521_power_on(struct device
 		gpiod_set_value(sensor->reset_gpio, 0);
 	usleep_range(4500, 5000); /* min 45000 clocks */
 
-	for (cnt = 0; cnt < ARRAY_SIZE(initial_regs); cnt++)
+	for (cnt = 0; cnt < ARRAY_SIZE(initial_regs); cnt++) {
 		ret = ar0521_write_regs(sensor, initial_regs[cnt].data,
 					initial_regs[cnt].count);
 		if (ret)
 			goto off;
+	}
 
 	ret = ar0521_write_reg(sensor, AR0521_REG_SERIAL_FORMAT,
 			       AR0521_REG_SERIAL_FORMAT_MIPI |


