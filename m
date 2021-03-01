Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F93B3284F2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbhCAQpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234881AbhCAQij (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:38:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75C4664F7D;
        Mon,  1 Mar 2021 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616069;
        bh=sF4FK538juLs0dpVfEoKastJooI7Nfv//DR4iCTLwPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Het3rLzotbnq2Xp0R/FSdR5kDWPLMw0HGkq1aocMovtBY8NEzuadAuKsbrUCDLOFk
         x1TH/0lXJ8462upmLTtHPba1TwBsoENRVVWM5ofoKsSkKclWMi4rmurkSza9vmLVnX
         Wgxin6vQ+w82Mp2EAmgR7v4Xw422ALOlPGTUKvqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 023/176] Bluetooth: Put HCI device if inquiry procedure interrupts
Date:   Mon,  1 Mar 2021 17:11:36 +0100
Message-Id: <20210301161022.120569947@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 28a758c861ff290e39d4f1ee0aa5df0f0b9a45ee ]

Jump to the label done to decrement the reference count of HCI device
hdev on path that the Inquiry procedure is interrupted.

Fixes: 3e13fa1e1fab ("Bluetooth: Fix hci_inquiry ioctl usage")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index ff80a9d41ce17..bf1263c1bc766 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1278,8 +1278,10 @@ int hci_inquiry(void __user *arg)
 		 * cleared). If it is interrupted by a signal, return -EINTR.
 		 */
 		if (wait_on_bit(&hdev->flags, HCI_INQUIRY,
-				TASK_INTERRUPTIBLE))
-			return -EINTR;
+				TASK_INTERRUPTIBLE)) {
+			err = -EINTR;
+			goto done;
+		}
 	}
 
 	/* for unlimited number of responses we will use buffer with
-- 
2.27.0



