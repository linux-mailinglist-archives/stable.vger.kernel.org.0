Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B56232897F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbhCAR5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:57:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238754AbhCARvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:51:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F2A652F5;
        Mon,  1 Mar 2021 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620453;
        bh=dPIOmJP3R18DZXnGJJXJSsYn26gESrWgUgiNVrmHrpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nH/UO4lXE17oxHjKo0iAaUFPSu7poqqLrmSLCQgF0UigIA4Zz7wA4uZISJKcPqMYB
         DR9YAfjm8Xjd+1BuEYDZ8c1tU9duwPXOF5qAxefh1Ai4kAWMo527mdau+Iy+KVWfok
         Vv6gjTM0WjNH8uGLdC/zQsc8leHesJU6dSzia3f0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 158/775] Bluetooth: hci_qca: check for SSR triggered flag while suspend
Date:   Mon,  1 Mar 2021 17:05:26 +0100
Message-Id: <20210301161209.451696884@linuxfoundation.org>
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

[ Upstream commit 1bb0c66332babc5cbc4581d962da0b03af9f23e8 ]

QCA_IBS_DISABLED flag will be set after memorydump started from
controller.Currently qca_suspend() is waiting for SSR to complete
based on flag QCA_IBS_DISABLED.Added to check for QCA_SSR_TRIGGERED
flag too.

Fixes: 2be43abac5a8 ("Bluetooth: hci_qca: Wait for timeout during suspend")
Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 17a3859326dc7..ff2fb68a45b1e 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2111,7 +2111,8 @@ static int __maybe_unused qca_suspend(struct device *dev)
 	    !test_bit(QCA_SSR_TRIGGERED, &qca->flags))
 		return 0;
 
-	if (test_bit(QCA_IBS_DISABLED, &qca->flags)) {
+	if (test_bit(QCA_IBS_DISABLED, &qca->flags) ||
+	    test_bit(QCA_SSR_TRIGGERED, &qca->flags)) {
 		wait_timeout = test_bit(QCA_SSR_TRIGGERED, &qca->flags) ?
 					IBS_DISABLE_SSR_TIMEOUT_MS :
 					FW_DOWNLOAD_TIMEOUT_MS;
-- 
2.27.0



