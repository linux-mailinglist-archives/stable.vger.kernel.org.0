Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DD559E240
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356282AbiHWKuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355951AbiHWKse (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:48:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB17AB06B;
        Tue, 23 Aug 2022 02:12:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF9FA60F50;
        Tue, 23 Aug 2022 09:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0836C433C1;
        Tue, 23 Aug 2022 09:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245932;
        bh=ROwYacelnhogMjbaFhx5Z+LfPE39x335YCVt9z0dvRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAxgEsWtFNFkAYaLZJTdMHdi66AJ2vRN5+SfJ7FLMF48HCDpCNk8TR1xkNaDRmCTP
         WDJOWPA0OdI7fONnGqZZZ1/OyDHI0NlBBTaagxx7C9zocN1i1tXmDYN2rXDJlx5188
         tUDhuOzOaVKtydhUt86snOh4rQ964zjDBILNLapA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4.19 234/287] pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map
Date:   Tue, 23 Aug 2022 10:26:43 +0200
Message-Id: <20220823080108.918959307@linuxfoundation.org>
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

commit 4b32e054335ea0ce50967f63a7bfd4db058b14b9 upstream.

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak."

Fixes: c2f6d059abfc ("pinctrl: nomadik: refactor DT parser to take two paths")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220607111602.57355-1-linmq006@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/nomadik/pinctrl-nomadik.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1455,8 +1455,10 @@ static int nmk_pinctrl_dt_subnode_to_map
 
 	has_config = nmk_pinctrl_dt_get_config(np, &configs);
 	np_config = of_parse_phandle(np, "ste,config", 0);
-	if (np_config)
+	if (np_config) {
 		has_config |= nmk_pinctrl_dt_get_config(np_config, &configs);
+		of_node_put(np_config);
+	}
 	if (has_config) {
 		const char *gpio_name;
 		const char *pin;


