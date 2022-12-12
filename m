Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A38364A0DD
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbiLLNcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiLLNb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:31:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11C8631E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:31:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C01B61050
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D437AC433F0;
        Mon, 12 Dec 2022 13:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851915;
        bh=GU+fmO2L0eSKgX6T1oL1n0PHBGMmq/9J/JmprwUAF7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4/dWZBlnH384yTOZ9Q2k4grTr8RSMhjnlff6bXQlfJEzvrlCjWs55YBybGCZlZT0
         UfphLQdB9WwrmWrjKAWZ5u+X+bQ8UrUUm9SlmpXWbHDZ4BOULJFu9CaAxk+yxobm8c
         dq8r8j6dA9TGJEzHAdLbwHQmwSvpkGqJ9/9uT/Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/123] gpio/rockchip: fix refcount leak in rockchip_gpiolib_register()
Date:   Mon, 12 Dec 2022 14:17:42 +0100
Message-Id: <20221212130931.143260757@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 63ff545af73f759d1bd04198af8ed8577fb739fc ]

The node returned by of_get_parent() with refcount incremented,
of_node_put() needs be called when finish using it. So add it in the
end of of_pinctrl_get().

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index d32928c1efe0..a197f698efeb 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -605,6 +605,7 @@ static int rockchip_gpiolib_register(struct rockchip_pin_bank *bank)
 			return -ENODATA;
 
 		pctldev = of_pinctrl_get(pctlnp);
+		of_node_put(pctlnp);
 		if (!pctldev)
 			return -ENODEV;
 
-- 
2.35.1



