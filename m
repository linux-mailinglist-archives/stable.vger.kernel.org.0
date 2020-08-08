Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F6E23FAD5
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgHHXi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgHHXiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:38:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A453520748;
        Sat,  8 Aug 2020 23:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929904;
        bh=sXtgcI/FlirC232oacrQyf899CGFW8M7zfPMnh/iWzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZZzHQdHYm+s0mSgcf9Ip8YAo7Zo4bTlzDheF0nkI+aiZih720A1Vt8lAuh1jQ1vu
         aQ6e3ZY+NUmb5GNhyfqZ6mAILXA7N4DemmCNZWBOfFgWbmkzgIFpAGUQ55etKZM+oq
         nSjT+tZpgVcdpm3aha2sevKuMe251NtXgOfAUkGw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rishabh Bhatnagar <rishabhb@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 43/58] soc: qcom: pdr: Reorder the PD state indication ack
Date:   Sat,  8 Aug 2020 19:37:09 -0400
Message-Id: <20200808233724.3618168-43-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 17ad3b8698e16..cd8828c857234 100644
--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -282,13 +282,15 @@ static void pdr_indack_work(struct work_struct *work)
 
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

