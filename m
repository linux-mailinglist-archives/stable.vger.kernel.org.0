Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2410E3C55AC
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhGLILf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353842AbhGLIDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4F2961D11;
        Mon, 12 Jul 2021 07:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076682;
        bh=o4W/TuzfZ9IwacON7nnH/Q6Bwjv5FRtmxYEL0UBasxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGkvC2D9cQ/zkA1eMuCAJY7oLufoYeNdvKObbu1xvkrhyxJ/132ren+K/BsEsyxMM
         Asy7jqnwXHUUzwxkOgwOouTXI6yKFigGsSZV9f2krQPZcYXLRhh/vDxjBL7AJPSKYi
         K2F/4t8aso9UFgejwcdTloTzlHxSmoWHl8r5EEbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 705/800] thunderbolt: Bond lanes only when dual_link_port != NULL in alloc_dev_default()
Date:   Mon, 12 Jul 2021 08:12:08 +0200
Message-Id: <20210712061041.778536479@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit a0d36fa1065901f939b04587a09c65303a64ac88 ]

We should not dereference ->dual_link_port if it is NULL and lane bonding
is requested. For this reason move lane bonding configuration happen
inside the block where ->dual_link_port != NULL.

Fixes: 54509f5005ca ("thunderbolt: Add KUnit tests for path walking")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Yehezkel Bernat <YehezkelShB@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/test.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/thunderbolt/test.c b/drivers/thunderbolt/test.c
index 5ff5a03bc9ce..6e0a5391fcd7 100644
--- a/drivers/thunderbolt/test.c
+++ b/drivers/thunderbolt/test.c
@@ -260,14 +260,14 @@ static struct tb_switch *alloc_dev_default(struct kunit *test,
 	if (port->dual_link_port && upstream_port->dual_link_port) {
 		port->dual_link_port->remote = upstream_port->dual_link_port;
 		upstream_port->dual_link_port->remote = port->dual_link_port;
-	}
 
-	if (bonded) {
-		/* Bonding is used */
-		port->bonded = true;
-		port->dual_link_port->bonded = true;
-		upstream_port->bonded = true;
-		upstream_port->dual_link_port->bonded = true;
+		if (bonded) {
+			/* Bonding is used */
+			port->bonded = true;
+			port->dual_link_port->bonded = true;
+			upstream_port->bonded = true;
+			upstream_port->dual_link_port->bonded = true;
+		}
 	}
 
 	return sw;
-- 
2.30.2



