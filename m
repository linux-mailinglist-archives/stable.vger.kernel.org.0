Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1852D540831
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243056AbiFGR4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348834AbiFGRyR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:54:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67548144789;
        Tue,  7 Jun 2022 10:39:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9359B822AD;
        Tue,  7 Jun 2022 17:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF32CC385A5;
        Tue,  7 Jun 2022 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623571;
        bh=PQpjQG3pFURTCSgJVO1XL5DHQPOIXC4phwjj4OG20fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fo8uD9Eo7cVZG9s0xaEvI1lUrir5RKl2HF/WzsAzLhKRi0P2rTreqyRWhau1FRctA
         fwOKByaG6PqVO89jp+UKxdXZKsNlVOZLwSS72Lnv8udoCFzBHj8U4Cx737Xx+JndHu
         cIJI/EN2th46jvJOaItIO/ylH+eguAZnWAGA+qQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gary van der Merwe <gary.vandermerwe@fnb.co.za>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 014/667] USB: serial: pl2303: fix type detection for odd device
Date:   Tue,  7 Jun 2022 18:54:39 +0200
Message-Id: <20220607164935.217889587@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit e82e7c6dde91acd6748d672a44dc1980ce239f86 upstream.

At least one pl2303 device has a bcdUSB of 1.0.1 which most likely was
was intended as 1.1.

Allow bcdDevice 1.0.1 but interpret it as 1.1.

Fixes: 1e9faef4d26d ("USB: serial: pl2303: fix HX type detection")
Cc: stable@vger.kernel.org      # 5.13
Link: https://lore.kernel.org/linux-usb/CAJixRzqf4a9-ZKZDgWxicc_BpfdZVE9qqGmkiO7xEstOXUbGvQ@mail.gmail.com
Reported-by: Gary van der Merwe <gary.vandermerwe@fnb.co.za>
Link: https://lore.kernel.org/r/20220517161736.13313-1-johan@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -421,6 +421,9 @@ static int pl2303_detect_type(struct usb
 	bcdUSB = le16_to_cpu(desc->bcdUSB);
 
 	switch (bcdUSB) {
+	case 0x101:
+		/* USB 1.0.1? Let's assume they meant 1.1... */
+		fallthrough;
 	case 0x110:
 		switch (bcdDevice) {
 		case 0x300:


