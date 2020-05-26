Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFE11E2AAA
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 20:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389442AbgEZS5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390185AbgEZS5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:57:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18580214D8;
        Tue, 26 May 2020 18:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519469;
        bh=cO2riDSx2jLAx5ZL8lJ5UDHZRjMrSl2uLHgV3V/L+vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnvDKKZ1t7HPySMzx7uqmv99ANv1cIMXtdJAKg2LLdilIFcQ11W3h4G1zNMyGjqsL
         /4BIWtjQHPOmaCs+2T0gqYir1c6jFMwZGytVmf2UY18aIspeNJeQUVA1JhmCEsRAAt
         QPIQ46Iv5U2cyOQD0jxh1KENzuF+zD81Vm1RXoEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 16/64] ceph: fix double unlock in handle_cap_export()
Date:   Tue, 26 May 2020 20:52:45 +0200
Message-Id: <20200526183918.707378282@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
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
index 617e9ae67f50..e11aacb35d6b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3394,6 +3394,7 @@ retry:
 		WARN_ON(1);
 		tsession = NULL;
 		target = -1;
+		mutex_lock(&session->s_mutex);
 	}
 	goto retry;
 
-- 
2.25.1



