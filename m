Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F27548778
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351641AbiFMLJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351734AbiFMLIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:08:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A64338A8;
        Mon, 13 Jun 2022 03:35:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36A24B80EA7;
        Mon, 13 Jun 2022 10:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D74DC36AFF;
        Mon, 13 Jun 2022 10:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116506;
        bh=JsZE5AxHTbW00VZnJgu/U+JfgGO6KlUPjLQsTZoemWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRAzjsfuakEGwXNF8g26bCy7cRS52tt4OO71l3bz9i8sCXtMyvOvBABX1pWcjCvgH
         /fvACpHzlu5nxZCIcbw4LDPVjlcQS1DXTsEGjHQ6y8UuBiDW0RXw8pbzhfzQAxU1z2
         TBGszImSeY0OmYCOeW8LhTnj6jhECPhMlCrwGBzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Teh <jonathan.teh@outlook.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/411] HID: hid-led: fix maximum brightness for Dream Cheeky
Date:   Mon, 13 Jun 2022 12:06:11 +0200
Message-Id: <20220613094931.619142292@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Teh <jonathan.teh@outlook.com>

[ Upstream commit 116c3f4a78ebe478d5ad5a038baf931e93e7d748 ]

Increase maximum brightness for Dream Cheeky to 63. Emperically
determined based on testing in kernel 4.4 on this device:

Bus 003 Device 002: ID 1d34:0004 Dream Cheeky Webmail Notifier

Fixes: 6c7ad07e9e05 ("HID: migrate USB LED driver from usb misc to hid")
Signed-off-by: Jonathan Teh <jonathan.teh@outlook.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-led.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-led.c b/drivers/hid/hid-led.c
index c2c66ceca132..7d82f8d426bb 100644
--- a/drivers/hid/hid-led.c
+++ b/drivers/hid/hid-led.c
@@ -366,7 +366,7 @@ static const struct hidled_config hidled_configs[] = {
 		.type = DREAM_CHEEKY,
 		.name = "Dream Cheeky Webmail Notifier",
 		.short_name = "dream_cheeky",
-		.max_brightness = 31,
+		.max_brightness = 63,
 		.num_leds = 1,
 		.report_size = 9,
 		.report_type = RAW_REQUEST,
-- 
2.35.1



