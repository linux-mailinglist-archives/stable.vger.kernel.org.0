Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6967826B6AE
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIPAJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgIOO2g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:28:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B067224D3;
        Tue, 15 Sep 2020 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179621;
        bh=KpL3Y/np3Hg2GoKJZAFsljUauenXX7VCbrvFwWtfXKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOXYg53AV9Sxov6FwuuK+ut0QKUOve3ClfGUMuJN8iLAvq5p0XWfgzJK0jBL6K2JS
         2nKhRWaWzbG1y6BEXH/dc1Wa+Vl1oSNFU5BOrXNoWLc+wPUbvgn39MwyCobdU5pliB
         UVeOcoFVkQfUgeBaDuQowFx4T2wCQTFDFAs/a9sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/132] nvme-fabrics: dont check state NVME_CTRL_NEW for request acceptance
Date:   Tue, 15 Sep 2020 16:12:34 +0200
Message-Id: <20200915140646.722902840@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit d7144f5c4cf4de95fdc3422943cf51c06aeaf7a7 ]

NVME_CTRL_NEW should never see any I/O, because in order to start
initialization it has to transition to NVME_CTRL_CONNECTING and from
there it will never return to this state.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index aa8d0805ba148..3bb71f177dfda 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -580,7 +580,6 @@ bool __nvmf_check_ready(struct nvme_ctrl *ctrl, struct request *rq,
 	 * which is require to set the queue live in the appropinquate states.
 	 */
 	switch (ctrl->state) {
-	case NVME_CTRL_NEW:
 	case NVME_CTRL_CONNECTING:
 		if (blk_rq_is_passthrough(rq) && nvme_is_fabrics(req->cmd) &&
 		    req->cmd->fabrics.fctype == nvme_fabrics_type_connect)
-- 
2.25.1



