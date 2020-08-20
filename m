Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7854524BA38
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbgHTMCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729754AbgHTJ7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:59:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EDE8207FB;
        Thu, 20 Aug 2020 09:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917578;
        bh=ARihVEuseQCFHZrrPcQ5uuG/aBEPbF+5Kj8+MIjhHeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jt2wCb2h/J5J+XKJ9fXncZKORtGSuBrtazkUdNwYFgKrBddUdEHXZY8zNKue5ULxJ
         BqxP6Jj2np0sh6a3oCMioUmwyvBflskRODSxTVUYx6wpDTKK6G/gyuN8Q29B4Ur++/
         E6fnum0MFycLOu2qEzYs+XojUaGSzXjXprkPmKMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 081/212] cgroup: add missing skcd->no_refcnt check in cgroup_sk_clone()
Date:   Thu, 20 Aug 2020 11:20:54 +0200
Message-Id: <20200820091606.449981045@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

Add skcd->no_refcnt check which is missed when backporting
ad0f75e5f57c ("cgroup: fix cgroup_sk_alloc() for sk_clone_lock()").

This patch is needed in stable-4.9, stable-4.14 and stable-4.19.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f047c73189f36..684d02f343b4c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -6355,6 +6355,8 @@ void cgroup_sk_clone(struct sock_cgroup_data *skcd)
 {
 	/* Socket clone path */
 	if (skcd->val) {
+		if (skcd->no_refcnt)
+			return;
 		/*
 		 * We might be cloning a socket which is left in an empty
 		 * cgroup and the cgroup might have already been rmdir'd.
-- 
2.25.1



