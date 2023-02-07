Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D844C68D867
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjBGNJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjBGNJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A0A35246
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01F6ECE1C97
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CCBC433EF;
        Tue,  7 Feb 2023 13:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775258;
        bh=My6mlmHCfLUlL6XKL7+NsEhNImict+ApCQBH3E0X2zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvCFX86NKouw85qSMyqEcvex6FK6dsZIPOILo9Pw18ea1Rbl8/Tg1pgNn8JEWMFjP
         p7tqX7srPUIyvN+MFUo0B6t5QdRlqe/6tlCkwHDjqpJkxgkmWmXPmR/nttg3bV3wrS
         dtgyjgDsVQdugpO/kSrntUnEO8P5KYbnWrk8+nzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 190/208] nvmem: core: fix return value
Date:   Tue,  7 Feb 2023 13:57:24 +0100
Message-Id: <20230207125643.086743679@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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
@@ -783,6 +783,7 @@ struct nvmem_device *nvmem_register(cons
 						    GPIOD_OUT_HIGH);
 	if (IS_ERR(nvmem->wp_gpio)) {
 		rval = PTR_ERR(nvmem->wp_gpio);
+		nvmem->wp_gpio = NULL;
 		goto err_put_device;
 	}
 


