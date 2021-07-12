Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF813C4AAA
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbhGLGxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240337AbhGLGvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:51:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C8AB60FE3;
        Mon, 12 Jul 2021 06:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072494;
        bh=2RKsoqzOpkwGZoidnAJECty77Z17DJBi4cGvckbFOcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5y5IGg5GoZcsPZ1uDjsRLMiOY75qXSBCvWVpix9CSwnWkyCeSUqH6gugntHwekL+
         ESED+80+X8VI/M9sUxv928sZFxB/BHp2DSP8MXsehQSozqBT04AzDz1mbfiFCpZIA9
         vq80UvAI6vIE1mS2w/lmUycYvXU9Vd3YOXd01Wx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 514/593] thunderbolt: Bond lanes only when dual_link_port != NULL in alloc_dev_default()
Date:   Mon, 12 Jul 2021 08:11:14 +0200
Message-Id: <20210712060948.579824691@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index 464c2d37b992..e254f8c37cb7 100644
--- a/drivers/thunderbolt/test.c
+++ b/drivers/thunderbolt/test.c
@@ -259,14 +259,14 @@ static struct tb_switch *alloc_dev_default(struct kunit *test,
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



