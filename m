Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845EB1E2DD0
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392448AbgEZTYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391562AbgEZTH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:07:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F147D21501;
        Tue, 26 May 2020 19:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520048;
        bh=/gKgAofv1BeFupKqffHXA4ugZpKvFntfN6UOghDe46E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cm6Swtn7LUu8MA6hvbMObMWYaG4hP63TfiGylcidZS0kIjxTbNOsClDB/sBjyKk31
         y7qMeonVfiPasA+6Prpp4NnLGWUW4ZWADxRDqdQN+bPIQskpX3vMunjsR8l/sUwZCR
         M4l6Pxh5SBLtfBatgHFuZ2vdBZjugyCNtTCbRIPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/111] ceph: fix double unlock in handle_cap_export()
Date:   Tue, 26 May 2020 20:52:57 +0200
Message-Id: <20200526183936.616849066@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
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
index 703945cce0e5..2d602c2b0ff6 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3693,6 +3693,7 @@ retry:
 		WARN_ON(1);
 		tsession = NULL;
 		target = -1;
+		mutex_lock(&session->s_mutex);
 	}
 	goto retry;
 
-- 
2.25.1



