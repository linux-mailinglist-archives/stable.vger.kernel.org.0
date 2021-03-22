Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63591344488
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 14:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhCVNBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 09:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232256AbhCVM7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:59:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA33B61984;
        Mon, 22 Mar 2021 12:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616417978;
        bh=o06g8sfe/ypC8Jt5f7h7fT4tZx4EMnExj3MBmfuup90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWSJ7xIJD/S+KMSIKYTvRmskFCtgGFEyUfq96a/eN7nUDG9n9+nRHpcMZF24m8bg6
         Ii8mGHRGB1LvabPWNOsMl66Uq3+tAfUAi8hpVet7BYh9ROjOUq/ulmlt3uqXEE2PyH
         7WEaVvr46zAjOzSGkMOKjZ/eJ3wa1P1uSULOYLKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Belanger, Martin" <Martin.Belanger@dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.9 08/25] nvmet: dont check iosqes,iocqes for discovery controllers
Date:   Mon, 22 Mar 2021 13:28:58 +0100
Message-Id: <20210322121920.669369916@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121920.399826335@linuxfoundation.org>
References: <20210322121920.399826335@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit d218a8a3003e84ab136e69a4e30dd4ec7dab2d22 upstream.

>From the base spec, Figure 78:

  "Controller Configuration, these fields are defined as parameters to
   configure an "I/O Controller (IOC)" and not to configure a "Discovery
   Controller (DC).

   ...
   If the controller does not support I/O queues, then this field shall
   be read-only with a value of 0h

Just perform this check for I/O controllers.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Reported-by: Belanger, Martin <Martin.Belanger@dell.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/core.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -574,9 +574,20 @@ static void nvmet_start_ctrl(struct nvme
 {
 	lockdep_assert_held(&ctrl->lock);
 
-	if (nvmet_cc_iosqes(ctrl->cc) != NVME_NVM_IOSQES ||
-	    nvmet_cc_iocqes(ctrl->cc) != NVME_NVM_IOCQES ||
-	    nvmet_cc_mps(ctrl->cc) != 0 ||
+	/*
+	 * Only I/O controllers should verify iosqes,iocqes.
+	 * Strictly speaking, the spec says a discovery controller
+	 * should verify iosqes,iocqes are zeroed, however that
+	 * would break backwards compatibility, so don't enforce it.
+	 */
+	if (ctrl->subsys->type != NVME_NQN_DISC &&
+	    (nvmet_cc_iosqes(ctrl->cc) != NVME_NVM_IOSQES ||
+	     nvmet_cc_iocqes(ctrl->cc) != NVME_NVM_IOCQES)) {
+		ctrl->csts = NVME_CSTS_CFS;
+		return;
+	}
+
+	if (nvmet_cc_mps(ctrl->cc) != 0 ||
 	    nvmet_cc_ams(ctrl->cc) != 0 ||
 	    nvmet_cc_css(ctrl->cc) != 0) {
 		ctrl->csts = NVME_CSTS_CFS;


