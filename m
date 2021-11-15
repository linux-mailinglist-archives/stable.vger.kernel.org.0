Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC8845138D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348406AbhKOTwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:52:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343632AbhKOTVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E69E16336C;
        Mon, 15 Nov 2021 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001815;
        bh=K4WgcWdgl0jd5oBXbJ6i7dW+iBIMQbZxXgJ2HxstZQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bU3F5/Sh9b4HhwrcaSuESxrsEQB5Du5KL9BxBBoOzK2wbt+Bp7qnKdHzW3H/VFuYW
         lCbv06QVuIY72jclqI4bHk+93W/JTcHfjP58c8UdpugawHbtsc41b10wR0rFMz68AM
         ximWEQ7lu3edwYosFLoypsojVLWUwveem6Z1WTD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+7d41312fe3f123a6f605@syzkaller.appspotmail.com
Subject: [PATCH 5.15 331/917] Bluetooth: hci_uart: fix GPF in h5_recv
Date:   Mon, 15 Nov 2021 17:57:06 +0100
Message-Id: <20211115165439.981950411@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 2fc7acb69fa3573d4bf7a90c323296d840daf330 ]

Syzbot hit general protection fault in h5_recv(). The problem was in
missing NULL check.

hu->serdev can be NULL and we cannot blindly pass &serdev->dev
somewhere, since it can cause GPF.

Fixes: d9dd833cf6d2 ("Bluetooth: hci_h5: Add runtime suspend")
Reported-and-tested-by: syzbot+7d41312fe3f123a6f605@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index 0c0dedece59c5..eb0099a212888 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -587,9 +587,11 @@ static int h5_recv(struct hci_uart *hu, const void *data, int count)
 		count -= processed;
 	}
 
-	pm_runtime_get(&hu->serdev->dev);
-	pm_runtime_mark_last_busy(&hu->serdev->dev);
-	pm_runtime_put_autosuspend(&hu->serdev->dev);
+	if (hu->serdev) {
+		pm_runtime_get(&hu->serdev->dev);
+		pm_runtime_mark_last_busy(&hu->serdev->dev);
+		pm_runtime_put_autosuspend(&hu->serdev->dev);
+	}
 
 	return 0;
 }
-- 
2.33.0



