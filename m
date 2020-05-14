Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7038A1D3AC0
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgENS6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728373AbgENS4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:56:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED01920727;
        Thu, 14 May 2020 18:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482578;
        bh=V35YNjbOdGZXgdd3JuMWahHuUK6bn++dc51WjtobLbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qA1aQWW3K7+CkABAAoNjjp9126LkpQkIz7mmqcejdUWCd5aLX7N6TY4GTWEwy5FQP
         RIJQPpm5WjOVnXbBF2dBoIHBrZoak/b+yktLzCah5nhMtPQ7nrYZxxcSQXgwBpF2AR
         cwdpGdeWh52T8fD34HL7BCNQN/BAosIvqi1RgnF0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wu Bo <wubo40@huawei.com>, "Yan, Zheng" <zyan@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 22/27] ceph: fix double unlock in handle_cap_export()
Date:   Thu, 14 May 2020 14:55:45 -0400
Message-Id: <20200514185550.21462-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185550.21462-1-sashal@kernel.org>
References: <20200514185550.21462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

[ Upstream commit 4d8e28ff3106b093d98bfd2eceb9b430c70a8758 ]

If the ceph_mdsc_open_export_target_session() return fails, it will
do a "goto retry", but the session mutex has already been unlocked.
Re-lock the mutex in that case to ensure that we don't unlock it
twice.

Signed-off-by: Wu Bo <wubo40@huawei.com>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 617e9ae67f506..e11aacb35d6b5 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3394,6 +3394,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		WARN_ON(1);
 		tsession = NULL;
 		target = -1;
+		mutex_lock(&session->s_mutex);
 	}
 	goto retry;
 
-- 
2.20.1

