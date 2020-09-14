Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2D269289
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgINRHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgINNFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AB8E2220D;
        Mon, 14 Sep 2020 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088664;
        bh=9HscjCgciwipmMzEmC04n7HE2tru8sD4dggZwWpiqAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3XrHdKBcfSPSCheyp8/BAQEozUmxpL5pGq1w3CLOdwHVpoOKFGm0fxLnhMpPvXNV
         p2EEWyJi0JhoWnpHmaaN0hNVKScAHdEQ0AgQYkyNbTlwhWMDPdRdzlMjSxgkqK78Qe
         yE1NWQq9Em2gATysF5ix6mBlbMOyqJDcykEisUWM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Milburn <dmilburn@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 21/29] nvme-tcp: cancel async events before freeing event struct
Date:   Mon, 14 Sep 2020 09:03:50 -0400
Message-Id: <20200914130358.1804194-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130358.1804194-1-sashal@kernel.org>
References: <20200914130358.1804194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Milburn <dmilburn@redhat.com>

[ Upstream commit ceb1e0874dba5cbfc4e0b4145796a4bfb3716e6a ]

Cancel async event work in case async event has been queued up, and
nvme_tcp_submit_async_event() runs after event has been freed.

Signed-off-by: David Milburn <dmilburn@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a6d2e3330a584..e17f71e69f6ec 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1566,6 +1566,7 @@ static struct blk_mq_tag_set *nvme_tcp_alloc_tagset(struct nvme_ctrl *nctrl,
 static void nvme_tcp_free_admin_queue(struct nvme_ctrl *ctrl)
 {
 	if (to_tcp_ctrl(ctrl)->async_req.pdu) {
+		cancel_work_sync(&ctrl->async_event_work);
 		nvme_tcp_free_async_req(to_tcp_ctrl(ctrl));
 		to_tcp_ctrl(ctrl)->async_req.pdu = NULL;
 	}
-- 
2.25.1

