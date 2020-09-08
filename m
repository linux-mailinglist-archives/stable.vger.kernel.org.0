Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32CE261AAA
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731663AbgIHSia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731329AbgIHQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C3962405D;
        Tue,  8 Sep 2020 15:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580127;
        bh=BAqN8JJndhY6Fdr1OaQLHcokT17ApQzyCPPyy0UCFjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oS8qM3cwoW8ha+xaHgqZH6K7PGcidSiOtnX3maGVXHffLmwtFICB9dGuimv3TYCwb
         D2KxDw48X+Cve/9Vgr6j0NUxwfy3CsYgVio0nHGfxou0xCPMSsX/T/NEG6MOWwDNCG
         9LhcgFjOJ3kH0E41ld8OAEmNdc4qG+65I+fQNKgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/88] nvmet-fc: Fix a missed _irqsave version of spin_lock in nvmet_fc_fod_op_done()
Date:   Tue,  8 Sep 2020 17:25:40 +0200
Message-Id: <20200908152223.077799986@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 70e37988db94aba607d5491a94f80ba08e399b6b ]

The way 'spin_lock()' and 'spin_lock_irqsave()' are used is not consistent
in this function.

Use 'spin_lock_irqsave()' also here, as there is no guarantee that
interruptions are disabled at that point, according to surrounding code.

Fixes: a97ec51b37ef ("nvmet_fc: Rework target side abort handling")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 29b4b236afd85..77e4d184bc995 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1986,9 +1986,9 @@ nvmet_fc_fod_op_done(struct nvmet_fc_fcp_iod *fod)
 			return;
 		if (fcpreq->fcp_error ||
 		    fcpreq->transferred_length != fcpreq->transfer_length) {
-			spin_lock(&fod->flock);
+			spin_lock_irqsave(&fod->flock, flags);
 			fod->abort = true;
-			spin_unlock(&fod->flock);
+			spin_unlock_irqrestore(&fod->flock, flags);
 
 			nvmet_req_complete(&fod->req, NVME_SC_INTERNAL);
 			return;
-- 
2.25.1



