Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4DE505599
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241950AbiDRNNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243516AbiDRNKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:10:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CA838793;
        Mon, 18 Apr 2022 05:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1661061254;
        Mon, 18 Apr 2022 12:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9A6C385A1;
        Mon, 18 Apr 2022 12:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286166;
        bh=3ONAA+db7xXX+XCtiELFowQDfk4co1geMc+6o3v+NJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrwmrRWsrkzFoVNM3J7ecedrPdR3W+yc7rK6YX8RQgMDlkuo2AbiHr0YuXzzVsJ4r
         3Kxm1XPyzByUlha+DWmoI0vuHxJgFDayGJgy3Okd2JlXGqR3u0ZYBs5Y/Jpo2CywY8
         3XnmtJOsnDIqE9YF1AYdGprCEBWjcu7RbZ+DYdSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hector Martin <marcan@marcan.st>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 4.14 050/284] brcmfmac: firmware: Allocate space for default boardrev in nvram
Date:   Mon, 18 Apr 2022 14:10:31 +0200
Message-Id: <20220418121212.119599509@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
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
@@ -216,6 +216,8 @@ static int brcmf_init_nvram_parser(struc
 		size = BRCMF_FW_MAX_NVRAM_SIZE;
 	else
 		size = data_len;
+	/* Add space for properties we may add */
+	size += strlen(BRCMF_FW_DEFAULT_BOARDREV) + 1;
 	/* Alloc for extra 0 byte + roundup by 4 + length field */
 	size += 1 + 3 + sizeof(u32);
 	nvp->nvram = kzalloc(size, GFP_KERNEL);


