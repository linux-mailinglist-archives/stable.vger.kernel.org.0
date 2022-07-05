Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA2D566DA2
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiGEM0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiGEMY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:24:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B330F1F2FC;
        Tue,  5 Jul 2022 05:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E80C619A6;
        Tue,  5 Jul 2022 12:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D22C341C7;
        Tue,  5 Jul 2022 12:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023424;
        bh=VXNZnHRcm5Fh6+9sf6g8wx9wGuj2YCXXfVd+GM/Akmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2SH4J+W/G1NFh7GPHkvyuacJ8RR8mrluZN2eU+FHjGWYFXJSrKr/bclqaJwUa0zoF
         KQCjInk7wa75ahy25epp/jrzefw5CBGzsSxC22Lyh+P6iBWLUZgKsdDzo32huF0UEr
         WUxcukGqN6VsSXIJiiTH5ytxems5Q6cWPwufEsmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 055/102] net/dsa/hirschmann: Add missing of_node_get() in hellcreek_led_setup()
Date:   Tue,  5 Jul 2022 13:58:21 +0200
Message-Id: <20220705115619.968959878@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

commit 16d584d2fc8f4ea36203af45a76becd7093586f1 upstream.

of_find_node_by_name() will decrease the refcount of its first arg and
we need a of_node_get() to keep refcount balance.

Fixes: 7d9ee2e8ff15 ("net: dsa: hellcreek: Add PTP status LEDs")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220622040621.4094304-1-windhl@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/hirschmann/hellcreek_ptp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -300,6 +300,7 @@ static int hellcreek_led_setup(struct he
 	const char *label, *state;
 	int ret = -EINVAL;
 
+	of_node_get(hellcreek->dev->of_node);
 	leds = of_find_node_by_name(hellcreek->dev->of_node, "leds");
 	if (!leds) {
 		dev_err(hellcreek->dev, "No LEDs specified in device tree!\n");


