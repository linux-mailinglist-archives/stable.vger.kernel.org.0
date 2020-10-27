Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68E929C101
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818025AbgJ0RQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766369AbgJ0Oz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:55:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC53822284;
        Tue, 27 Oct 2020 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810519;
        bh=47XuXRUE5rmrBFlPABf4wvzHJhnotZEIQYbipEI3bKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGvsxrMfYILLLIYtFOwM1ME7Wi/YIlTJ7gdF4RVlzO0Ypd1ice9Rq7qhK2MccQUXf
         d8qXOpf1xLiyoAV5yusAp5OUd7JXQvQM3d/d7FF5opn1sGv0hnKN9JSAqiE60eAWuy
         +hBUBb5eyb6HxwUgOWHX2NE5965QxrdC5pIbBBDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 167/633] ath11k: Fix possible memleak in ath11k_qmi_init_service
Date:   Tue, 27 Oct 2020 14:48:30 +0100
Message-Id: <20201027135530.504494846@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 28f1632118818d9dccabf4c0fccfe49686742317 ]

When qmi_add_lookup fail, we should destroy the workqueue

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1595237804-66297-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index c00a99ad8dbc1..497cff7e64cc5 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2419,6 +2419,7 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
 			     ATH11K_QMI_WLFW_SERVICE_INS_ID_V01);
 	if (ret < 0) {
 		ath11k_warn(ab, "failed to add qmi lookup\n");
+		destroy_workqueue(ab->qmi.event_wq);
 		return ret;
 	}
 
-- 
2.25.1



