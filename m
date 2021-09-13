Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6338A4094BF
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344183AbhIMOeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346522AbhIMObv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85B9B61BA9;
        Mon, 13 Sep 2021 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541123;
        bh=+96fkkbZQsma8OSwkTE3iaeZ3NjW2TCk6+HNUL2M4I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fvpQIwm7XXOGv+hjCconlWfi7u9la/nB12F9ecXs2YHeLATpKQK+n1fffUmp3FeZ
         Cpoza3yK8vNtiy95lDhNofLUjnChYHat5l5SDktvRweBQ0xoYVS6xwhAyoZLE1DuW0
         Bz0/wuPuxZklYUTiVoWbkSEqlGluHM48R0twQVLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 140/334] Bluetooth: mgmt: Fix wrong opcode in the response for add_adv cmd
Date:   Mon, 13 Sep 2021 15:13:14 +0200
Message-Id: <20210913131118.089920148@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tedd Ho-Jeong An <tedd.an@intel.com>

[ Upstream commit a25fca4d3c18766b6f7a3c95fa8faec23ef464c5 ]

This patch fixes the MGMT add_advertising command repsones with the
wrong opcode when it is trying to return the not supported error.

Fixes: cbbdfa6f33198 ("Bluetooth: Enable controller RPA resolution using Experimental feature")
Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 3663f880df11..1e21e014efd2 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7725,7 +7725,7 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	 * advertising.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY))
-		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_ADVERTISING,
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 				       MGMT_STATUS_NOT_SUPPORTED);
 
 	if (cp->instance < 1 || cp->instance > hdev->le_num_of_adv_sets)
-- 
2.30.2



