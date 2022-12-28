Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD996582C4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiL1QlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbiL1Qkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:40:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165FD1C125
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:35:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13DFC61541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2744AC433EF;
        Wed, 28 Dec 2022 16:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245329;
        bh=rmVJhHKZMH1FTxKYZ4Mv4xjq0qkgcS+ycGLygZcWE9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4Y9X+WD2vPzWVZ+FOrcwz4jJGCh+MkT4v5LLR+hXXhUBpzUzv8Mi80vHMIuEX++z
         psy/j2MBVGIRNsla/jOnZgrbaizXPCR+Ha6lD1aK3dulLGIWm+iNYUJZ2rzT+LdPur
         TvqK/ocVUt8Q6gMv+CXqNMxCAJDMZxzWFUMWXbkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0840/1146] rtc: pcf85063: Fix reading alarm
Date:   Wed, 28 Dec 2022 15:39:39 +0100
Message-Id: <20221228144352.973090481@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit a6ceee26fd5ed9b5bd37322b1ca88e4548cee4a3 ]

If the alarms are disabled the topmost bit (AEN_*) is set in the alarm
registers. This is also interpreted in BCD number leading to this warning:
rtc rtc0: invalid alarm value: 2022-09-21T80:80:80

Fix this by masking alarm enabling and reserved bits.

Fixes: 05cb3a56ee8c ("rtc: pcf85063: add alarm support")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20220921074141.3903104-1-alexander.stein@ew.tq-group.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85063.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-pcf85063.c b/drivers/rtc/rtc-pcf85063.c
index 095891999da1..99f9cc57c7b3 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -169,10 +169,10 @@ static int pcf85063_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret)
 		return ret;
 
-	alrm->time.tm_sec = bcd2bin(buf[0]);
-	alrm->time.tm_min = bcd2bin(buf[1]);
-	alrm->time.tm_hour = bcd2bin(buf[2]);
-	alrm->time.tm_mday = bcd2bin(buf[3]);
+	alrm->time.tm_sec = bcd2bin(buf[0] & 0x7f);
+	alrm->time.tm_min = bcd2bin(buf[1] & 0x7f);
+	alrm->time.tm_hour = bcd2bin(buf[2] & 0x3f);
+	alrm->time.tm_mday = bcd2bin(buf[3] & 0x3f);
 
 	ret = regmap_read(pcf85063->regmap, PCF85063_REG_CTRL2, &val);
 	if (ret)
-- 
2.35.1



