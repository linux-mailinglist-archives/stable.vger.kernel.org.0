Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396A74F25FA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiDEHxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiDEHwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:52:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E421B796;
        Tue,  5 Apr 2022 00:48:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78F1861727;
        Tue,  5 Apr 2022 07:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826D4C34110;
        Tue,  5 Apr 2022 07:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144926;
        bh=o65J34RLJto+GKz4V0046wtNQI+MbpXjeDjAO3L02e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FI8bthtaZLsRBTaCqC/2rCcn4NRHkRtWWt2wOwT9/HFdAXC4kyPIZSSSL32GQPND/
         V//Kk1REEJqbqVbodVw+mrmc1EKIN39FM1JC7jR/RJrZMp7Azm7cpV5b6nKjyoc761
         QN0hMm8AY287FIJELZQ+LN8JXPSj596/9jqT/8Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hector Martin <marcan@marcan.st>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.17 0187/1126] brcmfmac: firmware: Allocate space for default boardrev in nvram
Date:   Tue,  5 Apr 2022 09:15:34 +0200
Message-Id: <20220405070413.096558112@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hector Martin <marcan@marcan.st>

commit d19d8e3ba256f81ea4a27209dbbd1f0a00ef1903 upstream.

If boardrev is missing from the NVRAM we add a default one, but this
might need more space in the output buffer than was allocated. Ensure
we have enough padding for this in the buffer.

Fixes: 46f2b38a91b0 ("brcmfmac: insert default boardrev in nvram data if missing")
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220131160713.245637-3-marcan@marcan.st
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -207,6 +207,8 @@ static int brcmf_init_nvram_parser(struc
 		size = BRCMF_FW_MAX_NVRAM_SIZE;
 	else
 		size = data_len;
+	/* Add space for properties we may add */
+	size += strlen(BRCMF_FW_DEFAULT_BOARDREV) + 1;
 	/* Alloc for extra 0 byte + roundup by 4 + length field */
 	size += 1 + 3 + sizeof(u32);
 	nvp->nvram = kzalloc(size, GFP_KERNEL);


