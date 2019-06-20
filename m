Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3B8F4D8A0
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfFTS1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727848AbfFTSE0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:04:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADC2E214AF;
        Thu, 20 Jun 2019 18:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053866;
        bh=ctM2SQapt0Lx6e1Wn0ZdgOPmgsvkTgKuDwHVpae+Xd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLMS1tQDyk8pv5oCRJ1gs00Dt3gmLMX3ts2NDRf1k5KNk4gKAHw1w+8WY4CYTH5ZD
         bE8ehD0OgmD+veLBp+2P9wYlQukQwQsUmpGKtU/ubS6tO2sRg2bKvggqoQLfjlEaBV
         crT1AUgFZfS+cfj4jTr2JyPmbRdZM2bBTeyoHIvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jeremy Cline <jeremy@jcline.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [PATCH 4.9 055/117] Revert "Bluetooth: Align minimum encryption key size for LE and BR/EDR connections"
Date:   Thu, 20 Jun 2019 19:56:29 +0200
Message-Id: <20190620174355.811977722@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 745f5c5f2ac14ac1cbb7fe3cbdc893c9d1af1356 which is
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
@@ -176,9 +176,6 @@ struct adv_info {
 
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
-/* Min encryption key size to match with SMP */
-#define HCI_MIN_ENC_KEY_SIZE		7
-
 /* Default LE RPA expiry time, 15 minutes */
 #define HCI_DEFAULT_RPA_TIMEOUT		(15 * 60)
 
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1165,14 +1165,6 @@ int hci_conn_check_link_mode(struct hci_
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
 


