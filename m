Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AD646FDBE
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 10:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239388AbhLJJb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 04:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239450AbhLJJb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 04:31:56 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFD0C061746;
        Fri, 10 Dec 2021 01:28:21 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y13so27557933edd.13;
        Fri, 10 Dec 2021 01:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wo+kEjPRCNOeRmpc24VwDoZ3sGXxzMQEGIk47myQMF4=;
        b=D25x5s7aOfBvkoF1TAnTBMhjleDypIR/jVNd0p2Z75eSnIZErDAv1fx6EJlzyYEERD
         rWV5T4fMEPDldGHGy4lzjbH3kK0SbORPAwBxvAUGhcNaDSrirLbvpNIXQFsSlrLISZpT
         8EOim2hyYjFNofT0F/PjVWXDxbocKSnhkeWUqI5OyqmPf2t4jS2iSgJ3Mtzqt5Hr1Fpm
         oXJkmh2A/7omfykgSbnPUptdgPB7L2dfxgU0jrKd8c9WMhF2cwUEQg0p7Ikio0NbJu9d
         uKeBFO4Egbg/KQ0sOh+YG+ckeIcBg/bMkIkQpCJxqs5lWNnFvg6wHJ/eSZ4h2OX3+avB
         HkZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wo+kEjPRCNOeRmpc24VwDoZ3sGXxzMQEGIk47myQMF4=;
        b=pGfC4gUUWrwWijdt5FIrVFflHcXbi6EnxUGo6nn24bPe1wEcuD1h3yvGu29vp4eTAm
         ucHpYmwA4z8BF8kJ5dGmtdFqKzGQRjfim1qB9+rksmMFD3x0dz9a6FWVkm0GqqIlZCUB
         nWwxjPjVz3aKBg2dOoIQ4F9n1FFSBkwVaz+AMN3Z7CEhedvKaKKbuIA02J7kEzyL2gye
         Ya4fYfwMXYnhEjy/fW9r3Vqr/X5lt6QKe2beMUdJOJP/CIR0zZnlwWuTWDMxqVMStuBL
         bIa2cVl2zUsCoiFi5/1wv1DAt9UCnarI/zmnxG6aB8wPM2hMxJkuzYmzeAlTLIbrCFBV
         AoGA==
X-Gm-Message-State: AOAM533XcPe6ocYIvNCyC9VcEfkYvWSwibx9EZYAvJ5bFtDZMObSLkS4
        NvBxyiqqZbpVEuxHDcV2GGFckoymrnoFvQ==
X-Google-Smtp-Source: ABdhPJwcTAzhR9JhHlzlbR4kehZa3+II/LWyggzIRg1fSi6WukM1ZJJNUF2G5HcniWyScx8qbyyG8g==
X-Received: by 2002:a05:6402:1e95:: with SMTP id f21mr38172357edf.139.1639128499650;
        Fri, 10 Dec 2021 01:28:19 -0800 (PST)
Received: from a2klaptop.epam.com (host-176-36-245-220.b024.la.net.ua. [176.36.245.220])
        by smtp.gmail.com with ESMTPSA id u10sm1100969edo.16.2021.12.10.01.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 01:28:19 -0800 (PST)
From:   Oleksandr Andrushchenko <andr2000@gmail.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        stable@vger.kernel.org
Subject: [PATCH] xen/gntdev: fix unmap notification order
Date:   Fri, 10 Dec 2021 11:28:17 +0200
Message-Id: <20211210092817.580718-1-andr2000@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

While working with Xen's libxenvchan library I have faced an issue with
unmap notifications sent in wrong order if both UNMAP_NOTIFY_SEND_EVENT
and UNMAP_NOTIFY_CLEAR_BYTE were requested: first we send an event channel
notification and then clear the notification byte which renders in the below
inconsistency (cli_live is the byte which was requested to be cleared on unmap):

[  444.514243] gntdev_put_map UNMAP_NOTIFY_SEND_EVENT map->notify.event 6
libxenvchan_is_open cli_live 1
[  444.515239] __unmap_grant_pages UNMAP_NOTIFY_CLEAR_BYTE at 14

Thus it is not possible to reliably implement the checks like
- wait for the notification (UNMAP_NOTIFY_SEND_EVENT)
- check the variable (UNMAP_NOTIFY_CLEAR_BYTE)
because it is possible that the variable gets checked before it is cleared
by the kernel.

To fix that we need to re-order the notifications, so the variable is first
gets cleared and then the event channel notification is sent.
With this fix I can see the correct order of execution:

[   54.522611] __unmap_grant_pages UNMAP_NOTIFY_CLEAR_BYTE at 14
[   54.537966] gntdev_put_map UNMAP_NOTIFY_SEND_EVENT map->notify.event 6
libxenvchan_is_open cli_live 0

Cc: stable@vger.kernel.org
Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/gntdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index fec1b6537166..59ffea800079 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -250,13 +250,13 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 	if (!refcount_dec_and_test(&map->users))
 		return;
 
+	if (map->pages && !use_ptemod)
+		unmap_grant_pages(map, 0, map->count);
+
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
 		evtchn_put(map->notify.event);
 	}
-
-	if (map->pages && !use_ptemod)
-		unmap_grant_pages(map, 0, map->count);
 	gntdev_free_map(map);
 }
 
-- 
2.25.1

