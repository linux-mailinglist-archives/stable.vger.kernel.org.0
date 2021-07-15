Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AA73CA914
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242237AbhGOTFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242356AbhGOTDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3B3261406;
        Thu, 15 Jul 2021 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375572;
        bh=7u9XNPOxI8rNQ621yv6IIIKnWaV8nYyvd7/1i3zXoNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8Z6TptgfD1n4TE75cE/ed9Dm6qKuCF4lADvWR5j+5MHkKCMF+UveRn9wTXgO0Pyo
         B5hABqgY+++m4I8f4DLOJVEAtxZRuw9IvrM8oYg5F3wGV+HAUh52Kk9cHnFn+hz8xW
         kEqtWOCXQ7lD3hIq2PKnVojKG/p1lFgYHHlBotuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 143/242] Bluetooth: mgmt: Fix the command returns garbage parameter value
Date:   Thu, 15 Jul 2021 20:38:25 +0200
Message-Id: <20210715182618.306931062@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tedd Ho-Jeong An <tedd.an@intel.com>

[ Upstream commit 02ce2c2c24024aade65a8d91d6a596651eaf2d0a ]

When the Get Device Flags command fails, it returns the error status
with the parameters filled with the garbage values. Although the
parameters are not used, it is better to fill with zero than the random
values.

Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 06e24b5e164d..b4f6773b1a5b 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4056,6 +4056,8 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
+	memset(&rp, 0, sizeof(rp));
+
 	if (cp->addr.type == BDADDR_BREDR) {
 		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
 							      &cp->addr.bdaddr,
-- 
2.30.2



