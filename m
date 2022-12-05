Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E368B64331C
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbiLETeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbiLETd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:33:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470EC27CE5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAABB6130C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29B5C433C1;
        Mon,  5 Dec 2022 19:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268546;
        bh=fnhSODLAcno3KqncfRPfQJNekfLDBy7vnQmC5+sxIUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEEisgOi4znevPanBZ1C9uAbuQ3GQ+yfiqOKE5PokQLjteUjCEpPAekFXt6Jf+1/n
         O+T/RS9qAUiv5Y6cBt0exr8y8CblxMXvU/xPZ/CCGVp4oFAp3YEfOG5+a5j2FCx+qT
         BrdQUtTGG0fhKDeMfsHmh5DQGwKhg1vWlEhXWnsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Derek Nguyen <derek.nguyen@collins.com>,
        Brandon Maier <brandon.maier@collins.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/92] hwmon: (ltc2947) fix temperature scaling
Date:   Mon,  5 Dec 2022 20:09:30 +0100
Message-Id: <20221205190804.060855108@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

From: Derek Nguyen <derek.nguyen@collins.com>

[ Upstream commit 07e06193ead86d4812f431b4d87bbd4161222e3f ]

The LTC2947 datasheet (Rev. B) calls out in the section "Register
Description: Non-Accumulated Result Registers" (pg. 30) that "To
calculate temperature, multiply the TEMP register value by 0.204°C
and add 5.5°C". Fix to add 5.5C and not 0.55C.

Fixes: 9f90fd652bed ("hwmon: Add support for ltc2947")
Signed-off-by: Derek Nguyen <derek.nguyen@collins.com>
Signed-off-by: Brandon Maier <brandon.maier@collins.com>
Link: https://lore.kernel.org/r/20221110192108.20624-1-brandon.maier@collins.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2947-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ltc2947-core.c b/drivers/hwmon/ltc2947-core.c
index 5423466de697..e918490f3ff7 100644
--- a/drivers/hwmon/ltc2947-core.c
+++ b/drivers/hwmon/ltc2947-core.c
@@ -396,7 +396,7 @@ static int ltc2947_read_temp(struct device *dev, const u32 attr, long *val,
 		return ret;
 
 	/* in milidegrees celcius, temp is given by: */
-	*val = (__val * 204) + 550;
+	*val = (__val * 204) + 5500;
 
 	return 0;
 }
-- 
2.35.1



