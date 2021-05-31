Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A61396217
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhEaOvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233316AbhEaOrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B63961438;
        Mon, 31 May 2021 13:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469360;
        bh=xDh8vqmsD0PqY7lkpUvW7q/+AmZ23MBZFO5QElc9QaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEaCDU0tuTr+sk7GP57CQEtUKQmTwpeAqv2WGd+tm4mODqh86lonPNrE4J3Nl2VEP
         JOid0caZP+RXi2PgZSR3F/6be404UrnJhkyD+doyFvxEs6QbP2tBfxZ51DnsFVFlvJ
         CZi4RFcGd7pHrciSSJWv28esm62FFyMC/10e4OVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 167/296] Revert "net: fujitsu: fix a potential NULL pointer dereference"
Date:   Mon, 31 May 2021 15:13:42 +0200
Message-Id: <20210531130709.484133072@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 5f94eaa4ee23e80841fa359a372f84cfe25daee1 ]

This reverts commit 9f4d6358e11bbc7b839f9419636188e4151fb6e4.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original change does not change any behavior as the caller of this
function onlyu checks for "== -1" as an error condition so this error is
not handled properly.  Remove this change and it will be fixed up
properly in a later commit.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-15-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index a7b7a4aace79..dc90c61fc827 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -547,11 +547,6 @@ static int fmvj18x_get_hwinfo(struct pcmcia_device *link, u_char *node_id)
 	return -1;
 
     base = ioremap(link->resource[2]->start, resource_size(link->resource[2]));
-    if (!base) {
-	    pcmcia_release_window(link, link->resource[2]);
-	    return -ENOMEM;
-    }
-
     pcmcia_map_mem_page(link, link->resource[2], 0);
 
     /*
-- 
2.30.2



