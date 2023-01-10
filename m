Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A65D664A55
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjAJSc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239064AbjAJSb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:31:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07D996138
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:26:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C55EB81904
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DC1C433F0;
        Tue, 10 Jan 2023 18:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375200;
        bh=66h0ahMfWUG4UiOA/SnThe4rUc9VPGxQ/L8JgSjEe74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QISVx/KIncraOp1hoCFi41px4E9FT7g5IJ+AdiI5CsN7NhCMjo9tJm0VI5qjA2S0Y
         i5O9SIY6Ad/TZZ1pUgce9Ab7NYc+BEep/d6+XpOghdDTVTQaYU+lczDs4QKO0RbY2J
         ixa0auW6DhKyEqcp2XVqwbjNLCxZe2Sl99afgPTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ian Abbott <abbotti@mev.co.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.15 112/290] rtc: ds1347: fix value written to century register
Date:   Tue, 10 Jan 2023 19:03:24 +0100
Message-Id: <20230110180035.649695295@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

commit 4dfe05bdc1ade79b943d4979a2e2a8b5ef68fbb5 upstream.

In `ds1347_set_time()`, the wrong value is being written to the
`DS1347_CENTURY_REG` register.  It needs to be converted to BCD.  Fix
it.

Fixes: 147dae76dbb9 ("rtc: ds1347: handle century register")
Cc: <stable@vger.kernel.org> # v5.5+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20221027163249.447416-1-abbotti@mev.co.uk
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-ds1347.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-ds1347.c
+++ b/drivers/rtc/rtc-ds1347.c
@@ -112,7 +112,7 @@ static int ds1347_set_time(struct device
 		return err;
 
 	century = (dt->tm_year / 100) + 19;
-	err = regmap_write(map, DS1347_CENTURY_REG, century);
+	err = regmap_write(map, DS1347_CENTURY_REG, bin2bcd(century));
 	if (err)
 		return err;
 


