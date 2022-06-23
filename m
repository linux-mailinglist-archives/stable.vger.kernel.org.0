Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74152558478
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbiFWRnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiFWRmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:42:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8452F98C7C;
        Thu, 23 Jun 2022 10:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CB31B824B7;
        Thu, 23 Jun 2022 17:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20BCC341C5;
        Thu, 23 Jun 2022 17:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004209;
        bh=YFSLUmsgfLwiMcvlShyqk9K23fj8lUXfyVTV4G0bNOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBgpgb6vR9+iGXyoGDj9cKg7wPZO1Aynw+ZbKYW6XjRefee1AQ4IjQdO01zSXzTBD
         7hpUvWbefMqsyPA2B3p0eKdSrCKCJOazFSk9MC/kzsGZYR0xSZXWAoU1EX9R91Mm7u
         kw2GBep0O/DLJwwWYrse7ZsszLjvF7d5bexpI1vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 4.14 221/237] usb: gadget: lpc32xx_udc: Fix refcount leak in lpc32xx_udc_probe
Date:   Thu, 23 Jun 2022 18:44:15 +0200
Message-Id: <20220623164349.508374768@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 4757c9ade34178b351580133771f510b5ffcf9c8 upstream.

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.
of_node_put() will check NULL pointer.

Fixes: 24a28e428351 ("USB: gadget driver for LPC32xx")
Cc: stable <stable@kernel.org>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220603140246.64529-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/lpc32xx_udc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3034,6 +3034,7 @@ static int lpc32xx_udc_probe(struct plat
 	}
 
 	udc->isp1301_i2c_client = isp1301_get_client(isp1301_node);
+	of_node_put(isp1301_node);
 	if (!udc->isp1301_i2c_client) {
 		retval = -EPROBE_DEFER;
 		goto phy_fail;


