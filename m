Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014665B747E
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiIMPYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbiIMPXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:23:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9207C776;
        Tue, 13 Sep 2022 07:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66BCCB80FF2;
        Tue, 13 Sep 2022 14:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF43C433D7;
        Tue, 13 Sep 2022 14:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079727;
        bh=2hBL8XigB4HHBKerBlukkri/okODgJyoejnjyoF4k9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cxy8gO0xlwArwt6xptp8KgdtN0CcOqBRSuo2YOipFINF62qpn6OTVLkq9d4lMjzxZ
         IeNqsKKQHOlaznSTN1z8h53l6TNxrBEbJ0jqZG/9QKN5v6JRxedu3UwXnUWjgcuUh5
         d1KXPspxDIo9OOm29w5GcwZ5BqJ3gjCcNBlAYv4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        stable <stable@kernel.org>,
        Witold Lipieta <witold.lipieta@thaumatec.com>
Subject: [PATCH 4.14 25/61] usb-storage: Add ignore-residue quirk for NXP PN7462AU
Date:   Tue, 13 Sep 2022 16:07:27 +0200
Message-Id: <20220913140347.759074778@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Witold Lipieta <witold.lipieta@thaumatec.com>

commit 2aa48857ad52236a9564c71183d6cc8893becd41 upstream.

This is USB mass storage primary boot loader for code download on
NXP PN7462AU.

Without the quirk it is impossible to write whole memory at once as
device restarts during the write due to bogus residue values reported.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Witold Lipieta <witold.lipieta@thaumatec.com>
Link: https://lore.kernel.org/r/20220809112911.462776-1-witold.lipieta@thaumatec.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2313,6 +2313,13 @@ UNUSUAL_DEV( 0x1e74, 0x4621, 0x0000, 0x0
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
 
+/* Reported by Witold Lipieta <witold.lipieta@thaumatec.com> */
+UNUSUAL_DEV( 0x1fc9, 0x0117, 0x0100, 0x0100,
+		"NXP Semiconductors",
+		"PN7462AU",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE ),
+
 /* Supplied with some Castlewood ORB removable drives */
 UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x9999,
 		"Double-H Technology",


