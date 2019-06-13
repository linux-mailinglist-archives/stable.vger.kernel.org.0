Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C5643F3E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731841AbfFMPzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731533AbfFMIvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:51:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22D0D21473;
        Thu, 13 Jun 2019 08:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415891;
        bh=e12xH+UmhDSQmVu0wlMCeN9EoyGK+UZJOaudMdluF+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIa77YgmdzcNSuIQEnbRHlvvzasX7mSm8t2bqraK5AD/VK0b67X3AoY02OTLzWTtE
         9dw+xkp0pcRcoyU9+onRw1HKkKLrrpj75Xlxwt1FjPfio/SnsHyYuTMlqa+ClX0pfD
         SI3fbCmFBEj3GK12bf421/HOnRn3m7aTLZSPse2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jeremy Cline <jeremy@jcline.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [PATCH 5.1 152/155] Revert "Bluetooth: Align minimum encryption key size for LE and BR/EDR connections"
Date:   Thu, 13 Jun 2019 10:34:24 +0200
Message-Id: <20190613075701.309484157@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 07e38998a19d72b916c39a983c19134522ae806b which is
commit d5bb334a8e171b262e48f378bd2096c0ea458265 upstream.

Lots of people have reported issues with this patch, and as there does
not seem to be a fix going into Linus's kernel tree any time soon,
revert the commit in the stable trees so as to get people's machines
working properly again.

Reported-by: Vasily Khoruzhick <anarsoul@gmail.com>
Reported-by: Hans de Goede <hdegoede@redhat.com>
Cc: Jeremy Cline <jeremy@jcline.org>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    3 ---
 net/bluetooth/hci_conn.c         |    8 --------
 2 files changed, 11 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -190,9 +190,6 @@ struct adv_info {
 
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
-/* Min encryption key size to match with SMP */
-#define HCI_MIN_ENC_KEY_SIZE		7
-
 /* Default LE RPA expiry time, 15 minutes */
 #define HCI_DEFAULT_RPA_TIMEOUT		(15 * 60)
 
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1276,14 +1276,6 @@ int hci_conn_check_link_mode(struct hci_
 	    !test_bit(HCI_CONN_ENCRYPT, &conn->flags))
 		return 0;
 
-	/* The minimum encryption key size needs to be enforced by the
-	 * host stack before establishing any L2CAP connections. The
-	 * specification in theory allows a minimum of 1, but to align
-	 * BR/EDR and LE transports, a minimum of 7 is chosen.
-	 */
-	if (conn->enc_key_size < HCI_MIN_ENC_KEY_SIZE)
-		return 0;
-
 	return 1;
 }
 


