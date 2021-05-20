Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F05538A548
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbhETKPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235666AbhETKMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FC4061968;
        Thu, 20 May 2021 09:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503820;
        bh=VNZ3q1Zq2Nzpq7XAb3m6tF+7MrbVohaHpgAvyGeSozQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xY1iGY19XKOoAvW+0hsJzRgfMX/xyGuxin28r1fniRfgGtiXweGG2nJry3Amrv8Rn
         dLwzUylK4fLWsqjLPXT6M9BbFYU8vxoWHtjHFRs4eMXIeAHGRq4EBnRXzvPyskb6Nc
         S4X80ekUHAij0qttkcGAW/NmD4eUSPhM97qfrvQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Liu <liupeng17@lenovo.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 4.19 393/425] nvme: do not try to reconfigure APST when the controller is not live
Date:   Thu, 20 May 2021 11:22:42 +0200
Message-Id: <20210520092144.325728366@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 53fe2a30bc168db9700e00206d991ff934973cf1 upstream.

Do not call nvme_configure_apst when the controller is not live, given
that nvme_configure_apst will fail due the lack of an admin queue when
the controller is being torn down and nvme_set_latency_tolerance is
called from dev_pm_qos_hide_latency_tolerance.

Fixes: 510a405d945b("nvme: fix memory leak for power latency tolerance")
Reported-by: Peng Liu <liupeng17@lenovo.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2091,7 +2091,8 @@ static void nvme_set_latency_tolerance(s
 
 	if (ctrl->ps_max_latency_us != latency) {
 		ctrl->ps_max_latency_us = latency;
-		nvme_configure_apst(ctrl);
+		if (ctrl->state == NVME_CTRL_LIVE)
+			nvme_configure_apst(ctrl);
 	}
 }
 


