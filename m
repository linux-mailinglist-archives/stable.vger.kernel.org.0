Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1D31676F0
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730984AbgBUH77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:59:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:60184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730982AbgBUH76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:59:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B4FB206ED;
        Fri, 21 Feb 2020 07:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271997;
        bh=4MDVES3THZ/HyptygoMnFX/brvs0LcNdsxCNUjLPTbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlo08bQOQLosRIi6x6tlJhV4GhWDPOdx7R7nBS3NThJlzmQtKP/n81SV0RaAIOV7v
         kALMf1n+J3ZYYIc9uwm1R/l4MwIihMhNP1yjg8Fb2l+dNvB6vJSvIRXHYDWi39xZrE
         FO7Tz5b3QbVWwXR98nSFl4MZx17Z81xVV74TF/B8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Amol Grover <frextrite@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 377/399] nvmet: Pass lockdep expression to RCU lists
Date:   Fri, 21 Feb 2020 08:41:42 +0100
Message-Id: <20200221072436.950442563@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>

[ Upstream commit 4ac76436a6d07dec1c3c766f234aa787a16e8f65 ]

ctrl->subsys->namespaces and subsys->namespaces are traversed with
list_for_each_entry_rcu outside an RCU read-side critical section but
under the protection of ctrl->subsys->lock and subsys->lock respectively.

Hence, add the corresponding lockdep expression to the list traversal
primitive to silence false-positive lockdep warnings, and harden RCU
lists.

Reported-by: kbuild test robot <lkp@intel.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Amol Grover <frextrite@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 28438b833c1b0..35810a0a8d212 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -555,7 +555,8 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 	} else {
 		struct nvmet_ns *old;
 
-		list_for_each_entry_rcu(old, &subsys->namespaces, dev_link) {
+		list_for_each_entry_rcu(old, &subsys->namespaces, dev_link,
+					lockdep_is_held(&subsys->lock)) {
 			BUG_ON(ns->nsid == old->nsid);
 			if (ns->nsid < old->nsid)
 				break;
@@ -1172,7 +1173,8 @@ static void nvmet_setup_p2p_ns_map(struct nvmet_ctrl *ctrl,
 
 	ctrl->p2p_client = get_device(req->p2p_client);
 
-	list_for_each_entry_rcu(ns, &ctrl->subsys->namespaces, dev_link)
+	list_for_each_entry_rcu(ns, &ctrl->subsys->namespaces, dev_link,
+				lockdep_is_held(&ctrl->subsys->lock))
 		nvmet_p2pmem_ns_add_p2p(ctrl, ns);
 }
 
-- 
2.20.1



