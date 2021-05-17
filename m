Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6833837BE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244558AbhEQPqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344466AbhEQPol (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:44:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22A2461D23;
        Mon, 17 May 2021 14:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262597;
        bh=JehICQ6GUV4hMjDkC8qrupASWkjLJUYCf/4NuKBXAWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1d82A364oa9KblebLUPWMx5eW58EXrY+DVxUvsbyy5LmaFaa2Oh7nmUuRM1nU3AwU
         +th4pz65kTsd7nK9QWOxfCt0vS8Mca8eEqMNHIZc217Dup6RUqgzJuQZLkYQtgu5FL
         ZpbuO0O7L09l0Cpi67OUQhgEd5uiLixGOkNHJzZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Liu <liupeng17@lenovo.com>,
        Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.11 328/329] nvme: do not try to reconfigure APST when the controller is not live
Date:   Mon, 17 May 2021 16:03:59 +0200
Message-Id: <20210517140313.180627347@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
@@ -2676,7 +2676,8 @@ static void nvme_set_latency_tolerance(s
 
 	if (ctrl->ps_max_latency_us != latency) {
 		ctrl->ps_max_latency_us = latency;
-		nvme_configure_apst(ctrl);
+		if (ctrl->state == NVME_CTRL_LIVE)
+			nvme_configure_apst(ctrl);
 	}
 }
 


