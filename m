Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA86AECEC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjCGR7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCGR7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:59:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1C9A1019
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:53:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A3AFB81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9999DC433D2;
        Tue,  7 Mar 2023 17:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211604;
        bh=iz+cM73n11GcC8NPjrwxOQLmGFQko/mYr58y6SQbwTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gk3LUIPr/vd6ZuWWqUvMkS/RXwfqBX9GOiCkwc1VCHQHfr0/myU5M4WVQNcCwxj/Z
         D+JPsCpMMVYqxWAdNRhYnAO8vj0qU/LpZiVkS8imWwTAufbjPTYXFLrtWseUVT31sP
         +vSFKRbMQQDsvgJNsS3Hn76nKH3QUqiQ9EsDTd1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zev Weiss <zev@bewilderbeest.net>,
        Guenter Roeck <linux@roeck-us.net>, stable@kernel.org
Subject: [PATCH 6.2 0916/1001] hwmon: (nct6775) Fix incorrect parenthesization in nct6775_write_fan_div()
Date:   Tue,  7 Mar 2023 18:01:28 +0100
Message-Id: <20230307170101.809651907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

commit 2fbb848b65cde5b876cce52ebcb34de4aaa5a94a upstream.

Commit 4ef2774511dc ("hwmon: (nct6775) Convert register access to
regmap API") fumbled the shifting & masking of the fan_div values such
that odd-numbered fan divisors would always be set to zero.  Fix it so
that we actually OR in the bits we meant to.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: 4ef2774511dc ("hwmon: (nct6775) Convert register access to regmap API")
Cc: stable@kernel.org # v5.19+
Link: https://lore.kernel.org/r/20230102212857.5670-1-zev@bewilderbeest.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nct6775-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -1150,7 +1150,7 @@ static int nct6775_write_fan_div(struct
 	if (err)
 		return err;
 	reg &= 0x70 >> oddshift;
-	reg |= data->fan_div[nr] & (0x7 << oddshift);
+	reg |= (data->fan_div[nr] & 0x7) << oddshift;
 	return nct6775_write_value(data, fandiv_reg, reg);
 }
 


