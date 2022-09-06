Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129DF5AEBAB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241591AbiIFOO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241738AbiIFOOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:14:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C91289921;
        Tue,  6 Sep 2022 06:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93FF4B818E2;
        Tue,  6 Sep 2022 13:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F021AC4314A;
        Tue,  6 Sep 2022 13:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472042;
        bh=0IlhPDcg+N1l9IGYJ4pYlrDwi/O4Kivf2evnYygpIEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CQR/aZPdZhPtsVJKyc03mKhIlFnMMJERVWefi1uDeSRXuNI6Ui+nf2oTAQcBD04F
         aGWW304K4wtz49rzEbTXxi/kcbmFPfkirEhSPs0gEaBepInO/x7lA8uuXjx/JZJ9lV
         f6kn2tIutVFWS/GmLKAWeWTG0jgELfZ4e8pS7b6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        stable <stable@kernel.org>,
        Witold Lipieta <witold.lipieta@thaumatec.com>
Subject: [PATCH 5.19 127/155] usb-storage: Add ignore-residue quirk for NXP PN7462AU
Date:   Tue,  6 Sep 2022 15:31:15 +0200
Message-Id: <20220906132834.815468731@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
@@ -2294,6 +2294,13 @@ UNUSUAL_DEV( 0x1e74, 0x4621, 0x0000, 0x0
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


