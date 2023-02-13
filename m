Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CA26949AD
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjBMPAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjBMPAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:00:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636B11CF54
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:00:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 151096106F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6E7C433EF;
        Mon, 13 Feb 2023 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300420;
        bh=XXTKGH8M/OwP3Kl+fuwdhe76Hjlg+Oj8MDhYKHugdlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIrMMaX8qDNm+WLmkNwaybpiY5KGrHBxxE+LrserTkQ6XmUr2XfMR54UWuDutIZtM
         i5VFkoGWtUgaydaiMMMGuu0kHSF4OUpBJJMcVftVL/2YqXk0uUpwoMgsRQiAiYjn1B
         7CbEfpw3dk2yIjZJy86IhFlS/0aEkzfnR4xNJhEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 67/67] nvmem: core: fix return value
Date:   Mon, 13 Feb 2023 15:49:48 +0100
Message-Id: <20230213144735.602745645@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit 0c4862b1c1465e473bc961a02765490578bf5c20 upstream.

Dan Carpenter points out that the return code was not set in commit
60c8b4aebd8e ("nvmem: core: fix cleanup after dev_set_name()"), but
this is not the only issue - we also need to zero wp_gpio to prevent
gpiod_put() being called on an error value.

Fixes: 560181d3ace6 ("nvmem: core: fix cleanup after dev_set_name()")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-10-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -779,6 +779,7 @@ struct nvmem_device *nvmem_register(cons
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
 		rval = PTR_ERR(nvmem->wp_gpio);
+		nvmem->wp_gpio = NULL;
 		goto err_put_device;
 	}
 


