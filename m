Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056CE4ABAA6
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383972AbiBGLYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244455AbiBGLK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:10:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008F1C043181;
        Mon,  7 Feb 2022 03:10:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92A9E61388;
        Mon,  7 Feb 2022 11:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DF1C004E1;
        Mon,  7 Feb 2022 11:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232226;
        bh=u4195M9uifM8d22mIW+olg3HBt73pJGFVtNfQc0j3uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZswFb9iNtEt+P1AduvXYk+WOy04ueQT+YY20JX9EELgmJJCfCW/kZbCGUvS3CE7NQ
         9QCE3zepGE4t+sv5ZPjge44j3oUwQqGn+ShgaTE/THvw83WpJPxTjR3TwGPX62Md5K
         us48u4nYpwGj62zE9odCBv/SdpEXRNuxyd+KyaxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Gix <brian.gix@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        syphyr <syphyr@gmail.com>
Subject: [PATCH 4.14 01/69] Bluetooth: refactor malicious adv data check
Date:   Mon,  7 Feb 2022 12:05:23 +0100
Message-Id: <20220207103755.654351240@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Brian Gix <brian.gix@intel.com>

commit 899663be5e75dc0174dc8bda0b5e6826edf0b29a upstream.

Check for out-of-bound read was being performed at the end of while
num_reports loop, and would fill journal with false positives. Added
check to beginning of loop processing so that it doesn't get checked
after ptr has been advanced.

Signed-off-by: Brian Gix <brian.gix@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: syphyr <syphyr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4967,6 +4967,11 @@ static void hci_le_adv_report_evt(struct
 		struct hci_ev_le_advertising_info *ev = ptr;
 		s8 rssi;
 
+		if (ptr > (void *)skb_tail_pointer(skb) - sizeof(*ev)) {
+			bt_dev_err(hdev, "Malicious advertising data.");
+			break;
+		}
+
 		if (ev->length <= HCI_MAX_AD_LENGTH &&
 		    ev->data + ev->length <= skb_tail_pointer(skb)) {
 			rssi = ev->data[ev->length];
@@ -4978,11 +4983,6 @@ static void hci_le_adv_report_evt(struct
 		}
 
 		ptr += sizeof(*ev) + ev->length + 1;
-
-		if (ptr > (void *) skb_tail_pointer(skb) - sizeof(*ev)) {
-			bt_dev_err(hdev, "Malicious advertising data. Stopping processing");
-			break;
-		}
 	}
 
 	hci_dev_unlock(hdev);


