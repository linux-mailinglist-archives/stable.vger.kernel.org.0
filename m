Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E13C5F2FF1
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 13:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJCL65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 07:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiJCL6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 07:58:55 -0400
X-Greylist: delayed 613 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 03 Oct 2022 04:58:51 PDT
Received: from forward104j.mail.yandex.net (forward104j.mail.yandex.net [5.45.198.247])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604E84F678
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 04:58:51 -0700 (PDT)
Received: from myt5-2f5ba0466eb8.qloud-c.yandex.net (myt5-2f5ba0466eb8.qloud-c.yandex.net [IPv6:2a02:6b8:c12:1c83:0:640:2f5b:a046])
        by forward104j.mail.yandex.net (Yandex) with ESMTP id 1787F2F9813E;
        Mon,  3 Oct 2022 14:48:33 +0300 (MSK)
Received: by myt5-2f5ba0466eb8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id RZaKs5lePN-mWh4alto;
        Mon, 03 Oct 2022 14:48:32 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1664797712;
        bh=VtlwfYcjcCrAdYdtTkTQJQ8d8BBkCJaCknuLuJYDnE4=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=fT6rYe25waX7xqaNoRiSJ9ONkwJ+dlc0IyryHXrKvnpCKlCTAEUSo8Goad2a0SHxZ
         FGXsUH5Pdrw+0ScfTktFkT0OlLWCqFQ7JqYIZhltlLmlNj4jp9mSBAFNoEHNKV8up1
         x/fLTpcKCy4Pkywg+hWunHGRRAvb+hxg0JZjxNZc=
Authentication-Results: myt5-2f5ba0466eb8.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Peter Kosyh <pkosyh@yandex.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Kosyh <pkosyh@yandex.ru>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 1/1] eth: ena: Check return value of xdp_convert_buff_to_frame
Date:   Mon,  3 Oct 2022 14:48:19 +0300
Message-Id: <20221003114819.349535-2-pkosyh@yandex.ru>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20221003114819.349535-1-pkosyh@yandex.ru>
References: <20221003114819.349535-1-pkosyh@yandex.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Return value of a function 'xdp_convert_buff_to_frame' is dereferenced
without checking for null, but it is usually checked for this function.

This fixed in upstream commit <e8223eeff02> while refactoring.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 52414ac2c901..9e6b2bd73dac 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -237,6 +237,8 @@ static int ena_xdp_tx_map_buff(struct ena_ring *xdp_ring,
 	u32 size;
 
 	tx_info->xdpf = xdp_convert_buff_to_frame(xdp);
+	if (unlikely(!tx_info->xdpf))
+		goto error_report_dma_error;
 	size = tx_info->xdpf->len;
 	ena_buf = tx_info->bufs;
 
-- 
2.37.0

