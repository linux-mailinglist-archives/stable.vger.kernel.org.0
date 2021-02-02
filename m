Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E30D30CBDC
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239904AbhBBThR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233187AbhBBN4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38BAA64F61;
        Tue,  2 Feb 2021 13:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273501;
        bh=RBLoRNYKmCuVRi4nEg7h1pxqF3vcqxiTgYXtW3BA87I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2/z021IRV7VU/UmjFAp0Ypd/Te/Y5BaDUs+PbNl9i1jrtUWhs5LaufFVgN2owA3G
         L0CTax614D8b9/hO5RQUhW1EOkt505EA6IcZ1+en77P8u0b+6HqbM8QrKz52TT7Y+w
         jliqjtcqrc6yBGSW2N6GNDumDVZw5h6qXETxRl5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/142] nvme-multipath: Early exit if no path is available
Date:   Tue,  2 Feb 2021 14:38:13 +0100
Message-Id: <20210202133003.057805779@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
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
index 74896be40c176..292e535a385d4 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -221,7 +221,7 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head,
 	}
 
 	for (ns = nvme_next_ns(head, old);
-	     ns != old;
+	     ns && ns != old;
 	     ns = nvme_next_ns(head, ns)) {
 		if (nvme_path_is_disabled(ns))
 			continue;
-- 
2.27.0



