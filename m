Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C38272F59
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgIUQ4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728904AbgIUQo7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF65235F9;
        Mon, 21 Sep 2020 16:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706699;
        bh=E+rZOxxQzIdF/UYon+OMzY0aLfB7pBon3h1gfjUQuhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGK2A/V2vm4ICp7rue393iTuaakYwfeO+TyAhVRC1YPMmqV8J7uO69ymQQAPXdRVo
         pQIcRk9Pl6DZCOmEcE+CwqntVPW0pr6/54S5KXvCPXvFUvZcciNEgJSJZPN2vHwMIG
         aLqfE9Gx5EPuXvl32CUGEYppS5T4t0w57VCDBa64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Milburn <dmilburn@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 028/118] nvme-tcp: cancel async events before freeing event struct
Date:   Mon, 21 Sep 2020 18:27:20 +0200
Message-Id: <20200921162037.624331191@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index f1f66bf96cbb9..24467eea73999 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1567,6 +1567,7 @@ static struct blk_mq_tag_set *nvme_tcp_alloc_tagset(struct nvme_ctrl *nctrl,
 static void nvme_tcp_free_admin_queue(struct nvme_ctrl *ctrl)
 {
 	if (to_tcp_ctrl(ctrl)->async_req.pdu) {
+		cancel_work_sync(&ctrl->async_event_work);
 		nvme_tcp_free_async_req(to_tcp_ctrl(ctrl));
 		to_tcp_ctrl(ctrl)->async_req.pdu = NULL;
 	}
-- 
2.25.1



