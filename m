Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BC429BD50
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368814AbgJ0Plo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800206AbgJ0PfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 493C12225E;
        Tue, 27 Oct 2020 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812919;
        bh=GCUZ+obrRO/mkdif81IOj6kbqeFpTp5nuaf/sZgNLYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CC5LYgS/9ATnGnm2ULXmzl+M1i8u5cPD3kSOPjuuyaQ+9VtaxPeUQFqH0856s2584
         szAWrm9Ilz3VGo32nExTS5Rdr24SEtnJTQtO0DgBBOb7OrAFJMcHaSAb4l50WxrFKV
         wDk7Tp1/oYIb/vSVMp4TQRywfcWP2mFNZpS25Csg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 345/757] qtnfmac: fix resource leaks on unsupported iftype error return path
Date:   Tue, 27 Oct 2020 14:49:55 +0100
Message-Id: <20201027135506.754840715@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 63f6982075d890d7563e2469643f05a37d193f01 ]

Currently if an unsupported iftype is detected the error return path
does not free the cmd_skb leading to a resource leak. Fix this by
free'ing cmd_skb.

Addresses-Coverity: ("Resource leak")
Fixes: 805b28c05c8e ("qtnfmac: prepare for AP_VLAN interface type support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200925132224.21638-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index f40d8c3c3d9e5..f3ccbd2b10847 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -869,6 +869,7 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
 	default:
 		pr_warn("VIF%u.%u: unsupported iftype %d\n", vif->mac->macid,
 			vif->vifid, vif->wdev.iftype);
+		dev_kfree_skb(cmd_skb);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -1924,6 +1925,7 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 		break;
 	default:
 		pr_err("unsupported iftype %d\n", vif->wdev.iftype);
+		dev_kfree_skb(cmd_skb);
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.25.1



