Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC734E7781
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377213AbiCYP2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377916AbiCYPYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F44EAC8E;
        Fri, 25 Mar 2022 08:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10E9060AB7;
        Fri, 25 Mar 2022 15:19:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9D8C340E9;
        Fri, 25 Mar 2022 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221557;
        bh=T3HgFM18vk7D6Ic08cOMwNAPMz3pNeri0STbdvJnGX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AD1RQS6GnSBYCKgdPSRYTnn3b9cj7dI4TmtI41RULHebyS9LIzoNoLoO4pvHy5Pw+
         yYWpV26Z32pzWjkPGlSY6UCBetlPSdWCv+0XdSk+O1sXsmPgOt+nBTC1HgROmGYo8h
         qmrCCxb0ILJiIJr+H8skzxu4ZcwSVhmsGUiPi+HM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Ismael Ferreras Morezuelas <swyterzone@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.17 27/39] Bluetooth: hci_sync: Add a new quirk to skip HCI_FLT_CLEAR_ALL
Date:   Fri, 25 Mar 2022 16:14:42 +0100
Message-Id: <20220325150421.019666191@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
References: <20220325150420.245733653@linuxfoundation.org>
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

From: Ismael Ferreras Morezuelas <swyterzone@gmail.com>

commit 0eaecfb2e4814d51ab172df3823e35d7c488b6d2 upstream.

Some controllers have problems with being sent a command to clear
all filtering. While the HCI code does not unconditionally
send a clear-all anymore at BR/EDR setup (after the state machine
refactor), there might be more ways of hitting these codepaths
in the future as the kernel develops.

Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci.h |   10 ++++++++++
 net/bluetooth/hci_sync.c    |   16 ++++++++++++++++
 2 files changed, 26 insertions(+)

--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -255,6 +255,16 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_READ_TRANSMIT_POWER,
+
+	/* When this quirk is set, HCI_OP_SET_EVENT_FLT requests with
+	 * HCI_FLT_CLEAR_ALL are ignored and event filtering is
+	 * completely avoided. A subset of the CSR controller
+	 * clones struggle with this and instantly lock up.
+	 *
+	 * Note that devices using this must (separately) disable
+	 * runtime suspend, because event filtering takes place there.
+	 */
+	HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL,
 };
 
 /* HCI device flags */
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2806,6 +2806,9 @@ static int hci_set_event_filter_sync(str
 	if (!hci_dev_test_flag(hdev, HCI_BREDR_ENABLED))
 		return 0;
 
+	if (test_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks))
+		return 0;
+
 	memset(&cp, 0, sizeof(cp));
 	cp.flt_type = flt_type;
 
@@ -2826,6 +2829,13 @@ static int hci_clear_event_filter_sync(s
 	if (!hci_dev_test_flag(hdev, HCI_EVENT_FILTER_CONFIGURED))
 		return 0;
 
+	/* In theory the state machine should not reach here unless
+	 * a hci_set_event_filter_sync() call succeeds, but we do
+	 * the check both for parity and as a future reminder.
+	 */
+	if (test_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks))
+		return 0;
+
 	return hci_set_event_filter_sync(hdev, HCI_FLT_CLEAR_ALL, 0x00,
 					 BDADDR_ANY, 0x00);
 }
@@ -4825,6 +4835,12 @@ static int hci_update_event_filter_sync(
 	if (!hci_dev_test_flag(hdev, HCI_BREDR_ENABLED))
 		return 0;
 
+	/* Some fake CSR controllers lock up after setting this type of
+	 * filter, so avoid sending the request altogether.
+	 */
+	if (test_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks))
+		return 0;
+
 	/* Always clear event filter when starting */
 	hci_clear_event_filter_sync(hdev);
 


