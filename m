Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE08C60FD4F
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiJ0Qlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbiJ0Qlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:41:47 -0400
X-Greylist: delayed 522 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Oct 2022 09:41:45 PDT
Received: from smtp99.iad3a.emailsrvr.com (smtp99.iad3a.emailsrvr.com [173.203.187.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E217A1867AF;
        Thu, 27 Oct 2022 09:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1666888383;
        bh=DCe5hAhHoPzLmhCsocUrN9hiv2IiDuceRGj1XymUrsc=;
        h=From:To:Subject:Date:From;
        b=IO0GBFOadFXKRXrNtHI+RTrSDJB/ea13zIfef4GmRIPxxtD5+Ud4P12gsStLlSuvD
         MEQeMRUcjCGr4CKrtCztpakmHELspyhO3gViN1sM78pkV9s6og3JfBYl6fzeVvky8c
         VJcMcT8fW+jyjQ4Tyz7hrxCQZ5blf/het+ml0QWY=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp37.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 5A8B65AEC;
        Thu, 27 Oct 2022 12:33:02 -0400 (EDT)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     linux-rtc@vger.kernel.org
Cc:     Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ian Abbott <abbotti@mev.co.uk>, stable@vger.kernel.org
Subject: [PATCH] rtc: ds1347: fix value written to century register
Date:   Thu, 27 Oct 2022 17:32:49 +0100
Message-Id: <20221027163249.447416-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: 9007f867-7bd6-4674-9078-8711a990a260-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In `ds1347_set_time()`, the wrong value is being written to the
`DS1347_CENTURY_REG` register.  It needs to be converted to BCD.  Fix
it.

Fixes: 147dae76dbb9 ("rtc: ds1347: handle century register")
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/rtc/rtc-ds1347.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1347.c b/drivers/rtc/rtc-ds1347.c
index 157bf5209ac4..a40c1a52df65 100644
--- a/drivers/rtc/rtc-ds1347.c
+++ b/drivers/rtc/rtc-ds1347.c
@@ -112,7 +112,7 @@ static int ds1347_set_time(struct device *dev, struct rtc_time *dt)
 		return err;
 
 	century = (dt->tm_year / 100) + 19;
-	err = regmap_write(map, DS1347_CENTURY_REG, century);
+	err = regmap_write(map, DS1347_CENTURY_REG, bin2bcd(century));
 	if (err)
 		return err;
 
-- 
2.35.1

