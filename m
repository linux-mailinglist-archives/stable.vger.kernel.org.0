Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFDE344462
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbhCVM7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233389AbhCVM6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:58:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF1F660238;
        Mon, 22 Mar 2021 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417909;
        bh=CmBxmStxjHkSH2Y3V92jrGrXCqzw5r1mA3OiaCfZJPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+0v3hsxiD4zY4srH+rynl+4PHE2QgXVDGuIhofHa1Vla5FOsysHQMWVmOJPW/TxH
         ulpiTc54sImayXOfKU1VW4Gh0IwHaAxFaWhMAgvmeGjeh9U7a9uQ0HKGREkZlzptDZ
         lYnxVuVUrZiLOj7pcEsh0hNxpR2TNd4ljDtDQKE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Belanger, Martin" <Martin.Belanger@dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.11 044/120] nvme-tcp: fix a NULL deref when receiving a 0-length r2t PDU
Date:   Mon, 22 Mar 2021 13:27:07 +0100
Message-Id: <20210322121931.134719858@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
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
@@ -568,6 +568,13 @@ static int nvme_tcp_setup_h2c_data_pdu(s
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


