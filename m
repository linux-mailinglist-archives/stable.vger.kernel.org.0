Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBB22560EC
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 21:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgH1TBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 15:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1TBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 15:01:12 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B027C061264
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 12:01:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i13so29951pjv.0
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 12:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yH7AbDCZOyeny7rN/VjZO9Yhu01+Xgr5P/ecl4toviU=;
        b=UvNdTFwQqclHuc2HKL6Q0eVdT/sS7LAco5WY5/+pw1oOW4FT8M8tumP8mOG09x/9HG
         uCHJXXBMhhcM0VOmFa+6L+oOaSb8OKlZVz6hcj1sKhij8p8+haZGOs8asEq/SdQpBCBa
         0D4peU0pXTyhcWUQydKMzIw9LzZ/7/29HDa/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yH7AbDCZOyeny7rN/VjZO9Yhu01+Xgr5P/ecl4toviU=;
        b=Va5SM7Ot32fWXFBJ5WOxBNP7CIeW6ql8lW42Fd3rzX7J5MN9Jc3sgx4/AkIvwnb30B
         rrs89W8+B4FepHHXMFwZJSmXMaRtNUzF0kynXG7M2viQgoh+QEAyY45UlGjFXK5dNF0t
         RPdisV+h7721ah8MJRrAqbAx83/QHnNBIn7oWLgALPUHZ8BJsZDV72hh1OYLkTLE1x6q
         hMmjWtjp+dnustOahr21L+Rnob66e2l6Iu+PSz/7c39oFJrDc5tkqXTzVYTbzIqCHvr5
         zcJL/vamdlNBEXBPGknDNCL5fBt7+BgPQu2QzuPyy6Antvz7IWbT0beKltaZV2kQGdhq
         6b6w==
X-Gm-Message-State: AOAM532rMEdd1QNf8Gt6t6AjnlcUivHrr9ViZd8pRgzCOg8G2OryKx9f
        CniW86fuvA+e/fTTHOxHD/4YZUT596P5dg==
X-Google-Smtp-Source: ABdhPJz2cdYDxL+B/0qccR3AiEc2NQPcv3xW+0CJDSfFbNq1J/VIDbFPz2vwBX7eoWURQl6SxVa1Xg==
X-Received: by 2002:a17:902:121:: with SMTP id 30mr216479plb.205.1598641271558;
        Fri, 28 Aug 2020 12:01:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o65sm147312pfg.105.2020.08.28.12.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 12:01:10 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     jsmart2020@gmail.com
Cc:     James Smart <james.smart@broadcom.com>, stable@vger.kernel.org,
        Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH] nvme: Revert: Fix controller creation races with teardown flow
Date:   Fri, 28 Aug 2020 12:01:05 -0700
Message-Id: <20200828190105.34401-1-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The indicated patch introduced a barrier in the sysfs_delete attribute
for the controller that rejects the request if the controller isn't
created. "Created" is defined as at least 1 call to nvme_start_ctrl().

This is problematic in error-injection testing.  If an error occurs on
the initial attempt to create an association and the controller enters
reconnect(s) attempts, the admin cannot delete the controller until
either there is a successful association created or ctrl_loss_tmo
times out.

Where this issue is particularly hurtful is when the "admin" is the
nvme-cli, it is performing a connection to a discovery controller, and
it is initiated via auto-connect scripts.  With the FC transport, if the
first connection attempt fails, the controller enters a normal reconnect
state but returns control to the cli thread that created the controller.
In this scenario, the cli attempts to read the discovery log via ioctl,
which fails, causing the cli to see it as an empty log and then proceeds
to delete the discovery controller. The delete is rejected and the
controller is left live. If the discovery controller reconnect then
succeeds, there is no action to delete it, and it sits live doing nothing.

Cc: <stable@vger.kernel.org> # v5.7+
Fixes: ce1518139e69 ("nvme: Fix controller creation races with teardown flow")
Signed-off-by: James Smart <james.smart@broadcom.com>
CC: Israel Rukshin <israelr@mellanox.com>
CC: Max Gurtovoy <maxg@mellanox.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Keith Busch <kbusch@kernel.org>
CC: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/core.c | 5 -----
 drivers/nvme/host/nvme.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 05aa568a60af..86abce864aa9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3481,10 +3481,6 @@ static ssize_t nvme_sysfs_delete(struct device *dev,
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
 
-	/* Can't delete non-created controllers */
-	if (!ctrl->created)
-		return -EBUSY;
-
 	if (device_remove_file_self(dev, attr))
 		nvme_delete_ctrl_sync(ctrl);
 	return count;
@@ -4355,7 +4351,6 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 		nvme_queue_scan(ctrl);
 		nvme_start_queues(ctrl);
 	}
-	ctrl->created = true;
 }
 EXPORT_SYMBOL_GPL(nvme_start_ctrl);
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index c5c1bac797aa..45cf360fefbc 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -300,7 +300,6 @@ struct nvme_ctrl {
 	struct nvme_command ka_cmd;
 	struct work_struct fw_act_work;
 	unsigned long events;
-	bool created;
 
 #ifdef CONFIG_NVME_MULTIPATH
 	/* asymmetric namespace access: */
-- 
2.26.2

