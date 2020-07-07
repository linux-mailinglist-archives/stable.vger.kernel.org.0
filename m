Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5430A21719C
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbgGGPWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729859AbgGGPWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 673BA20853;
        Tue,  7 Jul 2020 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135349;
        bh=uz6pN9Y+lCiA2MMEyDzTGEy/64SAtA2kxSPxMrE/Vc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a9LRDqrFRUShIkxUp7i4xMrUBJuxLWuuZtLSvVY1muIVaDpmlCAcp/ZOCyYe1lzE1
         0AG6+kqdT5vJHXV4WbPYmNbjZVLjp7K/AckB1IoKpXN4/7kO4xa+tA7XzmEPMxLrAg
         gKIAMB65HnbDhykXHz55RfMMvKGP20kGRHdapJJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/65] nvme: fix identify error status silent ignore
Date:   Tue,  7 Jul 2020 17:17:20 +0200
Message-Id: <20200707145754.443602576@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit ea43d9709f727e728e933a8157a7a7ca1a868281 ]

Commit 59c7c3caaaf8 intended to only silently ignore non retry-able
errors (DNR bit set) such that we can still identify misbehaving
controllers, and in the other hand propagate retry-able errors (DNR bit
cleared) so we don't wrongly abandon a namespace just because it happens
to be temporarily inaccessible.

The goal remains the same as the original commit where this was
introduced but unfortunately had the logic backwards.

Fixes: 59c7c3caaaf8 ("nvme: fix possible hang when ns scanning fails during error recovery")
Reported-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c44c00b9e1d85..d423515547237 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1088,10 +1088,16 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl, unsigned nsid,
 		dev_warn(ctrl->device,
 			"Identify Descriptors failed (%d)\n", status);
 		 /*
-		  * Don't treat an error as fatal, as we potentially already
-		  * have a NGUID or EUI-64.
+		  * Don't treat non-retryable errors as fatal, as we potentially
+		  * already have a NGUID or EUI-64.  If we failed with DNR set,
+		  * we want to silently ignore the error as we can still
+		  * identify the device, but if the status has DNR set, we want
+		  * to propagate the error back specifically for the disk
+		  * revalidation flow to make sure we don't abandon the
+		  * device just because of a temporal retry-able error (such
+		  * as path of transport errors).
 		  */
-		if (status > 0 && !(status & NVME_SC_DNR))
+		if (status > 0 && (status & NVME_SC_DNR))
 			status = 0;
 		goto free_data;
 	}
-- 
2.25.1



