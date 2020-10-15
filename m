Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CB328FA8B
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 23:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgJOVTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 17:19:19 -0400
Received: from aer-iport-1.cisco.com ([173.38.203.51]:19033 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgJOVTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 17:19:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1842; q=dns/txt; s=iport;
  t=1602796758; x=1604006358;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7cMXzNOF9J//04TbRvfrLASSiRGZ/tV0OqpQHR+3loQ=;
  b=KppQssNGeCKPEbGh5gEx0hwIGdHJu1z0iwvGPgYWaQ5bjt6Aly/4ocNM
   RNZsKCHe4AuveLqxfBkjCXb1K0+xQY37mqOjY4MDOrG87kwqZQVpHSv0B
   OyRshLB6+b6tFyBngLXa1YzmjytoAqtB0TnXrmToECs7alD5FLMNNSMCp
   I=;
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DZBAB4uohf/xbLJq1ghkcBIBIsjT+?=
 =?us-ascii?q?IGJwmCwEBAQ8vBAEBhEoCggkmOBMCAwEBCwEBBQEBAQIBBgRthWiFcwYnCwF?=
 =?us-ascii?q?GECAxVxmDJoJ9rE6BdTOKW4E4iDeEYTMGgUE/g3NshASBBoUqBJAlN6ccgnS?=
 =?us-ascii?q?aXw8igxaeNC2OHIZenlqBayOBV00jFYMkUBkNjisXFI4SPwMwAjYCBgoBAQM?=
 =?us-ascii?q?JjAKCRgEB?=
X-IronPort-AV: E=Sophos;i="5.77,380,1596499200"; 
   d="scan'208";a="30387898"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 15 Oct 2020 21:12:04 +0000
Received: from hce-anki.rd.cisco.com ([10.47.78.239])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 09FLC3V4020717;
        Thu, 15 Oct 2020 21:12:04 GMT
From:   Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
To:     linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Patrick Steinhardt <ps@pks.im>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, stable@vger.kernel.org
Subject: [v4.9..v5.4/bluetooth PATCH 2/3] Bluetooth: Fix update of connection state in `hci_encrypt_cfm`
Date:   Thu, 15 Oct 2020 23:12:01 +0200
Message-Id: <20201015211202.1188015-2-hegtvedt@cisco.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201015211202.1188015-1-hegtvedt@cisco.com>
References: <20201015211202.1188015-1-hegtvedt@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 10.47.78.239, [10.47.78.239]
X-Outbound-Node: aer-core-1.cisco.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Steinhardt <ps@pks.im>

Starting with the upgrade to v5.8-rc3, I've noticed I wasn't able to
connect to my Bluetooth headset properly anymore. While connecting to
the device would eventually succeed, bluetoothd seemed to be confused
about the current connection state where the state was flapping hence
and forth. Bisecting this issue led to commit 3ca44c16b0dc (Bluetooth:
Consolidate encryption handling in hci_encrypt_cfm, 2020-05-19), which
refactored `hci_encrypt_cfm` to also handle updating the connection
state.

The commit in question changed the code to call `hci_connect_cfm` inside
`hci_encrypt_cfm` and to change the connection state. But with the
conversion, we now only update the connection state if a status was set
already. In fact, the reverse should be true: the status should be
updated if no status is yet set. So let's fix the isuse by reversing the
condition.

Fixes: 3ca44c16b0dc ("Bluetooth: Consolidate encryption handling in hci_encrypt_cfm")
Signed-off-by: Patrick Steinhardt <ps@pks.im>
Acked-by:  Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
(cherry picked from commit 339ddaa626995bc6218972ca241471f3717cc5f4)
Cc: stable@vger.kernel.org # 4.9..5.4
---
 include/net/bluetooth/hci_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ffd0eedd27ab..144f580556f9 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1314,7 +1314,7 @@ static inline void hci_encrypt_cfm(struct hci_conn *conn, __u8 status)
 	__u8 encrypt;
 
 	if (conn->state == BT_CONFIG) {
-		if (status)
+		if (!status)
 			conn->state = BT_CONNECTED;
 
 		hci_connect_cfm(conn, status);
-- 
2.27.0

