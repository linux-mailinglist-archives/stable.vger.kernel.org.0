Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA787615AE4
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiKBDn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiKBDnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:43:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58751C48
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:43:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E90576172F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9082CC433D6;
        Wed,  2 Nov 2022 03:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360600;
        bh=2wmwYwVfhI8cA8+mg7+tGbyhNEomvYPMRzUJTtUEHuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/kyQLxaZ53mDSN3zilZtfXBO1xXens+lqS2SgB/VduDa0NvLFrloUAG3Z/6VrNxL
         woWFSC3VnTfY6/ras+SlXNYxSwTJAVZdOJvc11xtHSLEu/aehdQegj+Ba+to/g3XXT
         Ts4D+z9iqBYPUMs/mnmnKTgzXAO47l3cVD4JmMfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Ma <mahongwei@zeku.com>,
        Weizhao Ouyang <ouyangweizhao@zeku.com>,
        John Wang <wangdayu@zeku.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 29/60] mmc: core: Fix kernel panic when remove non-standard SDIO card
Date:   Wed,  2 Nov 2022 03:34:50 +0100
Message-Id: <20221102022052.040221906@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
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

From: Matthew Ma <mahongwei@zeku.com>

commit 9972e6b404884adae9eec7463e30d9b3c9a70b18 upstream.

SDIO tuple is only allocated for standard SDIO card, especially it causes
memory corruption issues when the non-standard SDIO card has removed, which
is because the card device's reference counter does not increase for it at
sdio_init_func(), but all SDIO card device reference counter gets decreased
at sdio_release_func().

Fixes: 6f51be3d37df ("sdio: allow non-standard SDIO cards")
Signed-off-by: Matthew Ma <mahongwei@zeku.com>
Reviewed-by: Weizhao Ouyang <ouyangweizhao@zeku.com>
Reviewed-by: John Wang <wangdayu@zeku.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221014034951.2300386-1-ouyangweizhao@zeku.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sdio_bus.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -264,7 +264,8 @@ static void sdio_release_func(struct dev
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 
-	sdio_free_func_cis(func);
+	if (!(func->card->quirks & MMC_QUIRK_NONSTD_SDIO))
+		sdio_free_func_cis(func);
 
 	kfree(func->info);
 	kfree(func->tmpbuf);


