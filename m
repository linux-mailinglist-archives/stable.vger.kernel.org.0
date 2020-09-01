Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6411A259E71
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 20:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgIASxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 14:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgIASxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 14:53:06 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D57C061249;
        Tue,  1 Sep 2020 11:53:06 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id b3so1722916qtg.13;
        Tue, 01 Sep 2020 11:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V69TM0TXJZV6Ph3DQcWjjVMFJyyhsm9AOvCWZiY6Tfg=;
        b=npTqPcLDLPp9IG+8hih3s0n1i8HE84G+rEqAq7/0mzOvX4YAHvQawMoRbgGBQt3Yig
         2eneUEERH+HTyLTzXLB4YL2RGRONA0RTWYNtrj47yF3wKaXG1SvQcwpDJCy21eZ5Jsca
         sZEjiM8Q8sRrkCSCdh7obp3ZwzFnJGVNkTOhuz/R6vNzBKji4+ZPo5x3PfxZMyNd2OBO
         M4MTsGJ65P64qH13pbf0vQEUgLCZYCKSqoDEAtJXuzOVPMrbIWAIgJY6kryL066yazx7
         Vx3KNiFq7vpMib+dcpa+l8yunUwdH0plUmX8yPgAs/DeFZ1XTCDGXi3fKIOkg1FtiVS1
         14Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=V69TM0TXJZV6Ph3DQcWjjVMFJyyhsm9AOvCWZiY6Tfg=;
        b=cnJZo/Dt72HBDE5s+8d5RYjwUgpq3tGYuLztZuckz2LwqW3SEmNbiRgdrcQf0k9VS5
         s/JvjUO8npffcxcGN6JtQsxr/ERjjj43+ga0WxU9msqKNsm1UbkpOx/9CNeIu7Nl83bZ
         ukDTkvYazFamr6/3xZn0glhCwAdaG2klSme9sKgKgjpn1H+0ynzB7LVHYaL4F7ooMoxX
         0xVZSxqFutfo6MlkbkYMQDEtcFMq1dBleU+Kdx5LV0R+lI1/Poi2aOe9UuYbyqvJc1KC
         z7yMzSB8sDlyZdzx9zijgssyK8YsQWQF+SFumFRvX/n8U9e4mzwJnO39Cjttd7y9Bmgr
         Ge1Q==
X-Gm-Message-State: AOAM532soo0nFo2HYG+vuUNTJEdIY89ZGrLmfgl5YEUC3GXOlhx9jrnw
        TOIk0crfFD+dYxSdoQ+nII0=
X-Google-Smtp-Source: ABdhPJyrnP9lJ/BIih++V+RCRNXE1ATUVDvzcPOodkJQX4aRSSsI0GgfivjUcfbZX/LofdivzaRlEg==
X-Received: by 2002:ac8:5303:: with SMTP id t3mr3360197qtn.159.1598986385416;
        Tue, 01 Sep 2020 11:53:05 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:a198])
        by smtp.gmail.com with ESMTPSA id x26sm2262245qtr.78.2020.09.01.11.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 11:53:04 -0700 (PDT)
From:   Tejun Heo <tj@kernel.org>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com,
        Tejun Heo <tj@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 01/27] blk-iocost: ioc_pd_free() shouldn't assume irq disabled
Date:   Tue,  1 Sep 2020 14:52:31 -0400
Message-Id: <20200901185257.645114-2-tj@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ioc_pd_free() grabs irq-safe ioc->lock without ensuring that irq is disabled
when it can be called with irq disabled or enabled. This has a small chance
of causing A-A deadlocks and triggers lockdep splats. Use irqsave operations
instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org # v5.4+
---
 block/blk-iocost.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 413e0b5c8e6b..d37b55db2409 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2092,14 +2092,15 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 	struct ioc *ioc = iocg->ioc;
+	unsigned long flags;
 
 	if (ioc) {
-		spin_lock(&ioc->lock);
+		spin_lock_irqsave(&ioc->lock, flags);
 		if (!list_empty(&iocg->active_list)) {
 			propagate_active_weight(iocg, 0, 0);
 			list_del_init(&iocg->active_list);
 		}
-		spin_unlock(&ioc->lock);
+		spin_unlock_irqrestore(&ioc->lock, flags);
 
 		hrtimer_cancel(&iocg->waitq_timer);
 		hrtimer_cancel(&iocg->delay_timer);
-- 
2.26.2

