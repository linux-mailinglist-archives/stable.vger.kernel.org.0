Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23152531BC3
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241055AbiEWReN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241220AbiEWRcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:32:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E9471DBC;
        Mon, 23 May 2022 10:27:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 396F4B81202;
        Mon, 23 May 2022 17:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4F6C385A9;
        Mon, 23 May 2022 17:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326851;
        bh=hHwpGVFOCzcAb6kK80DX/WytmbzrJxxdTixdRTHd6co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBmxYySBBylRMvYVrBJfwXsD8QWtR6K0K8PXsedc/Vd06yo/IJ/tDnx6UP9M4W2P4
         BKABpS+gvXoQa4oMOEhe2OVtfsj32RJKP8lAU/OWRj600jYUuOJ0F7VFJ/Gm7RY430
         npwqsbEil49zwQMp98jhJsTXG9wSS/Gaa6GrKe6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean Rene Dawin <jdawin@math.uni-bielefeld.de>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.17 061/158] mmc: core: Fix busy polling for MMC_SEND_OP_COND again
Date:   Mon, 23 May 2022 19:03:38 +0200
Message-Id: <20220523165840.951671796@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit e949dee3625e1b0ef2e40d9aa09c2995281b12f6 upstream.

It turned out that polling period for MMC_SEND_OP_COND, that currently is
set to 1ms, still isn't sufficient. In particular a Micron eMMC on a
Beaglebone platform, is reported to sometimes fail to initialize.

Additional test, shows that extending the period to 4ms is working fine, so
let's make that change.

Reported-by: Jean Rene Dawin <jdawin@math.uni-bielefeld.de>
Tested-by: Jean Rene Dawin <jdawin@math.uni-bielefeld.de>
Fixes: 1760fdb6fe9f (mmc: core: Restore (almost) the busy polling for MMC_SEND_OP_COND")
Fixes: 76bfc7ccc2fa ("mmc: core: adjust polling interval for CMD1")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20220517101046.27512-1-ulf.hansson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -21,7 +21,7 @@
 
 #define MMC_BKOPS_TIMEOUT_MS		(120 * 1000) /* 120s */
 #define MMC_SANITIZE_TIMEOUT_MS		(240 * 1000) /* 240s */
-#define MMC_OP_COND_PERIOD_US		(1 * 1000) /* 1ms */
+#define MMC_OP_COND_PERIOD_US		(4 * 1000) /* 4ms */
 #define MMC_OP_COND_TIMEOUT_MS		1000 /* 1s */
 
 static const u8 tuning_blk_pattern_4bit[] = {


