Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD73533A293
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 05:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhCNEId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 23:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbhCNEIK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 23:08:10 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D40C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 20:08:09 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id v4so3921454wrp.13
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 20:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lightbitslabs-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=VTKl2FLJgLhcNftnXOusaOX5U0FyPDhSsCE9hBmzZ7o=;
        b=agc4mM0pCwJ2ZlhODVU/CjFXH7aPdssByNg80fsZSglwrnKKNwot1FiDflRmn73Cmg
         iKL5j81ATRHm7IOFXZLUAYTve2Ti2V7Lxh9y7zU3P+MwiwfSPSa06kIcKXct5MouDc9f
         F6gAouYLiccW/TmrivTIiLdFUB92J6e/7ERc1EZVFprPgPEy6edDpwoVs8OurHJXsCKS
         NnONfuyrfVWlgp7yTDf5at4ftYGgqt2MIp1PNgpm2YY2Ss3eDWm+Bfsgkbvlwmd1XHHf
         ltWhbntITbSA28ABOt38F28IfBDLkr7+WUcbVg4cQkahg4UeaRFTTp6TXtEt0PJLZM+Q
         3XRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=VTKl2FLJgLhcNftnXOusaOX5U0FyPDhSsCE9hBmzZ7o=;
        b=hFVSwERi3w4sJHFb3zwaYfmcAwpmNbOAYSS1q5u2ad5uxKsbicw3whqIBj0NcKoroj
         y6R5JqdLx7BzGuOgNvuBjJ9/JIYSarzTzM+Zk2B5E8Y5zb3ax939l5OfsE3HJJQZjnCR
         5brkrU6Al1XeaqFYEQKE4zQmugWzj3ap5kngb8ntN7PD/LzE+5lcDeGjPCQIRYATRLz4
         eQqDnpU6bPf9kqHV+8uJeQEQdVITiSQSCprhOoftxVI6obuwnizf6aUuMuQcwO1oAvVi
         ozvbg2PdpnyCam7evB1V7m8429OEFZkn6nMmh1XDnekVWzcuIaVcMzoi845TF3XzzzcN
         hQng==
X-Gm-Message-State: AOAM531sH1OP1vjQObTZoJ2FOgrlBh38pCRCqUgS+uJ5JYwzLqa3rGTp
        lqqGiIaUCmZIETcZQtQRCBs36/ifJippiyMA0BK6gHn6QgFazfsVGiMDWBvn0j3/9VOHYiAFZPQ
        am/DQfrMcoXwjKrAl0g==
X-Google-Smtp-Source: ABdhPJwvU6ebKtl/MsqyAiGQ5fXEcRKiVmZnvvKU+gXeoBJyHCz0+t9wMMzJ2qH0cnnAuvjmP7S0Ug==
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr22207061wrw.247.1615694888020;
        Sat, 13 Mar 2021 20:08:08 -0800 (PST)
Received: from anton-latitude..lbits ([98.42.3.175])
        by smtp.googlemail.com with ESMTPSA id l15sm14148746wru.38.2021.03.13.20.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 20:08:07 -0800 (PST)
From:   Anton Eidelman <anton@lightbitslabs.com>
To:     stable@vger.kernel.org
Cc:     kbusch@kernel.org, sagi@grimberg.me, hch@lst.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] nvme: unlink head after removing last namespace
Date:   Sat, 13 Mar 2021 20:07:04 -0800
Message-Id: <20210314040705.1357858-2-anton@lightbitslabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210314040705.1357858-1-anton@lightbitslabs.com>
References: <20210314040705.1357858-1-anton@lightbitslabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

The driver had been unlinking the namespace head from the subsystem's
list only after the last reference was released, and outside of the
list's subsys->lock protection.

There is no reason to track an empty head, so unlink the entry from the
subsystem's list when the last namespace using that head is removed and
with the mutex lock protecting the list update. The next namespace to
attach reusing the previous NSID will allocate a new head rather than
find the old head with mismatched identifiers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d0f65322156c..15b9e60be204 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -433,7 +433,6 @@ static void nvme_free_ns_head(struct kref *ref)
 
 	nvme_mpath_remove_disk(head);
 	ida_simple_remove(&head->subsys->ns_ida, head->instance);
-	list_del_init(&head->entry);
 	cleanup_srcu_struct(&head->srcu);
 	nvme_put_subsystem(head->subsys);
 	kfree(head);
@@ -3414,7 +3413,6 @@ static int __nvme_check_ids(struct nvme_subsystem *subsys,
 
 	list_for_each_entry(h, &subsys->nsheads, entry) {
 		if (nvme_ns_ids_valid(&new->ids) &&
-		    !list_empty(&h->list) &&
 		    nvme_ns_ids_equal(&new->ids, &h->ids))
 			return -EINVAL;
 	}
@@ -3660,6 +3658,8 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
  out_unlink_ns:
 	mutex_lock(&ctrl->subsys->lock);
 	list_del_rcu(&ns->siblings);
+	if (list_empty(&ns->head->list))
+		list_del_init(&ns->head->entry);
 	mutex_unlock(&ctrl->subsys->lock);
 	nvme_put_ns_head(ns->head);
  out_free_id:
@@ -3679,7 +3679,10 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 
 	mutex_lock(&ns->ctrl->subsys->lock);
 	list_del_rcu(&ns->siblings);
+	if (list_empty(&ns->head->list))
+		list_del_init(&ns->head->entry);
 	mutex_unlock(&ns->ctrl->subsys->lock);
+
 	synchronize_rcu(); /* guarantee not available in head->list */
 	nvme_mpath_clear_current_path(ns);
 	synchronize_srcu(&ns->head->srcu); /* wait for concurrent submissions */
-- 
2.25.1


-- 


*Lightbits Labs**
*Lead the cloud-native data center
transformation by 
delivering *scalable *and *efficient *software
defined storage that is 
*easy *to consume.



*This message is sent in confidence for the addressee 
only.  It
may contain legally privileged information. The contents are not 
to be
disclosed to anyone other than the addressee. Unauthorized recipients 
are
requested to preserve this confidentiality, advise the sender 
immediately of
any error in transmission and delete the email from their 
systems.*

