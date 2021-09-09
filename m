Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E48B405472
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348562AbhIIM6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356447AbhIIMzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C73D663250;
        Thu,  9 Sep 2021 11:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188682;
        bh=r5gz44xUGjKQNP9W0Z+Pc8rBVdPIxDjXE7XorbWSThM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQUQvY2lDnbLwOdg1HZp1+pz6+U7A8+1Uy4ccIyh6LjqRktgiW3p8X2I5OxKRs2QG
         VW5oLrRTEcWncGHMFL+qiaqdYTKpBa6NSafPM4ByxXGYR7ARGg0En7bYJGNtoadZ3l
         YpcqAxH+3uJu1uVhMZLMlUMUq92WkOHTwC68ilgqVjA1LsdnmgMuYcqTBkj8syZP0n
         KHgC5uoEacCa3t1bkj6F0tfP2Z2h7AFJGbAhpFbUIjTA+VN+zHw/oSCABQDW8by1Qz
         P8ZiS6fWb+e951+IflzKgGAVTDDqP0qmQTISzTh+eT1oBsvC7Z9LpAjLGd/jPBIF7P
         mD+Aa87u1AP1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 4.19 29/74] staging: ks7010: Fix the initialization of the 'sleep_status' structure
Date:   Thu,  9 Sep 2021 07:56:41 -0400
Message-Id: <20210909115726.149004-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 56315e55119c0ea57e142b6efb7c31208628ad86 ]

'sleep_status' has 3 atomic_t members. Initialize the 3 of them instead of
initializing only 2 of them and setting 0 twice to the same variable.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/d2e52a33a9beab41879551d0ae2fdfc99970adab.1626856991.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/ks7010/ks7010_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ks7010/ks7010_sdio.c b/drivers/staging/ks7010/ks7010_sdio.c
index 74551eb717fc..79d0513bd282 100644
--- a/drivers/staging/ks7010/ks7010_sdio.c
+++ b/drivers/staging/ks7010/ks7010_sdio.c
@@ -938,9 +938,9 @@ static void ks7010_private_init(struct ks_wlan_private *priv,
 	memset(&priv->wstats, 0, sizeof(priv->wstats));
 
 	/* sleep mode */
+	atomic_set(&priv->sleepstatus.status, 0);
 	atomic_set(&priv->sleepstatus.doze_request, 0);
 	atomic_set(&priv->sleepstatus.wakeup_request, 0);
-	atomic_set(&priv->sleepstatus.wakeup_request, 0);
 
 	trx_device_init(priv);
 	hostif_init(priv);
-- 
2.30.2

