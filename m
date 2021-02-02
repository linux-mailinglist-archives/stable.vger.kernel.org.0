Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979BD30C0BF
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhBBOGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233088AbhBBOD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:03:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFFC464E31;
        Tue,  2 Feb 2021 13:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273708;
        bh=x9E1Xcrqh6yd/DuAAZBhpOlxyykUufBgGTmYzkQAv4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g272xS5QZgJl8HpdiaUUlhxPZbrix4G4eVHmg2plFi4/az8yTEvtQktZcp+xXPq23
         ijQZA8cO8bor0CtblDBEDK1HIW3tfO6rEzFUp5To2XDTAdeenKHLS/CuMDoGR+JLM/
         DN1+KP4z5dIunZnJiyDp+PbLveY/zxiaUEipEkPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 52/61] nvme-multipath: Early exit if no path is available
Date:   Tue,  2 Feb 2021 14:38:30 +0100
Message-Id: <20210202132948.682070468@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit d1bcf006a9d3d63c1bcb65a993cb13756954cd9c ]

nvme_round_robin_path() should test if the return ns pointer is valid.
nvme_next_ns() will return a NULL pointer if there is no path left.

Fixes: 75c10e732724 ("nvme-multipath: round-robin I/O policy")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 3968f89f7855a..0ac0bd4c65c4c 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -233,7 +233,7 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head,
 	}
 
 	for (ns = nvme_next_ns(head, old);
-	     ns != old;
+	     ns && ns != old;
 	     ns = nvme_next_ns(head, ns)) {
 		if (nvme_path_is_disabled(ns))
 			continue;
-- 
2.27.0



