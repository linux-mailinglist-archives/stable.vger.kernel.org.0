Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD24424771B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgHQTpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729418AbgHQPWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:22:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6500422D75;
        Mon, 17 Aug 2020 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677727;
        bh=pheYLl1F1b+RkUaS318nzLCRhq4G0ZZVeOC/26y6vwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5aaE4TQw1AWDuvBIe8wKdWSu/0O5p8s2iG3QKpRzDAR/lEmVQGlzg1v9eT3fhLqZ
         M51HHvcybtNFqlgGoVv1VbthDbqvlvko1LLvQb/+dY5a1sgoCQbyVX5ygbNWu3vLZX
         CDXD31hmBtvMTl03HsBhZtmhhJM0AJN8AGzsMS6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rishabh Bhatnagar <rishabhb@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 055/464] soc: qcom: pdr: Reorder the PD state indication ack
Date:   Mon, 17 Aug 2020 17:10:08 +0200
Message-Id: <20200817143836.397478153@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit 72fe996f9643043c8f84e32c0610975b01aa555b ]

The Protection Domains (PD) have a mechanism to keep its resources
enabled until the PD down indication is acked. Reorder the PD state
indication ack so that clients get to release the relevant resources
before the PD goes down.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart helpers")
Reported-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200701195954.9007-1-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pdr_interface.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pdr_interface.c b/drivers/soc/qcom/pdr_interface.c
index bdcf16f88a97f..4c9225f15c4e6 100644
--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -278,13 +278,15 @@ static void pdr_indack_work(struct work_struct *work)
 
 	list_for_each_entry_safe(ind, tmp, &pdr->indack_list, node) {
 		pds = ind->pds;
-		pdr_send_indack_msg(pdr, pds, ind->transaction_id);
 
 		mutex_lock(&pdr->status_lock);
 		pds->state = ind->curr_state;
 		pdr->status(pds->state, pds->service_path, pdr->priv);
 		mutex_unlock(&pdr->status_lock);
 
+		/* Ack the indication after clients release the PD resources */
+		pdr_send_indack_msg(pdr, pds, ind->transaction_id);
+
 		mutex_lock(&pdr->list_lock);
 		list_del(&ind->node);
 		mutex_unlock(&pdr->list_lock);
-- 
2.25.1



