Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455EE4D5C9
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfFTSBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbfFTSBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:01:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9A0D2083B;
        Thu, 20 Jun 2019 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053662;
        bh=n0eUZ/U4rMjPxOlzziQdo233Akn4AXtfI8W4B17cSXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8tLdrd975b3YkVyzKQakKxlgf4Me2MlCJEssc4jeyk+ACv0AOKr4JWg+ESo0UW8K
         iHTx7F7JEllGqR67+jeaDKhd7YHHMxe6NBIaM68sGPibqiSqqP9uaxWaUkrlaR0XHQ
         aM+RV9BKBdGMMR3KdaHNYifWVK5XOsY5Fr+nUUu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jeremy Cline <jeremy@jcline.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [PATCH 4.4 39/84] Revert "Bluetooth: Align minimum encryption key size for LE and BR/EDR connections"
Date:   Thu, 20 Jun 2019 19:56:36 +0200
Message-Id: <20190620174344.217870954@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit d016dc1bd29a2cfb0707fc6fb290ccd21f3b139c which is
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
@@ -174,9 +174,6 @@ struct adv_info {
 
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
-/* Min encryption key size to match with SMP */
-#define HCI_MIN_ENC_KEY_SIZE		7
-
 /* Default LE RPA expiry time, 15 minutes */
 #define HCI_DEFAULT_RPA_TIMEOUT		(15 * 60)
 
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1177,14 +1177,6 @@ int hci_conn_check_link_mode(struct hci_
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
 


