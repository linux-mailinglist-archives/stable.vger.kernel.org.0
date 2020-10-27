Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD9529B80B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799248AbgJ0Pad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:30:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799242AbgJ0Pac (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9755422202;
        Tue, 27 Oct 2020 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812631;
        bh=sf3VC+nwrPX+O03St19gwI+xX2u5Mdv2WqUkhCYlVfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8G7mwMFJFpSzrdpv85xqI+kKgSZ8E4TXhh3lMilRiq+jjR5v5XdF68sRs3TAYUJV
         H/rsSAXqWwFhUuL9vZ+XMYqZYdMnW66XejisHorKJPDEd/MeSBoYq873lZW2zSO2Yx
         qFgDCxjL1qkKDf2RJpXz3IOvvghMJSuec24WzGtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 246/757] ath11k: fix uninitialized return in ath11k_spectral_process_data()
Date:   Tue, 27 Oct 2020 14:48:16 +0100
Message-Id: <20201027135502.126264781@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit c7187acc3cd08a17e7b506b2b5277f42d1504d29 ]

There is a success path where "ret" isn't initialized where we never
have a ATH11K_SPECTRAL_TAG_SCAN_SEARCH and then ret isn't initialized.

Fixes: 9d11b7bff950 ("ath11k: add support for spectral scan")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200619142922.GA267142@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/spectral.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/spectral.c b/drivers/net/wireless/ath/ath11k/spectral.c
index 1c5d65bb411f7..6d6a7e34645f2 100644
--- a/drivers/net/wireless/ath/ath11k/spectral.c
+++ b/drivers/net/wireless/ath/ath11k/spectral.c
@@ -773,6 +773,8 @@ static int ath11k_spectral_process_data(struct ath11k *ar,
 		i += sizeof(*tlv) + tlv_len;
 	}
 
+	ret = 0;
+
 err:
 	kfree(fft_sample);
 unlock:
-- 
2.25.1



