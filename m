Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5155F2A8F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbiJCHht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbiJCHgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:36:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647F651A38;
        Mon,  3 Oct 2022 00:22:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96B8AB80E83;
        Mon,  3 Oct 2022 07:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BE6C433C1;
        Mon,  3 Oct 2022 07:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781639;
        bh=6pZ6UQlxPLXtJOJyXlnGRVygfTHsLZc0+Seg8suUn4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Su54NdFDKqB7jeDhKAjEt5JQV/lNI0TElTgeNjAJDcaeFX7IbmT/E5vVqvMqYenFU
         63GF7aETMNWbeqHP1rEQEHipiGPo0c/3F/gOA9dYUJzBV3SqbV1jLEBcnQoR77jSKq
         pqzUa70ci0aRKmIZsmrdPbf3worV6s1S5Fmn3Mow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        stable <stable@kernel.org>,
        Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH 5.10 10/52] uas: ignore UAS for Thinkplus chips
Date:   Mon,  3 Oct 2022 09:11:17 +0200
Message-Id: <20221003070719.028107446@linuxfoundation.org>
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

commit 0fb9703a3eade0bb84c635705d9c795345e55053 upstream.

The UAS mode of Thinkplus(0x17ef, 0x3899) is reported to influence
performance and trigger kernel panic on several platforms with the
following error message:

[   39.702439] xhci_hcd 0000:0c:00.3: ERROR Transfer event for disabled
               endpoint or incorrect stream ring
[   39.702442] xhci_hcd 0000:0c:00.3: @000000026c61f810 00000000 00000000
               1b000000 05038000

[  720.545894][13] Workqueue: usb_hub_wq hub_event
[  720.550971][13]  ffff88026c143c38 0000000000016300 ffff8802755bb900 ffff880
                    26cb80000
[  720.559673][13]  ffff88026c144000 ffff88026ca88100 0000000000000000 ffff880
                    26cb80000
[  720.568374][13]  ffff88026cb80000 ffff88026c143c50 ffffffff8186ae25 ffff880
                    26ca880f8
[  720.577076][13] Call Trace:
[  720.580201][13]  [<ffffffff8186ae25>] schedule+0x35/0x80
[  720.586137][13]  [<ffffffff8186b0ce>] schedule_preempt_disabled+0xe/0x10
[  720.593623][13]  [<ffffffff8186cb94>] __mutex_lock_slowpath+0x164/0x1e0
[  720.601012][13]  [<ffffffff8186cc3f>] mutex_lock+0x2f/0x40
[  720.607141][13]  [<ffffffff8162b8e9>] usb_disconnect+0x59/0x290

Falling back to USB mass storage can solve this problem, so ignore UAS
function of this chip.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://lore.kernel.org/r/1663902249837086.19.seg@mailgw
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -132,6 +132,13 @@ UNUSUAL_DEV(0x154b, 0xf00d, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
 
+/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
+UNUSUAL_DEV(0x17ef, 0x3899, 0x0000, 0x9999,
+		"Thinkplus",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
 UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
 		"VIA",


