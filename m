Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D1338A3F7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhETJ7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:59:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhETJ5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E712B61627;
        Thu, 20 May 2021 09:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503469;
        bh=GnE2Mid1xYoPgRWwU+m+5UdnTv4WO4oFBg/7XbvxAqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2MK0kc5+p6X/4M98t631WOG6dzY9eQVP21ycY+4ObJk9QjboymJVKxP81OBp5xSs
         SvhEcs9NkH3CbASoE3swtR4KpD/P7fgI8ELeztJGblv4A2ygOiDtp7AWB/5yxJnC96
         nfe4JTGHhBzLfo8ByOtrhMSOkLUJt3R12PnziWI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin George <marting@netapp.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 235/425] nvme: retrigger ANA log update if group descriptor isnt found
Date:   Thu, 20 May 2021 11:20:04 +0200
Message-Id: <20210520092139.153401198@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 4ef05fe00dac..64f699a1afd7 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -516,6 +516,10 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
 		if (desc.state) {
 			/* found the group desc: update */
 			nvme_update_ns_ana_state(&desc, ns);
+		} else {
+			/* group desc not found: trigger a re-read */
+			set_bit(NVME_NS_ANA_PENDING, &ns->flags);
+			queue_work(nvme_wq, &ns->ctrl->ana_work);
 		}
 	} else {
 		mutex_lock(&ns->head->lock);
-- 
2.30.2



