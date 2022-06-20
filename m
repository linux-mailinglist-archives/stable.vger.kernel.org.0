Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F46551AD9
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245433AbiFTNLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344087AbiFTNJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DA51C121;
        Mon, 20 Jun 2022 06:05:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B7BF61537;
        Mon, 20 Jun 2022 13:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B718C3411B;
        Mon, 20 Jun 2022 13:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730276;
        bh=0ItFtN6K/Y0+MmOpTs2KKTcstQJhzWyJHizhDgZZgjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDUhckUztDedPnQ8CQSbUpEmyfpty2ihB0ia1OeB/UK0Mwi/Q2yMunJ9fvXq7mIC5
         JzZ0dLgcoh2jHQaEc+zoYsZYn+gjXabsPhd0Q0qLaPZ5UC5BWT1DQSSDW3R6Pfy6xe
         4fXT10wA6UP4Ro5JOegHOfVzQQeD9KKTEhkUagM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 5.10 65/84] usb: dwc2: Fix memory leak in dwc2_hcd_init
Date:   Mon, 20 Jun 2022 14:51:28 +0200
Message-Id: <20220620124722.810214405@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
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

commit 3755278f078460b021cd0384562977bf2039a57a upstream.

usb_create_hcd will alloc memory for hcd, and we should
call usb_put_hcd to free it when platform_get_resource()
fails to prevent memory leak.
goto error2 label instead error1 to fix this.

Fixes: 856e6e8e0f93 ("usb: dwc2: check return value after calling platform_get_resource()")
Cc: stable <stable@kernel.org>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220530085413.44068-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -5076,7 +5076,7 @@ int dwc2_hcd_init(struct dwc2_hsotg *hso
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		retval = -EINVAL;
-		goto error1;
+		goto error2;
 	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);


