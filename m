Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04063C4A5A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238156AbhGLGwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235650AbhGLGsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:48:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 011166100B;
        Mon, 12 Jul 2021 06:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072243;
        bh=c5j3EHFQ1Uz2hO9RdP9Fr7Er0U4ZMMPMDvUCIvdSMgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOzrsBGcZ3bFdOVYESboEjagv8E8pYcR1jjobeF6Bxhw3gG6ceLM5W4r28s0ReExw
         AjcO1KIKDP0U9ZjSizH+/XCVmDd19vw6Rm1fq0ZAXZa8WtxwjxyOK3o2N6x7F0GWAi
         2wfdWU2LYRIf8Lp8VHfiy/L+RCm5F/DoV9WG5LWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 414/593] Bluetooth: Fix not sending Set Extended Scan Response
Date:   Mon, 12 Jul 2021 08:09:34 +0200
Message-Id: <20210712060933.575604580@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit a76a0d365077711594ce200a9553ed6d1ff40276 ]

Current code is actually failing on the following tests of mgmt-tester
because get_adv_instance_scan_rsp_len did not account for flags that
cause scan response data to be included resulting in non-scannable
instance when in fact it should be scannable.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_request.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 161ea93a5382..33dc78c24b73 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1060,9 +1060,10 @@ static u8 get_adv_instance_scan_rsp_len(struct hci_dev *hdev, u8 instance)
 	if (!adv_instance)
 		return 0;
 
-	/* TODO: Take into account the "appearance" and "local-name" flags here.
-	 * These are currently being ignored as they are not supported.
-	 */
+	if (adv_instance->flags & MGMT_ADV_FLAG_APPEARANCE ||
+	    adv_instance->flags & MGMT_ADV_FLAG_LOCAL_NAME)
+		return 1;
+
 	return adv_instance->scan_rsp_len;
 }
 
@@ -1599,14 +1600,11 @@ void __hci_req_update_scan_rsp_data(struct hci_request *req, u8 instance)
 
 		memset(&cp, 0, sizeof(cp));
 
-		/* Extended scan response data doesn't allow a response to be
-		 * set if the instance isn't scannable.
-		 */
-		if (get_adv_instance_scan_rsp_len(hdev, instance))
+		if (instance)
 			len = create_instance_scan_rsp_data(hdev, instance,
 							    cp.data);
 		else
-			len = 0;
+			len = create_default_scan_rsp_data(hdev, cp.data);
 
 		if (hdev->scan_rsp_data_len == len &&
 		    !memcmp(cp.data, hdev->scan_rsp_data, len))
-- 
2.30.2



