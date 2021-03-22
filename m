Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1320F344485
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhCVNBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 09:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232385AbhCVM7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B3E260238;
        Mon, 22 Mar 2021 12:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417970;
        bh=mCEEv/lplvJXxb4cwzcnBZeB7DDAVA3Rmt5oi1P+Dgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQyF7OZGpQvlt+Ac063gY70iGQV7iAOAY/6ltGGKKdELd3uJF6L70Fse+D9o8VfV6
         46+5n9+rtHSfHnDyElSG3krfWlIwXKVZgCTWoVQmMFBvBn9a1qOhc2czkIc0j6r/Y+
         8McSm7cBbS6IMFxSLDdWDBDjN87r+N2abM/iMlSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Belanger, Martin" <Martin.Belanger@dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.4 20/60] nvme-tcp: fix a NULL deref when receiving a 0-length r2t PDU
Date:   Mon, 22 Mar 2021 13:28:08 +0100
Message-Id: <20210322121923.049916383@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
References: <20210322121922.372583154@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit fd0823f405090f9f410fc3e3ff7efb52e7b486fa upstream.

When the controller sends us a 0-length r2t PDU we should not attempt to
try to set up a h2cdata PDU but rather conclude that this is a buggy
controller (forward progress is not possible) and simply fail it
immediately.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Reported-by: Belanger, Martin <Martin.Belanger@dell.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -512,6 +512,13 @@ static int nvme_tcp_setup_h2c_data_pdu(s
 	req->pdu_len = le32_to_cpu(pdu->r2t_length);
 	req->pdu_sent = 0;
 
+	if (unlikely(!req->pdu_len)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d r2t len is %u, probably a bug...\n",
+			rq->tag, req->pdu_len);
+		return -EPROTO;
+	}
+
 	if (unlikely(req->data_sent + req->pdu_len > req->data_len)) {
 		dev_err(queue->ctrl->ctrl.device,
 			"req %d r2t len %u exceeded data len %u (%zu sent)\n",


