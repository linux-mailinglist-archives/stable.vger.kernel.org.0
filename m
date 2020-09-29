Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C12D27C688
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbgI2LqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730999AbgI2LqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D249620702;
        Tue, 29 Sep 2020 11:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379969;
        bh=q4jjtEd3ZJjIdaUmU/BM5CW0hA/WfkWaAf8pdOR6yLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsnyNHyMZGMesLY5vtG2uU9g4AX26IgtHF4B/NdLeOXRLnzaVCNI81PP+OB3axNfz
         QnWXEHPWVjMoplyQHDOFWHRBfRez/SQXPJ+7YDwHRN5WQhwfC+qZHa9ffRDSJ7Sex+
         MfDZvdp0mS89n0xr42cCrVt0tN+C0dbzRIv9GN8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amol Grover <frextrite@gmail.com>,
        James Morris <jmorris@namei.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 01/99] device_cgroup: Fix RCU list debugging warning
Date:   Tue, 29 Sep 2020 13:00:44 +0200
Message-Id: <20200929105929.785402848@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>

[ Upstream commit bc62d68e2a0a69fcdcf28aca8edb01abf306b698 ]

exceptions may be traversed using list_for_each_entry_rcu()
outside of an RCU read side critical section BUT under the
protection of decgroup_mutex. Hence add the corresponding
lockdep expression to fix the following false-positive
warning:

[    2.304417] =============================
[    2.304418] WARNING: suspicious RCU usage
[    2.304420] 5.5.4-stable #17 Tainted: G            E
[    2.304422] -----------------------------
[    2.304424] security/device_cgroup.c:355 RCU-list traversed in non-reader section!!

Signed-off-by: Amol Grover <frextrite@gmail.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/device_cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 43ab0ad45c1b6..04375df52fc9a 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -354,7 +354,8 @@ static bool match_exception_partial(struct list_head *exceptions, short type,
 {
 	struct dev_exception_item *ex;
 
-	list_for_each_entry_rcu(ex, exceptions, list) {
+	list_for_each_entry_rcu(ex, exceptions, list,
+				lockdep_is_held(&devcgroup_mutex)) {
 		if ((type & DEVCG_DEV_BLOCK) && !(ex->type & DEVCG_DEV_BLOCK))
 			continue;
 		if ((type & DEVCG_DEV_CHAR) && !(ex->type & DEVCG_DEV_CHAR))
-- 
2.25.1



