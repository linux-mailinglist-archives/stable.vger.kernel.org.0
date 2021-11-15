Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602ED451EE3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350868AbhKPAhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344705AbhKOTZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C2A610A8;
        Mon, 15 Nov 2021 19:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002960;
        bh=37R7AQxwaHqBQnqHRMW6dJ+EsQblDFNxp4DVJlhU1As=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EAWaS1cJNQbDmn2peppb+4M55BtwIEqSjzlkZtGsOdn9yVPx62koQXGCX2FePEv3r
         oUCTGqoo6gf8bLqoarGRfS9tvzcpCxtCoOmTRkYoDmWIbbqmMFUJkGPc55XuVgkF8P
         CQ4tSoNo+CS7UxNctyRMGF+yd+DJvy2fpQ18pNXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 759/917] xen-pciback: Fix return in pm_ctrl_init()
Date:   Mon, 15 Nov 2021 18:04:14 +0100
Message-Id: <20211115165454.657009559@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 22f13abbe9130..5e53b4817f167 100644
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



