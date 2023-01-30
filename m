Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A136D681279
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbjA3OVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237688AbjA3OVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:21:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131BA3EC7D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:20:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30F63B811C9
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C73C433D2;
        Mon, 30 Jan 2023 14:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088327;
        bh=8f1nzkAl5w7jpALLj1R4Tio8VwWPLYtpNvWsI6uMWjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxSsTKchvAFGbJIIhPSwGZ/hgZobOvIEhVIUe+uIRPd19zehtzFe+2dYYkqOfDPME
         1B8ezVeOePzLLJ2rLLJar5nWVIN1jW8yfw5C19n1Z10lX1V6CzTervXvr8OQVuDJQn
         Yqxw+IIA3I0st0OBky1H2cWwEdW+eUi71KmzoXSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/204] gpio: mxc: Unlock on error path in mxc_flip_edge()
Date:   Mon, 30 Jan 2023 14:52:32 +0100
Message-Id: <20230130134324.767609801@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 37870358616ca7fdb1e90ad1cdd791655ec54414 ]

We recently added locking to this function but one error path was
over looked.  Drop the lock before returning.

Fixes: e5464277625c ("gpio: mxc: Protect GPIO irqchip RMW with bgpio spinlock")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Marek Vasut <marex@denx.de>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mxc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index dd91908c72f1..853d9aa6b3b1 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -236,10 +236,11 @@ static void mxc_flip_edge(struct mxc_gpio_port *port, u32 gpio)
 	} else {
 		pr_err("mxc: invalid configuration for GPIO %d: %x\n",
 		       gpio, edge);
-		return;
+		goto unlock;
 	}
 	writel(val | (edge << (bit << 1)), reg);
 
+unlock:
 	raw_spin_unlock_irqrestore(&port->gc.bgpio_lock, flags);
 }
 
-- 
2.39.0



