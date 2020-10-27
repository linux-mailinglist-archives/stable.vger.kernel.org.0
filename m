Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E6A29C570
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757088AbgJ0SIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757077AbgJ0OQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:16:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E809C206F7;
        Tue, 27 Oct 2020 14:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808168;
        bh=J6OGZAiQozaY26mh8s6dWmCxIxGtlDI7EIIuEcOGoMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ST7MFw/+72rqusuTw9SFJphXL759zUl088liu9Cg7F8D9IgyBp8YN+8wFdeqtj13P
         63VHm/6VSAZR19zi7SevRbpDdY30xAI7DZ4Gtm7OqHvmXR4DPclrOKwvG5ZRTYBauy
         sYI8Vl77JiC5lkaTEnflIoy3fnp7sbXUPA4fJs9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 182/191] brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach
Date:   Tue, 27 Oct 2020 14:50:37 +0100
Message-Id: <20201027134918.487645929@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 6c151410d5b57e6bb0d91a735ac511459539a7bf ]

When brcmf_proto_msgbuf_attach fail and msgbuf->txflow_wq != NULL,
we should destroy the workqueue.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1595237765-66238-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 65e16e3646ecf..5f0af5fac343d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1538,6 +1538,8 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 					  BRCMF_TX_IOCTL_MAX_MSG_SIZE,
 					  msgbuf->ioctbuf,
 					  msgbuf->ioctbuf_handle);
+		if (msgbuf->txflow_wq)
+			destroy_workqueue(msgbuf->txflow_wq);
 		kfree(msgbuf);
 	}
 	return -ENOMEM;
-- 
2.25.1



