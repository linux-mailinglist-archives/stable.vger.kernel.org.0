Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4A159D465
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242922AbiHWIW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242795AbiHWIUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:20:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1614D6A4BA;
        Tue, 23 Aug 2022 01:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EDA64CE1B32;
        Tue, 23 Aug 2022 08:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA51CC433D7;
        Tue, 23 Aug 2022 08:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242318;
        bh=8x8a63ntKhqkoOD+w91XE3oumOK0E4SykLQt4bVGTB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRQe0z2kERRBljSxarmKzk85STfc+bcVEEUjHya6eV41EO4LJxeWJHAV5ILxngjo6
         uftpoMybpVCScqXDJWmJjNOG2zHwkbzYIDxNtR/u3WNd2fsUeF4lohP0Id6PPvMj/8
         C5M66nEyYg7Jbioqak7dCn903/NVfijGPiaQNzjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.19 093/365] pinctrl: nomadik: Fix refcount leak in nmk_pinctrl_dt_subnode_to_map
Date:   Tue, 23 Aug 2022 09:59:54 +0200
Message-Id: <20220823080122.086568010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -1421,8 +1421,10 @@ static int nmk_pinctrl_dt_subnode_to_map
 
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


