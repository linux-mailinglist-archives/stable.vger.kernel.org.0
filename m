Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354BF328F8B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242278AbhCATw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242197AbhCAToD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 400FD652F9;
        Mon,  1 Mar 2021 17:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620455;
        bh=ESh+qrw8wEVUcxAVIYmxnHPQXSSstdMEGhB96+bNHyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yb+Ty/wdbYIb9QB86Z6Y9ah5gzdw+zgZxCKNXD/wMcRUx/xs0fV/E4rsFu/wQkYeB
         f8f7vm+sshf7PJ4QdVXJMaD2xLs9kjB1xxMRbig9FrE8DWcaqTjo72TVjYdBpzpKFF
         QXO+03LZyF0FreGCPV19+tOXc+ow6FwRl4J5KUe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 159/775] Bluetooth: hci_qca: Fixed issue during suspend
Date:   Mon,  1 Mar 2021 17:05:27 +0100
Message-Id: <20210301161209.498703774@linuxfoundation.org>
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

From: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>

[ Upstream commit 55c0bd77479b60ea29fd390faf4545cfb3a1d79e ]

If BT SoC is running with ROM FW then just return in
qca_suspend function as ROM FW does not support
in-band sleep.

Fixes: 2be43abac5a8 ("Bluetooth: hci_qca: Wait for timeout during suspend")
Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index ff2fb68a45b1e..de36af63e1825 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -77,7 +77,8 @@ enum qca_flags {
 	QCA_MEMDUMP_COLLECTION,
 	QCA_HW_ERROR_EVENT,
 	QCA_SSR_TRIGGERED,
-	QCA_BT_OFF
+	QCA_BT_OFF,
+	QCA_ROM_FW
 };
 
 enum qca_capabilities {
@@ -1664,6 +1665,7 @@ static int qca_setup(struct hci_uart *hu)
 	if (ret)
 		return ret;
 
+	clear_bit(QCA_ROM_FW, &qca->flags);
 	/* Patch downloading has to be done without IBS mode */
 	set_bit(QCA_IBS_DISABLED, &qca->flags);
 
@@ -1721,12 +1723,14 @@ retry:
 		hu->hdev->cmd_timeout = qca_cmd_timeout;
 	} else if (ret == -ENOENT) {
 		/* No patch/nvm-config found, run with original fw/config */
+		set_bit(QCA_ROM_FW, &qca->flags);
 		ret = 0;
 	} else if (ret == -EAGAIN) {
 		/*
 		 * Userspace firmware loader will return -EAGAIN in case no
 		 * patch/nvm-config is found, so run with original fw/config.
 		 */
+		set_bit(QCA_ROM_FW, &qca->flags);
 		ret = 0;
 	}
 
@@ -2103,6 +2107,12 @@ static int __maybe_unused qca_suspend(struct device *dev)
 
 	set_bit(QCA_SUSPENDING, &qca->flags);
 
+	/* if BT SoC is running with default firmware then it does not
+	 * support in-band sleep
+	 */
+	if (test_bit(QCA_ROM_FW, &qca->flags))
+		return 0;
+
 	/* During SSR after memory dump collection, controller will be
 	 * powered off and then powered on.If controller is powered off
 	 * during SSR then we should wait until SSR is completed.
-- 
2.27.0



