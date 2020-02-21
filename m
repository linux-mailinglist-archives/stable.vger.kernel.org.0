Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E9E167509
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388273AbgBUIWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:22:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388272AbgBUIWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:22:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 526F324672;
        Fri, 21 Feb 2020 08:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273337;
        bh=JyqHc7oHZofqx/5w0IE55UzicqWG+qZhwSUz1m9zPm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTFnTVVcIcIjEouavm90l82c6mYGk1OVYiSuS3TcAUVNOevx3GKHJYJFk58pqcE+O
         8PfGCRXD8z0ak3vBRNOHQa0dNzSLVYwyipHNKe10qMdrM/mNkODpZyl1qsrMMOCHeU
         VdWyrNAq/5cVzQPjcLkcBzuWXy0mZ1F5QkTaEgoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jaihind Yadav <jaihindyadav@codeaurora.org>,
        Ravi Kumar Siddojigari <rsiddoji@codeaurora.org>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/191] selinux: ensure we cleanup the internal AVC counters on error in avc_update()
Date:   Fri, 21 Feb 2020 08:40:58 +0100
Message-Id: <20200221072301.396268238@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaihind Yadav <jaihindyadav@codeaurora.org>

[ Upstream commit 030b995ad9ece9fa2d218af4429c1c78c2342096 ]

In AVC update we don't call avc_node_kill() when avc_xperms_populate()
fails, resulting in the avc->avc_cache.active_nodes counter having a
false value.  In last patch this changes was missed , so correcting it.

Fixes: fa1aa143ac4a ("selinux: extended permissions for ioctls")
Signed-off-by: Jaihind Yadav <jaihindyadav@codeaurora.org>
Signed-off-by: Ravi Kumar Siddojigari <rsiddoji@codeaurora.org>
[PM: merge fuzz, minor description cleanup]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/avc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index 83eef39c8a799..d52be7b9f08c8 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -896,7 +896,7 @@ static int avc_update_node(struct selinux_avc *avc,
 	if (orig->ae.xp_node) {
 		rc = avc_xperms_populate(node, orig->ae.xp_node);
 		if (rc) {
-			kmem_cache_free(avc_node_cachep, node);
+			avc_node_kill(avc, node);
 			goto out_unlock;
 		}
 	}
-- 
2.20.1



