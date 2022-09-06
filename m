Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307B65AEBA8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbiIFOA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240879AbiIFN7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:59:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC6E82F82;
        Tue,  6 Sep 2022 06:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 742A4B81633;
        Tue,  6 Sep 2022 13:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71A8C433D6;
        Tue,  6 Sep 2022 13:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471762;
        bh=tzMDEAsfa3gwbxU1qF3MdqOlVGgPO1VqB1vPdgcwpXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnxJhK0fTIZO/3YH6CUu7Doq3O4rNlIXyftALURIExZfBz97+ndJO2kRpiu9Z47Yu
         43c+kavU68tI2eHrQN2vavosMdCSEp6LX89YxI0P8xI/eJ/6xcRa1poRA0PCxIhKhs
         B/tEhSY/i73Dac2j+DLmvY678L1IClgHn0RNBzdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 029/155] Bluetooth: hci_event: Fix vendor (unknown) opcode status handling
Date:   Tue,  6 Sep 2022 15:29:37 +0200
Message-Id: <20220906132830.662531556@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b82a26d8633cc89367fac75beb3ec33061bea44a ]

Commit c8992cffbe74 ("Bluetooth: hci_event: Use of a function table to
handle Command Complete") was (presumably) meant to only refactor things
without any functional changes.

But it does have one undesirable side-effect, before *status would always
be set to skb->data[0] and it might be overridden by some of the opcode
specific handling. While now it always set by the opcode specific handlers.
This means that if the opcode is not known *status does not get set any
more at all!

This behavior change has broken bluetooth support for BCM4343A0 HCIs,
the hci_bcm.c code tries to configure UART attached HCIs at a higher
baudraute using vendor specific opcodes. The BCM4343A0 does not
support this and this used to simply fail:

[   25.646442] Bluetooth: hci0: BCM: failed to write clock (-56)
[   25.646481] Bluetooth: hci0: Failed to set baudrate

After which things would continue with the initial baudraute. But now
that hci_cmd_complete_evt() no longer sets status for unknown opcodes
*status is left at 0. This causes the hci_bcm.c code to think the baudraute
has been changed on the HCI side and to also adjust the UART baudrate,
after which communication with the HCI is broken, leading to:

[   28.579042] Bluetooth: hci0: command 0x0c03 tx timeout
[   36.961601] Bluetooth: hci0: BCM: Reset failed (-110)

And non working bluetooth. Fix this by restoring the previous
default "*status = skb->data[0]" handling for unknown opcodes.

Fixes: c8992cffbe74 ("Bluetooth: hci_event: Use of a function table to handle Command Complete")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7cb956d3abb26..67c61f5240596 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3998,6 +3998,17 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, void *data,
 		}
 	}
 
+	if (i == ARRAY_SIZE(hci_cc_table)) {
+		/* Unknown opcode, assume byte 0 contains the status, so
+		 * that e.g. __hci_cmd_sync() properly returns errors
+		 * for vendor specific commands send by HCI drivers.
+		 * If a vendor doesn't actually follow this convention we may
+		 * need to introduce a vendor CC table in order to properly set
+		 * the status.
+		 */
+		*status = skb->data[0];
+	}
+
 	handle_cmd_cnt_and_timer(hdev, ev->ncmd);
 
 	hci_req_cmd_complete(hdev, *opcode, *status, req_complete,
-- 
2.35.1



