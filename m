Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416365921E1
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbiHNPm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241609AbiHNPmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:42:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FDD1BE99;
        Sun, 14 Aug 2022 08:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 527C5CE0B69;
        Sun, 14 Aug 2022 15:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2467CC433C1;
        Sun, 14 Aug 2022 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491199;
        bh=9krYIMZkWByFYm0Z2MCMjTdo/cKY77hHZASSi3Elm3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmU4GXmg4ZJciMWjEy+y1M1P6jnZ5qKsf6aTKeOLAca21iwNbvOHbE6c/4X38CBUn
         dPBzLgGRhZKTIrhxMgMul5PPAY0/1FDJgZxirHbAWhvANsc9rkO4cxJiKS9WwRLMxe
         sae1+2uRvt34xM6ksAVC0qo3vYmLNcWgCQIRINgyOUgS7ZVkQCSFUl8MHKxRE5bGFe
         c3UohzLdz6oyF9B47+KsFRl6RS+A5G0EwS9Ndxlmu4j7rhWqwRsaY9xaUYS4SxANem
         i5N3o62tI1/cHn0kYFfsGMCfpBPso0AjkqgIBRFOYlqYbWQSZU1QvKzJ/uK8SiT2Ze
         bK4PyqjRRrwkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/46] usb: renesas: Fix refcount leak bug
Date:   Sun, 14 Aug 2022 11:32:15 -0400
Message-Id: <20220814153247.2378312-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 9d6d5303c39b8bc182475b22f45504106a07f086 ]

In usbhs_rza1_hardware_init(), of_find_node_by_name() will return
a node pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220618023205.4056548-1-windhl@126.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/renesas_usbhs/rza.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/renesas_usbhs/rza.c b/drivers/usb/renesas_usbhs/rza.c
index 24de64edb674..2d77edefb4b3 100644
--- a/drivers/usb/renesas_usbhs/rza.c
+++ b/drivers/usb/renesas_usbhs/rza.c
@@ -23,6 +23,10 @@ static int usbhs_rza1_hardware_init(struct platform_device *pdev)
 	extal_clk = of_find_node_by_name(NULL, "extal");
 	of_property_read_u32(usb_x1_clk, "clock-frequency", &freq_usb);
 	of_property_read_u32(extal_clk, "clock-frequency", &freq_extal);
+
+	of_node_put(usb_x1_clk);
+	of_node_put(extal_clk);
+
 	if (freq_usb == 0) {
 		if (freq_extal == 12000000) {
 			/* Select 12MHz XTAL */
-- 
2.35.1

