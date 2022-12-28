Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C107D657C74
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiL1PdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbiL1Pcm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:32:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF3715FCE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:32:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3B10B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C27C433EF;
        Wed, 28 Dec 2022 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241559;
        bh=yFglyW7VqsMGX4ZW/lUff+SGbOgJ2B6qlwZmsc6CY9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tY6yn2E4aevrUGQhR+Cq+BtUpBjCs6LfbH/0GSdbiV5ebn7GUw+YPyy9FtHkvw0pf
         fdItJ2kqsh08LMGJ2kk/kcK6/EbdNTyJ6lSfDLkLG4wyYWznmOLrZ2IQBvHaFjy54p
         ifx25t1L0+EPvtyHmzW0if4tNh7HBBZWFsmPiHe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alan Stern <stern@rowland.harvard.edu>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 496/731] usb: storage: Add check for kcalloc
Date:   Wed, 28 Dec 2022 15:40:03 +0100
Message-Id: <20221228144310.924451270@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit c35ca10f53c51eeb610d3f8fbc6dd6d511b58a58 ]

As kcalloc may return NULL pointer, the return value should
be checked and return error if fails as same as the ones in
alauda_read_map.

Fixes: e80b0fade09e ("[PATCH] USB Storage: add alauda support")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20221208110058.12983-1-jiasheng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/alauda.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 20b857e97e60..7e4ce0e7e05a 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -438,6 +438,8 @@ static int alauda_init_media(struct us_data *us)
 		+ MEDIA_INFO(us).blockshift + MEDIA_INFO(us).pageshift);
 	MEDIA_INFO(us).pba_to_lba = kcalloc(num_zones, sizeof(u16*), GFP_NOIO);
 	MEDIA_INFO(us).lba_to_pba = kcalloc(num_zones, sizeof(u16*), GFP_NOIO);
+	if (MEDIA_INFO(us).pba_to_lba == NULL || MEDIA_INFO(us).lba_to_pba == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
 
 	if (alauda_reset_media(us) != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
-- 
2.35.1



