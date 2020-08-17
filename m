Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCC52473A7
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391826AbgHQS7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387414AbgHQPsp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:48:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D872067C;
        Mon, 17 Aug 2020 15:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679325;
        bh=C8HJY6mzlMYJgOJb/37DmfGgi7e8IQV70Tp3hB3M2jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc+qfE14BVCsrJkLy/5PVlqzfXBwP6Sodfj9akvfScHMndvm3VJTZOAwOdJEXUxqK
         5dvayqCqqh7LCrHEuSfXK8975AqxoWjclXC9BoqM15zvv1BnYqoyTZuJi5hyCESKWs
         HmFW3PEHY4j6K3Q4WO1gcQjIMJycmP056W93k+Uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 155/393] staging: most: avoid null pointer dereference when iface is null
Date:   Mon, 17 Aug 2020 17:13:25 +0200
Message-Id: <20200817143827.135155225@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit e4463e49e29f43eecec86e2e2b2e2ab4feb7d867 ]

In the case where the pointer iface is null then the reporting of this
error will dereference iface when printing an error message causing which
is not ideal.  Since the majority of callers to most_register_interface
report an error when -EINVAL is returned a simple fix is to just remove
the error message, I doubt it will be missed.

Addresses-Coverity: ("Dereference after null check")
Fixes: 57562a72414c ("Staging: most: add MOST driver's core module")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20200624163957.11676-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/most/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/most/core.c b/drivers/most/core.c
index f781c46cd4af9..353ab277cbc6b 100644
--- a/drivers/most/core.c
+++ b/drivers/most/core.c
@@ -1283,10 +1283,8 @@ int most_register_interface(struct most_interface *iface)
 	struct most_channel *c;
 
 	if (!iface || !iface->enqueue || !iface->configure ||
-	    !iface->poison_channel || (iface->num_channels > MAX_CHANNELS)) {
-		dev_err(iface->dev, "Bad interface or channel overflow\n");
+	    !iface->poison_channel || (iface->num_channels > MAX_CHANNELS))
 		return -EINVAL;
-	}
 
 	id = ida_simple_get(&mdev_id, 0, 0, GFP_KERNEL);
 	if (id < 0) {
-- 
2.25.1



