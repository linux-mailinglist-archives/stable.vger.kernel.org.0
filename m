Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5CC328A4A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbhCASO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239439AbhCASIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70A23652BD;
        Mon,  1 Mar 2021 17:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620189;
        bh=w7SuuQNvHSulPmFMX06aK9J/q1GaCsVQxM7UkukwzFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y02rv8cEW5PrCNLxZCvEOl8gNcY8HHQgbWUV3lQIajNrnR/19YkRWFcSJLI0OxBgD
         tHMg1i1pffRVIXu+33sYVtULLo0nSahsq0wCI+ADf85N35R8TmoPRtHxEjxBffStkp
         piSHHt/QnMAY+SdEdH3ytYXzLRimwLo0bk2/OXfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 062/775] Bluetooth: Put HCI device if inquiry procedure interrupts
Date:   Mon,  1 Mar 2021 17:03:50 +0100
Message-Id: <20210301161204.746031668@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 9d2c9a1c552fd..9f8573131b97e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1362,8 +1362,10 @@ int hci_inquiry(void __user *arg)
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



