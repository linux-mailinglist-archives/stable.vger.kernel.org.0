Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9D929B54E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794231AbgJ0PKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794225AbgJ0PKk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6177206F4;
        Tue, 27 Oct 2020 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811439;
        bh=oYSZus/JJ0ACWFzC7GzWMIs67BB8KVQMnupWo0wxdYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcaWjD3ADh1vMse4S4GqwLLQWXREUXf5j/NB9C5AK1PUPP02r8+N+sToQ8g0xnZp6
         AN8Pk1QzhQxQw80KuHcJWkAX0QloWkzL6BmmvOtZ1XRtGetCcZ7EMaipudnOA4mNQe
         XyoDGn47mIluugybhbL5JequTEOM+DJZIMhxXE00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rishabh Bhatnagar <rishabhb@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 494/633] soc: qcom: pdr: Fixup array type of get_domain_list_resp message
Date:   Tue, 27 Oct 2020 14:53:57 +0100
Message-Id: <20201027135545.912760617@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit 7a366707bb6a93baeb1a9ef46c4b9c875e0132d6 ]

The array type of get_domain_list_resp is incorrectly marked as NO_ARRAY.
Due to which the following error was observed when using pdr helpers with
the downstream proprietary pd-mapper. Fix this up by marking it as
VAR_LEN_ARRAY instead.

Err logs:
qmi_decode_struct_elem: Fault in decoding: dl(2), db(27), tl(160), i(1), el(1)
failed to decode incoming message
PDR: tms/servreg get domain list txn wait failed: -14
PDR: service lookup for tms/servreg failed: -14

Tested-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart helpers")
Reported-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200914145807.1224-1-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pdr_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pdr_internal.h b/drivers/soc/qcom/pdr_internal.h
index 15b5002e4127b..ab9ae8cdfa54c 100644
--- a/drivers/soc/qcom/pdr_internal.h
+++ b/drivers/soc/qcom/pdr_internal.h
@@ -185,7 +185,7 @@ struct qmi_elem_info servreg_get_domain_list_resp_ei[] = {
 		.data_type      = QMI_STRUCT,
 		.elem_len       = SERVREG_DOMAIN_LIST_LENGTH,
 		.elem_size      = sizeof(struct servreg_location_entry),
-		.array_type	= NO_ARRAY,
+		.array_type	= VAR_LEN_ARRAY,
 		.tlv_type       = 0x12,
 		.offset         = offsetof(struct servreg_get_domain_list_resp,
 					   domain_list),
-- 
2.25.1



