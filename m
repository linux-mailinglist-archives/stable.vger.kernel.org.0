Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A3B1E2E65
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390834AbgEZTAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390829AbgEZTAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:00:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 490D12084C;
        Tue, 26 May 2020 19:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519651;
        bh=ILwT70Cu0LJH0/kO36gQlvNSSlI2KrmFVUhgvqYSduo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0A+u7XT2VrDkDr1tiQcKBeomIqCHU5MaSkcMoq2HEDH3+vIV1EOpe+bNNb8nI4BvN
         96lTEZOlKSCJ/1xg59gSYrXPounRu73jyawvIppVXPXR1Duu6PDBxWrmLCCivi/fs9
         8KjhKu31G2k4aKsyo3SRmslpejtUp0XErUn9bhhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/59] ceph: fix double unlock in handle_cap_export()
Date:   Tue, 26 May 2020 20:53:07 +0200
Message-Id: <20200526183915.566662300@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1b5a50848b5b..589cfe3ed873 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3502,6 +3502,7 @@ retry:
 		WARN_ON(1);
 		tsession = NULL;
 		target = -1;
+		mutex_lock(&session->s_mutex);
 	}
 	goto retry;
 
-- 
2.25.1



