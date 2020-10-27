Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B5D29C43F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822936AbgJ0RyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509320AbgJ0OWo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:22:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23E16206D4;
        Tue, 27 Oct 2020 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808563;
        bh=iJgp8UbdyD8SddwStakjDajGHTdOXop+sanZ/GbHMTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDZmcJj9kfUUalR/2agqpKw91JRdKPhWs0DOb+lkv75Yes0W6BC8p8Eqoz5ApJr01
         ahzNWKSFe0k891XFAhnZgQhPOyogj4BJgidVauBI6Jdb6eun5UijcHkdKR65h5PDFo
         AC+m1wSq7XSY2ENGkVb2cLfq+qAU5vi0EmxWrs44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/264] qtnfmac: fix resource leaks on unsupported iftype error return path
Date:   Tue, 27 Oct 2020 14:52:50 +0100
Message-Id: <20201027135435.935584749@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
index 734844b34c266..dd473b206f123 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -894,6 +894,7 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
 	default:
 		pr_warn("VIF%u.%u: unsupported iftype %d\n", vif->mac->macid,
 			vif->vifid, vif->wdev.iftype);
+		dev_kfree_skb(cmd_skb);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -2212,6 +2213,7 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, const u8 *mac,
 		break;
 	default:
 		pr_err("unsupported iftype %d\n", vif->wdev.iftype);
+		dev_kfree_skb(cmd_skb);
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.25.1



