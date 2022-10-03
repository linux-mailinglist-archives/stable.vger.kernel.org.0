Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368645F2A5F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiJCHfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiJCHef (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D70A52E70;
        Mon,  3 Oct 2022 00:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 214F4B80E96;
        Mon,  3 Oct 2022 07:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E771C433D6;
        Mon,  3 Oct 2022 07:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781704;
        bh=gcoji+IwOaxVnG3o+SYR8ObBzpQCYYfcz8oCmzRPUrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FhTEUQj6mn77E26n4AB/pQb4BNDAhKyKrR9KCwq12v7yu4HAQZonZdtXUWf0mNUUN
         J4HxpV7gBDdw0WdnGfv5tVmkBoBCapTjdeJFGawnwMTfeC2jN1IG+Jcwv95hZL+Lev
         P7LHusxx/69M1jvYH8PdfssE7DVSX254Aoprofx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        stable <stable@kernel.org>,
        Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH 5.10 09/52] usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS
Date:   Mon,  3 Oct 2022 09:11:16 +0200
Message-Id: <20221003070718.999017483@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

commit e00b488e813f0f1ad9f778e771b7cd2fe2877023 upstream.

The UAS mode of Hiksemi USB_HDD is reported to fail to work on several
platforms with the following error message, then after re-connecting the
device will be offlined and not working at all.

[  592.518442][ 2] sd 8:0:0:0: [sda] tag#17 uas_eh_abort_handler 0 uas-tag 18
                   inflight: CMD
[  592.527575][ 2] sd 8:0:0:0: [sda] tag#17 CDB: Write(10) 2a 00 03 6f 88 00 00
                   04 00 00
[  592.536330][ 2] sd 8:0:0:0: [sda] tag#0 uas_eh_abort_handler 0 uas-tag 1
                   inflight: CMD
[  592.545266][ 2] sd 8:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 07 44 1a 88 00
                   00 08 00

These disks have a broken uas implementation, the tag field of the status
iu-s is not set properly,so we need to fall-back to usb-storage.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://lore.kernel.org/r/1663901185-21067-1-git-send-email-zenghongling@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -83,6 +83,13 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
+/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
+UNUSUAL_DEV(0x0bda, 0x9210, 0x0000, 0x9999,
+		"Hiksemi",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",


