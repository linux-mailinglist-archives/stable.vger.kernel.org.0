Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03594AAA77
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 18:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380669AbiBERTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 12:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380656AbiBERTD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 12:19:03 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A84AC061348;
        Sat,  5 Feb 2022 09:19:03 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id bg21-20020a05600c3c9500b0035283e7a012so5779786wmb.0;
        Sat, 05 Feb 2022 09:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V6hY7bEB8gf6/93jTgpUalb0LezsR5A0cCVcQX8k+j8=;
        b=Jxlf+8Ohj/3+MZn3lkPVtzPw2P8C6FkNCk6MOQdMXb9fkSjebRNeAdYZ5J/2f1BQqI
         sXHUwz8ZH/WcBcKBU3O+A8OHBkFcDRM42hUCTnfTbnPZQI+DbcaHg3OpkaFQNRMHR9uO
         1V/4ddGAtw3xSK/mzx6T0Vd552XOKhjeAugtR5MIAKvq59oZEChLu+93RXVGjx9HynTf
         Zg27UDd209hQX2KqhCZv0js9WygBTAkbMxaaXp6KHpu3a6AQDfP0PNyu6iO0NOhFu7Fu
         zjIdc0bangOrekssFTOOEJfTPEeDglloemAT2NFvOl6+TfgJ96ags5U7ZOxxVtE1Hk5Q
         Yu5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V6hY7bEB8gf6/93jTgpUalb0LezsR5A0cCVcQX8k+j8=;
        b=flyWJsX0jhDMEEomtn6H/rs8IUmUvtZITtQjP/kUK8gbb3qwXoiISzE3dU02bq0exh
         +hjRtRLSWIIJMKq3v2v8LenA2BSQ3lhPB9wdYvZRkAvN+GsZ0KOgGyRpxFQTYuHpMWEg
         QqPbcASUiJgQYW0Gc0YArGSFUzWTGoEwS9vvDslQhAU3TR0o0fF6fECsDhMnEuuHgo4t
         2zldszsq9roGuZBGIC84weqNJLHMAn4JgEmMNvK18ubfRii//LINlt8K9T6wgVdewwif
         9jyPMBDj1wthHPKPSfQ1Wkw2wwzNOfsfQDGo/ngTuWX2pVpcUDEBY6AdJnqjFWCJVLcg
         CtZA==
X-Gm-Message-State: AOAM532uk2uSNKVpnifiBhvqUAuobXvGbkcLchCsUvFWQp/L2Q/DtHBk
        JBEVsFwrnQhYURVozeoNuJg=
X-Google-Smtp-Source: ABdhPJwqOeRxxu/uBDw7sUTpmFo6x7xGQAMeCH+fQyHLgklw+f/2zhznuIUUU4EhaRGEnCjpQgxtBQ==
X-Received: by 2002:a05:600c:250:: with SMTP id 16mr3953921wmj.47.1644081541437;
        Sat, 05 Feb 2022 09:19:01 -0800 (PST)
Received: from hp-power-15.localdomain (mm-89-21-212-37.vitebsk.dynamic.pppoe.byfly.by. [37.212.21.89])
        by smtp.gmail.com with ESMTPSA id q140sm1860372wme.16.2022.02.05.09.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 09:19:01 -0800 (PST)
From:   Siarhei Volkau <lis8215@gmail.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-mips@vger.kernel.org,
        linux-clk@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Siarhei Volkau <lis8215@gmail.com>
Subject: [PATCH v4 0/1] clk: jz4725b: fix mmc0 clock gating
Date:   Sat,  5 Feb 2022 20:18:48 +0300
Message-Id: <20220205171849.687805-1-lis8215@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <Yf5yJKWAfxfQUVHU@kroah.com>
References: <Yf5yJKWAfxfQUVHU@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
You can find that the same bit is assigned to "mmc0" too.
It leads to mmc0 hang for a long time after any sound activity
also it  prevented PM_SLEEP to work properly.
I guess it was introduced by copy-paste from jz4740 driver
where it is really controls I2S clock gate.

Changelog v3 .. v4:
 - Added tag "Cc: stable@..."
Changelog v2 .. v3:
 - Added tags Fixes and Reviewed-by.
Changelog v1 .. v2:
 - Added useful info above to the commit itself.

Siarhei Volkau (1):
  clk: jz4725b: fix mmc0 clock gating

 drivers/clk/ingenic/jz4725b-cgu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

-- 
2.35.1

