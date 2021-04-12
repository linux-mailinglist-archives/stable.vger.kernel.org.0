Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EB535D005
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 20:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbhDLSJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 14:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243338AbhDLSJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 14:09:29 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CB9C06174A
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:09:11 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id d18so7248144qtn.16
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YHUvegXTW3ogsW2Kd44BTYx7zYoANC3O5F45o7xWFi0=;
        b=BmTDC/pUmDJaIZgYDDtwLGGgzkDW+UKPr6oQQT3APLdLVPjFO+haGDg20O4owKZzPR
         WMryUydfGwu9rcZZJgNoCFtlVl/GtkhPZwmWXvNLgzSLqqhQWFaExfW5Wz4bexQNH70Y
         5Z7T5LQAYbdoexQRpZO/NzboaPbhi5GFli1P39t0hYNjsygx5Git5wQ54EfSjxE41Kk4
         zix/hPA+ILLWx4iOyiKMdfT6vyzgQlrLJX4e1CwLPhDe7fI53GXwS7/0Aim1E7YQHfeU
         IlHhoTOxahkqWPrZE7jMhy2sugTG7+E+PCm6K8teTqJ4BvIy3BRjxicPWGe/7lvF2ih8
         NQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YHUvegXTW3ogsW2Kd44BTYx7zYoANC3O5F45o7xWFi0=;
        b=SNizuFNwmsIi39Eaq+uqXCVQZkfi3g7KnIqRKtEPhRWhe4iHuJwb6K+S1gtluXRtDz
         msFDJN3kBZaaZsdRrJYaSAakGv3EOcCw5bhg47Ba4TOVPOPhkUXeAMxusZ7OuJRcsnIV
         amfYwmxcBftiMhRrALQC6nDOli1Cjg4wWWNMXma7RQJ/DmbEn2xQo0A1EEPhdzXmNte9
         P4lXNn0jW1s1PzA5tZSD32aGmbf74m3QdGdTWQhaGzUuCEDHiyUuTEmBpojd+iu7tvZp
         BeONr+b5VTOEY7bPM92LXTdtjU9mVyO1d4bk2v+gOvK8Dj7rdMJr4iqPC2wPlBiE4PRk
         u1uQ==
X-Gm-Message-State: AOAM532vqIb3q4iM/B86RJpRUEkqhvf45a0rRa6vKNNDhjEpgojXvIjp
        fq72vfyLR+tia8P2ZJJYHVp0Xj98cvJqljg=
X-Google-Smtp-Source: ABdhPJzIZ4Fz4rwkHcYXl0FnDvoa1lIX0Bo487av5cQ/BXnBwD3n0FCf6A+SpqyaHHutkoLia+aCdGyPNyicjAA=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:951b:6a90:74:1cd1])
 (user=saravanak job=sendgmr) by 2002:a0c:fc12:: with SMTP id
 z18mr5225480qvo.38.1618250950335; Mon, 12 Apr 2021 11:09:10 -0700 (PDT)
Date:   Mon, 12 Apr 2021 11:09:06 -0700
Message-Id: <20210412180907.1980874-1-saravanak@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
Subject: [PATCH] driver core: Fix locking bug in deferred_probe_timeout_work_func()
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>, stable@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit eed6e41813deb9ee622cd9242341f21430d7789f upstream.

list_for_each_entry_safe() is only useful if we are deleting nodes in a
linked list within the loop. It doesn't protect against other threads
adding/deleting nodes to the list in parallel. We need to grab
deferred_probe_mutex when traversing the deferred_probe_pending_list.

Cc: stable@vger.kernel.org
Fixes: 25b4e70dcce9 ("driver core: allow stopping deferred probe after init")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210402040342.2944858-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Hi Greg,

This should apply cleanly to 4.19 and 5.4 if you think this should be
picked up.

-Saravana

 drivers/base/dd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 4ba9231a6be8..26ba7a99b7d5 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -254,14 +254,16 @@ int driver_deferred_probe_check_state(struct device *dev)
 
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
-	struct device_private *private, *p;
+	struct device_private *p;
 
 	deferred_probe_timeout = 0;
 	driver_deferred_probe_trigger();
 	flush_work(&deferred_probe_work);
 
-	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
-		dev_info(private->device, "deferred probe pending");
+	mutex_lock(&deferred_probe_mutex);
+	list_for_each_entry(p, &deferred_probe_pending_list, deferred_probe)
+		dev_info(p->device, "deferred probe pending\n");
+	mutex_unlock(&deferred_probe_mutex);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
 
-- 
2.31.1.295.g9ea45b61b8-goog

