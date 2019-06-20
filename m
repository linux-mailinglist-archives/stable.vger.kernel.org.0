Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35C74D7EA
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbfFTSMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbfFTSMs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:12:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 986BD214AF;
        Thu, 20 Jun 2019 18:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054367;
        bh=eQPis8RUW9sKszh/XffmnxG5x2vEuII50SRZgvkX7uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3ULAJOfH1as9t32p0oNEf/2zciDWydjswv3MjD8hl1t2uKRfxr0iskjReLxQuYSy
         g8m3EatYZLboI1rZJu9NwWmr7HkKSJyHXSVdTYy8wh7Tes5sw433QgG1+UekOdYPFr
         ezYiBAn6WniK6oDj+2Zdbqp/byie+P2gtKgs4VQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/61] xen/pvcalls: Remove set but not used variable
Date:   Thu, 20 Jun 2019 19:57:39 +0200
Message-Id: <20190620174344.909296746@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 41349672e3cbc2e8349831f21253509c3415aa2b ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/xen/pvcalls-front.c: In function pvcalls_front_sendmsg:
drivers/xen/pvcalls-front.c:543:25: warning: variable bedata set but not used [-Wunused-but-set-variable]
drivers/xen/pvcalls-front.c: In function pvcalls_front_recvmsg:
drivers/xen/pvcalls-front.c:638:25: warning: variable bedata set but not used [-Wunused-but-set-variable]

They are never used since introduction.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pvcalls-front.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/xen/pvcalls-front.c b/drivers/xen/pvcalls-front.c
index 91da7e44d5d4..3a144eecb6a7 100644
--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -538,7 +538,6 @@ static int __write_ring(struct pvcalls_data_intf *intf,
 int pvcalls_front_sendmsg(struct socket *sock, struct msghdr *msg,
 			  size_t len)
 {
-	struct pvcalls_bedata *bedata;
 	struct sock_mapping *map;
 	int sent, tot_sent = 0;
 	int count = 0, flags;
@@ -550,7 +549,6 @@ int pvcalls_front_sendmsg(struct socket *sock, struct msghdr *msg,
 	map = pvcalls_enter_sock(sock);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
-	bedata = dev_get_drvdata(&pvcalls_front_dev->dev);
 
 	mutex_lock(&map->active.out_mutex);
 	if ((flags & MSG_DONTWAIT) && !pvcalls_front_write_todo(map)) {
@@ -633,7 +631,6 @@ static int __read_ring(struct pvcalls_data_intf *intf,
 int pvcalls_front_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		     int flags)
 {
-	struct pvcalls_bedata *bedata;
 	int ret;
 	struct sock_mapping *map;
 
@@ -643,7 +640,6 @@ int pvcalls_front_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	map = pvcalls_enter_sock(sock);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
-	bedata = dev_get_drvdata(&pvcalls_front_dev->dev);
 
 	mutex_lock(&map->active.in_mutex);
 	if (len > XEN_FLEX_RING_SIZE(PVCALLS_RING_ORDER))
-- 
2.20.1



