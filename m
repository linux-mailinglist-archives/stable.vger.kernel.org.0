Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223DC44276
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbfFMQWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731036AbfFMIiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:38:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D3CD21473;
        Thu, 13 Jun 2019 08:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415080;
        bh=JlR8HdzcLiHyScAA35m007DD1WT4CMGpDisD1am2USg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqeNK4Fbmu+dNtrRak2/LKkeekDF8RHPYFYhHkTxt7abns7pvlkCbLMtzi1hJqEhj
         7OTM7x2Jg2TyYjfmh6SqiAmJsU4RxtKclmLA4tBxDMQty1rfBE2+ip0P1cELaysvSi
         sOgWtkmdn0ab3WXgsJXLieg57N+W5N9x06jWPKI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jeremy Cline <jeremy@jcline.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: [PATCH 4.14 79/81] Revert "Bluetooth: Align minimum encryption key size for LE and BR/EDR connections"
Date:   Thu, 13 Jun 2019 10:34:02 +0200
Message-Id: <20190613075654.815196365@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 2fa7a155b25160696cd77cdd995536cf5e172e20 which is
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
@@ -178,9 +178,6 @@ struct adv_info {
 
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
 


