Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C78F59E0EC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354312AbiHWKZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354355AbiHWKVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F54A1DB;
        Tue, 23 Aug 2022 02:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADDEF6157E;
        Tue, 23 Aug 2022 09:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A13C433C1;
        Tue, 23 Aug 2022 09:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245358;
        bh=YhgF2yt0u3VyqWuFgGE9+OCvXB5d0Chiy9PsctpcyxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qB/NlVcLkdDGe5RWP0rBCr6Hd3nLbXuTLqx08dpq0p7QIbLSLaUdEW6R3ijcxcP9Q
         4kbeiXBXaPQrOCX5fKxul9+cOdfAxv5VIEMQyKLXQpFKQyfk4seUr/Anl7RFKPWHk2
         sN0UExbQzi4Ck3sZ+Nz/P39Z7Mh4D37Ti4EhH6X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 054/287] meson-mx-socinfo: Fix refcount leak in meson_mx_socinfo_init
Date:   Tue, 23 Aug 2022 10:23:43 +0200
Message-Id: <20220823080102.063352576@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit a2106f38077e78afcb4bf98fdda3e162118cfb3d ]

of_find_matching_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: 5e68c0fc8df8 ("soc: amlogic: Add Meson6/Meson8/Meson8b/Meson8m2 SoC Information driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220524065729.33689-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/amlogic/meson-mx-socinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/amlogic/meson-mx-socinfo.c b/drivers/soc/amlogic/meson-mx-socinfo.c
index 78f0f1aeca57..92125dd65f33 100644
--- a/drivers/soc/amlogic/meson-mx-socinfo.c
+++ b/drivers/soc/amlogic/meson-mx-socinfo.c
@@ -126,6 +126,7 @@ static int __init meson_mx_socinfo_init(void)
 	np = of_find_matching_node(NULL, meson_mx_socinfo_analog_top_ids);
 	if (np) {
 		analog_top_regmap = syscon_node_to_regmap(np);
+		of_node_put(np);
 		if (IS_ERR(analog_top_regmap))
 			return PTR_ERR(analog_top_regmap);
 
-- 
2.35.1



