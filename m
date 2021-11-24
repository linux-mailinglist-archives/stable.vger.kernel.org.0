Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7374F45BE7D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345264AbhKXMrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245747AbhKXMpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:45:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F83861411;
        Wed, 24 Nov 2021 12:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756800;
        bh=mawGj9bAkOCUY1SQvO7k329OHtMuiLJXsMOHqPd/XFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKaAj4xaIvZVIPJO5aaTCIsBNWGQSI0cuW/6habMpyVpWnb18gZHdYQDIkziJQ3L2
         W8kQo/MsJmc6LLyPoYgt6bYjWScYxfEInC/s3K0/0GTNeRPXE97hGyioDQTJsICJL8
         wnHhNQhs9mV3T6q+Joc6P2xZjd5gx2Cdt/P4Z6Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 179/251] xen-pciback: Fix return in pm_ctrl_init()
Date:   Wed, 24 Nov 2021 12:57:01 +0100
Message-Id: <20211124115716.480843842@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 4745ea2628bb43a7ec34b71763b5a56407b33990 ]

Return NULL instead of passing to ERR_PTR while err is zero,
this fix smatch warnings:
drivers/xen/xen-pciback/conf_space_capability.c:163
 pm_ctrl_init() warn: passing zero to 'ERR_PTR'

Fixes: a92336a1176b ("xen/pciback: Drop two backends, squash and cleanup some code.")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20211008074417.8260-1-yuehaibing@huawei.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xen-pciback/conf_space_capability.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/conf_space_capability.c b/drivers/xen/xen-pciback/conf_space_capability.c
index e5694133ebe57..42f0f64fcba47 100644
--- a/drivers/xen/xen-pciback/conf_space_capability.c
+++ b/drivers/xen/xen-pciback/conf_space_capability.c
@@ -160,7 +160,7 @@ static void *pm_ctrl_init(struct pci_dev *dev, int offset)
 	}
 
 out:
-	return ERR_PTR(err);
+	return err ? ERR_PTR(err) : NULL;
 }
 
 static const struct config_field caplist_pm[] = {
-- 
2.33.0



