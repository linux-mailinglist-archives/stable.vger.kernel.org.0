Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7751F37CD16
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhELQxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243680AbhELQlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC8961CEC;
        Wed, 12 May 2021 16:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835545;
        bh=l9dVMnWyhq/bY9juxIVxNrHTriINd3A2JghBWNwDsPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acfq6bcgbfI22qafO3T5Fy/oQ/56O1hKmbiAVdWHCtBncJuVyy9yNPIf7LKdcBvep
         38ra5SEm+SjcsBjud9anwzfUyNuGbRBi19J5f09PvoYrIEg2emEg/3pT5HU1Lc/qRt
         FhDCBvEWNixREBT7Srtb6mfcBLm/Wpp1TFTzBaV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin George <marting@netapp.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 388/677] nvme: retrigger ANA log update if group descriptor isnt found
Date:   Wed, 12 May 2021 16:47:14 +0200
Message-Id: <20210512144850.219086983@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit dd8f7fa908f66dd44abcd83cbb50410524b9f8ef ]

If ANA is enabled but no ANA group descriptor is found when creating
a new namespace the ANA log is most likely out of date, so trigger
a re-read. The namespace will be tagged with the NS_ANA_PENDING flag
to exclude it from path selection until the ANA log has been re-read.

Fixes: 32acab3181c7 ("nvme: implement multipath access to nvme subsystems")
Reported-by: Martin George <marting@netapp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a1d476e1ac02..ec1e454848e5 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -668,6 +668,10 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
 		if (desc.state) {
 			/* found the group desc: update */
 			nvme_update_ns_ana_state(&desc, ns);
+		} else {
+			/* group desc not found: trigger a re-read */
+			set_bit(NVME_NS_ANA_PENDING, &ns->flags);
+			queue_work(nvme_wq, &ns->ctrl->ana_work);
 		}
 	} else {
 		ns->ana_state = NVME_ANA_OPTIMIZED; 
-- 
2.30.2



