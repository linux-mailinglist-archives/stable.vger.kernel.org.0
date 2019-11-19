Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF3B1013D1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfKSF1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727036AbfKSF1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1571B21939;
        Tue, 19 Nov 2019 05:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141257;
        bh=UuQWW+L4IQqGuH0JRhMtWTxzuWW1bEjd2yHLLq7S33Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0D1AKUoNEm7jLX8+c9ujgRj4rr4TLERcn4TOKO06olUUSqiDHDDmkQgiLjdFoNDJ
         FbHde26+6kF3+H19i0dAl8WcD3YHIR3r0yuC/EdyzrdI8eiE8qksFsWDk6ktdEhqyl
         ArOUzz394nWloWTF2yc2FXLiQp3Pc6WAjVW7iRFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/422] wil6210: fix invalid memory access for rx_buff_mgmt debugfs
Date:   Tue, 19 Nov 2019 06:14:17 +0100
Message-Id: <20191119051403.621335942@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit 4405b632e3da839defec966e4b0be44d0c5e3102 ]

Check rx_buff_mgmt is allocated before accessing its internal fields.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 51c3330bc316f..ceace95b1595c 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1263,6 +1263,9 @@ static int wil_rx_buff_mgmt_debugfs_show(struct seq_file *s, void *data)
 	int num_active;
 	int num_free;
 
+	if (!rbm->buff_arr)
+		return -EINVAL;
+
 	seq_printf(s, "  size = %zu\n", rbm->size);
 	seq_printf(s, "  free_list_empty_cnt = %lu\n",
 		   rbm->free_list_empty_cnt);
-- 
2.20.1



