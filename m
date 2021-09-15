Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7E40CC76
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 20:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhIOSVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 14:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhIOSVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 14:21:31 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62722C061574;
        Wed, 15 Sep 2021 11:20:12 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q26so5291040wrc.7;
        Wed, 15 Sep 2021 11:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jSE5pN30/YzZ6OrArHWoPl/4rxl1uhasUNbr0IfclAs=;
        b=XfWMQ9CO3nvCCfGWVvwSxv+feW8ibR7O/YtZiRGGtGCxudU/ASUXfVNUEzet1J2uGl
         32tSQHCzWB+d8r89wwxt7/nw3jgKDcZoWxDBXCGNdPM0oYWfb0qwq6/sPKKY0JRyZkiv
         x6SF/mxhnEjUBKcdr1H2mwPhC/phN60mZNHDCo1YJcUcB2w79jKPIKcgHePIE0Dj17Ow
         WCphH+xV973EyHNAuj1OVWNRMVQMDp8WVihwmbguroUhQiNPrKrttNyL1uVn4K2qX68G
         SpmsUEDt9MPkK7Dx73/Ks90TcAvX1sDt0PlW+E8DG//o1Aw5eP68pe1ssDN5V6nhKPaO
         ClLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jSE5pN30/YzZ6OrArHWoPl/4rxl1uhasUNbr0IfclAs=;
        b=Hv2cK7SZh6PzbMjF/BJeAvzSVdV3YTAKl9A0JtHZUNn0Uzx5qJgY67sniNE2Z6essQ
         SRUWsa5YSuLlDLSo/ycepbCxt52nKJb44/urVDAMf/iBFDXwl5aLTAf2UQcVgT97qugl
         8sI9QT3p884sPq5yAaCl+8xe99xTeizXy5+J76rXiS/NzIC2m+pHGIpRKUapYOuD7PX3
         wVNCfrPAYTS6sghC69aqOoUBl/3mVQrP6QIdnisnSvynJDJ8iQNkpJyRkyD/wLby68Q+
         ZFO94oOAYiTMZTnj/sa4YUIlVxgB6PZA+ZQcZ7FzgKDV6h/cMLXbXuNgowJHzHFWCotI
         oZ0g==
X-Gm-Message-State: AOAM531WMC9iZE9pOnGhDz2c6KXzHkJElvw1j/wmHYJ9P5hqjKscOFsr
        S/oqkdrCHDOXavo4kSxV8Ok=
X-Google-Smtp-Source: ABdhPJznqmrebHw99NUbmJhyWBDTuXzpEDf33k6QDmoSSsyxADKOV8z6W2P+tccR/fL6J+9MPbExYg==
X-Received: by 2002:adf:e390:: with SMTP id e16mr1508899wrm.217.1631730010863;
        Wed, 15 Sep 2021 11:20:10 -0700 (PDT)
Received: from localhost.localdomain ([141.226.242.178])
        by smtp.gmail.com with ESMTPSA id u16sm730516wmc.41.2021.09.15.11.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 11:20:10 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 5.10] fanotify: limit number of event merge attempts
Date:   Wed, 15 Sep 2021 21:20:08 +0300
Message-Id: <20210915182008.1369659-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b8cd0ee8cda68a888a317991c1e918a8cba1a568 upstream.

Event merges are expensive when event queue size is large, so limit the
linear search to 128 merge tests.

[Stable backport notes] The following statement from upstream commit is
irrelevant for backport:
-
-In combination with 128 size hash table, there is a potential to merge
-with up to 16K events in the hashed queue.
-
[Stable backport notes] The problem is as old as fanotify and described
in the linked cover letter "Performance improvement for fanotify merge".
This backported patch fixes the performance issue at the cost of merging
fewer potential events.  Fixing the performance issue is more important
than preserving the "event merge" behavior, which was not predictable in
any way that applications could rely on.

Link: https://lore.kernel.org/r/20210304104826.3993892-6-amir73il@gmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/linux-fsdevel/20210202162010.305971-1-amir73il@gmail.com/
Link: https://lore.kernel.org/linux-fsdevel/20210915163334.GD6166@quack2.suse.cz/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 1192c9953620..c3af99e94f1d 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -129,11 +129,15 @@ static bool fanotify_should_merge(struct fsnotify_event *old_fsn,
 	return false;
 }
 
+/* Limit event merges to limit CPU overhead per event */
+#define FANOTIFY_MAX_MERGE_EVENTS 128
+
 /* and the list better be locked by something too! */
 static int fanotify_merge(struct list_head *list, struct fsnotify_event *event)
 {
 	struct fsnotify_event *test_event;
 	struct fanotify_event *new;
+	int i = 0;
 
 	pr_debug("%s: list=%p event=%p\n", __func__, list, event);
 	new = FANOTIFY_E(event);
@@ -147,6 +151,8 @@ static int fanotify_merge(struct list_head *list, struct fsnotify_event *event)
 		return 0;
 
 	list_for_each_entry_reverse(test_event, list, list) {
+		if (++i > FANOTIFY_MAX_MERGE_EVENTS)
+			break;
 		if (fanotify_should_merge(test_event, event)) {
 			FANOTIFY_E(test_event)->mask |= new->mask;
 			return 1;
-- 
2.16.5

