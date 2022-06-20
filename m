Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07C5551DBD
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348406AbiFTOCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352321AbiFTN4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:56:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE81B8D;
        Mon, 20 Jun 2022 06:22:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DBC3B80E7D;
        Mon, 20 Jun 2022 13:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1122C3411B;
        Mon, 20 Jun 2022 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731333;
        bh=7t+s0ziznUjXdQS+S/uk61BpyecWr0vrFpg8O5OBnsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y9KALw2XphkRSWScQuf3gCIVkE8seho5/sdP2L+y5ooxNCcMrBmUgdksCkBbdHhlb
         jLC9BGNKj7KjNcHkXwbsEeBthDMO2mwLYDWPIS1cN/Ji7SHcLBFMWzqj/hranGGN/W
         qXOlsDZv3dWr9X2v0r2+guP91431jjJ18fcOtyCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 5.4 225/240] usb: gadget: lpc32xx_udc: Fix refcount leak in lpc32xx_udc_probe
Date:   Mon, 20 Jun 2022 14:52:06 +0200
Message-Id: <20220620124745.480702063@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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
@@ -3027,6 +3027,7 @@ static int lpc32xx_udc_probe(struct plat
 	}
 
 	udc->isp1301_i2c_client = isp1301_get_client(isp1301_node);
+	of_node_put(isp1301_node);
 	if (!udc->isp1301_i2c_client) {
 		return -EPROBE_DEFER;
 	}


