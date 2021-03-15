Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B0233BAE3
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbhCOOKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234488AbhCOODl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E4E64EFC;
        Mon, 15 Mar 2021 14:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817020;
        bh=UcsAEqwzcrROjqapXTx8ABQo444UPYI3CUiTu7H0l/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K5UxBkkUZfWbHMKZEm91ib/jST+59ceDiAO/vMyHDPTxAS/1diUSokLr1Y9ggcixF
         mwcm1/If47Hbcz0tLxSv5xl5KZK1WgVh5ezx7AGXPdGzNY9Xh5uqlr+son8CbGqDuQ
         FUTOJGPXbZuwF9ZMQh/2HyzjS4qaWRj783IvoW/4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nigel Kirkland <nkirkland2304@gmail.com>,
        James Smart <jsmart2021@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/290] nvme-fc: fix racing controller reset and create association
Date:   Mon, 15 Mar 2021 14:55:43 +0100
Message-Id: <20210315135550.468382436@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit f20ef34d71abc1fc56b322aaa251f90f94320140 ]

Recent patch to prevent calling __nvme_fc_abort_outstanding_ios in
interrupt context results in a possible race condition. A controller
reset results in errored io completions, which schedules error
work. The change of error work to a work element allows it to fire
after the ctrl state transition to NVME_CTRL_CONNECTING, causing
any outstanding io (used to initialize the controller) to fail and
cause problems for connect_work.

Add a state check to only schedule error work if not in the RESETTING
state.

Fixes: 19fce0470f05 ("nvme-fc: avoid calling _nvme_fc_abort_outstanding_ios from interrupt context")
Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 5ead217ac2bc..fab068c8ba02 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2055,7 +2055,7 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 		nvme_fc_complete_rq(rq);
 
 check_error:
-	if (terminate_assoc)
+	if (terminate_assoc && ctrl->ctrl.state != NVME_CTRL_RESETTING)
 		queue_work(nvme_reset_wq, &ctrl->ioerr_work);
 }
 
-- 
2.30.1



