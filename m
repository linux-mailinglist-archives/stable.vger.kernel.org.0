Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF626C16F6
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbjCTPKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjCTPKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:10:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CB72A168
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BD68B80EC1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C4DC433D2;
        Mon, 20 Mar 2023 15:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324703;
        bh=y/L7RGNDeVh4LSGN3/Ig9g+XruGfYxMtFIjfF1e8uxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKhpzGp9WN7FWOsjswc9O+sf9ChlYrWwo1DbYKn4YTMMGaAJwW8T9hBsRqyZdKiUR
         l3d+ZqjtFQvUrC98rbU5SdCVk/6VDIOqsZPEcE5f+ZGKA23jmPDWvXgWg5O4HA8EJx
         OyIpJNMz7XpNYPaSBMSivCEkdFy4rQNdc+hpRtHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/99] hwmon: (ina3221) return prober error code
Date:   Mon, 20 Mar 2023 15:54:21 +0100
Message-Id: <20230320145445.177613129@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
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

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit c93f5e2ab53243b17febabb9422a697017d3d49a ]

ret is set to 0 which do not indicate an error.
Return -EINVAL instead.

Fixes: a9e9dd9c6de5 ("hwmon: (ina3221) Read channel input source info from DT")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://lore.kernel.org/r/20230310075035.246083-1-marcus.folkesson@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina3221.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index d3c98115042b5..836e7579e166a 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -772,7 +772,7 @@ static int ina3221_probe_child_from_dt(struct device *dev,
 		return ret;
 	} else if (val > INA3221_CHANNEL3) {
 		dev_err(dev, "invalid reg %d of %pOFn\n", val, child);
-		return ret;
+		return -EINVAL;
 	}
 
 	input = &ina->inputs[val];
-- 
2.39.2



