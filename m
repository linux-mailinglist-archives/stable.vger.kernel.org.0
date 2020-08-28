Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C514F2560F1
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 21:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgH1TCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 15:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgH1TCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 15:02:17 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530E5C06121B
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 12:01:57 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls14so24095pjb.3
        for <stable@vger.kernel.org>; Fri, 28 Aug 2020 12:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yH7AbDCZOyeny7rN/VjZO9Yhu01+Xgr5P/ecl4toviU=;
        b=I5e40vNgxxInd7oVEnNiEOXaN4MBf0sUWMHJwN6aITD8/aYworWN1SOHs84D68LRA9
         +aKva5rRxua1QgCiQSFm0KY0ZP4uuBDJXbg+RqXhWHOWOU6zSRtaBuiSXOW/tOdCdPOp
         mDb5sGJ1AvN8UkUum+q1xOmH+3yflGRzLA2+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yH7AbDCZOyeny7rN/VjZO9Yhu01+Xgr5P/ecl4toviU=;
        b=q4QBG9WE2TvxnqdZJOH+4cPVCi+BvrklfXp3+dvlA1KawZAUOTkS8z6jMhHUywwmYz
         9RYGhoEAQkodJTwQZPIxjpAYkIXfthsx6qEmqqZ5oZARGw+q6gOFrrNRAO42JyWZhKls
         CbXYga80J8tNtPHmufFtJNkwfNu/vyjpyozZJDS2DMleEbymxDPxSu7p0mFCY1Z8/Iai
         pD/Wg4XqW15yZMI+Fs0mwQ6jkb/tVc5kfNrKl8ocSUaupHPNt5yUCe3oxqwKbLZlDMck
         DNeub/G9QeNsRoEP9tNOtZBjsbQz6fAKO1SO51sdyDoKR/rV2WP/nWu3EJCKDcffRgUP
         iqxw==
X-Gm-Message-State: AOAM531/ZHiZafhSaCAhs3wtVYcRPevmEM6OiDa7sO1QnjSRpzTrs+MZ
        1LAObYYbvte3s4tVCsI8E3M04w==
X-Google-Smtp-Source: ABdhPJysDFT7EZQkaW2FnIARtbZ9pX6dZuZQO3bkb7uPr5nNGAQbW9F6NOLDNRbUahudZJzIutCxbw==
X-Received: by 2002:a17:90a:bd8f:: with SMTP id z15mr388074pjr.58.1598641316636;
        Fri, 28 Aug 2020 12:01:56 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t10sm154393pfq.77.2020.08.28.12.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 12:01:55 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-nvme@lists.infradead.org
Cc:     James Smart <james.smart@broadcom.com>, stable@vger.kernel.org,
        Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH] nvme: Revert: Fix controller creation races with teardown flow
Date:   Fri, 28 Aug 2020 12:01:50 -0700
Message-Id: <20200828190150.34455-1-james.smart@broadcom.com>
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

