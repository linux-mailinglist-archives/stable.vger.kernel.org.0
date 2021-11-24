Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B0445BA38
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241699AbhKXMIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:08:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242384AbhKXMHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:07:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 260D361075;
        Wed, 24 Nov 2021 12:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755455;
        bh=SIGqIObj6Izhd7JpPtGhNQ5aCiNx3L7VJLUbad9fhPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrTbnSFot1qNBODHPsq6V1apbBFVnqvJeio79Ieff+GtD41C2aElIQCfYzKMxUm1w
         IQiaW4KBuS4UsAIdrlj9JY5SeBmlnYOMUwfvSFsUsnzGDruLUTM0VBtxkDdOUhUBmQ
         yRB7RZEgKFdbewmzUrAxBqE4os2FA3rEZVrQDPhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 103/162] xen-pciback: Fix return in pm_ctrl_init()
Date:   Wed, 24 Nov 2021 12:56:46 +0100
Message-Id: <20211124115701.659151073@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
index b1a1d7de0894e..daa2e89a50fa3 100644
--- a/drivers/xen/xen-pciback/conf_space_capability.c
+++ b/drivers/xen/xen-pciback/conf_space_capability.c
@@ -159,7 +159,7 @@ static void *pm_ctrl_init(struct pci_dev *dev, int offset)
 	}
 
 out:
-	return ERR_PTR(err);
+	return err ? ERR_PTR(err) : NULL;
 }
 
 static const struct config_field caplist_pm[] = {
-- 
2.33.0



