Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF2D47DDEA
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 03:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241956AbhLWC5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 21:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242024AbhLWC4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 21:56:54 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F79C061757;
        Wed, 22 Dec 2021 18:56:53 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id fq10so3981794qvb.10;
        Wed, 22 Dec 2021 18:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iOaeq1ltcsHbT2VFHG2JnaFkk9N0hH51i2oF/BC7WdM=;
        b=BZSRI2qumXOY5MVBm8/Hd12OBgjK/ia30/Ksq2FaklvZAR1AFabkD87VBtJnaKjByl
         SSZSNM5zVd1CPPMraVVpgOyvPXfZv80EJV64+euzSEwjZj2Ho0zMnkXRCqyvs+8QQiis
         L5v4gAdkapMXJyL58EmjpTNBsbyzfjI6JeMpYd1GMXsysnzKs6m8YZ4nmV4wQWHgkcj9
         8dmq2c9SE2PE3zRZqu0iPHUKqHIg4cKRWTq8Tup5pdo0OLZnCiV+5pq2FNmoiPHs/kEk
         XAGP8xRGe7KGMXxdxVkKImV4Q9/FLcPqE3AOWb7A2L01PA0aEjjJYkdIBhA0CjTkbzhJ
         qcNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iOaeq1ltcsHbT2VFHG2JnaFkk9N0hH51i2oF/BC7WdM=;
        b=BW2o8rw1TQLu771kpNeKuD54/yfwm63xCmIMqaMPk8hoPAkwmnx4bI6SxDnSmeVS5R
         p31CmFAW5uqAmhTN0jk9OpALFGGFq85fdNpfsQW2vlc6iNBmz4Ez5R4URq3PjapUvdkk
         JGcSJL00E7lEdicLjNap+zhocGX4uMzl66hvnClLfG9IUnhr4jIAKRMuy8cSdbpr80uD
         udwqKuSSk9pKurAbFYTGiTV0Zv04KFnoYjqSeyxbMsI879aV9OuMYQXlsJNvVN1FPDF0
         DTdj/Yi8hcCsIEDVtkK6+jQwPYpFYKth4+44Gj0mW6I0yoLeaRTVGEmvfTqzpX0iKQ/4
         w4og==
X-Gm-Message-State: AOAM530LUyh/RjIMpXMunbqHQeUBFuk98vy4LwMxowkv+zm9g6OBSEsq
        ed2qiZ3oN4D2MUFd67Qmx0s=
X-Google-Smtp-Source: ABdhPJz4e+/HZaPc8a1onr4hOorROLgx6m4j2H5jR66b9xo88LrpKXaMPcwQ6YZOIDr6d9FlHOPtqw==
X-Received: by 2002:a05:6214:76a:: with SMTP id f10mr440043qvz.80.1640228213118;
        Wed, 22 Dec 2021 18:56:53 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s126sm3126273qkf.7.2021.12.22.18.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 18:56:52 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     manfred@colorfullife.com
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        cgel.zte@gmail.com, chi.minghao@zte.com.cn, dbueso@suse.de,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        shakeelb@google.com, unixbhaskar@gmail.com, vvs@virtuozzo.com,
        zealci@zte.com.cn
Subject: [PATCH v2] ipc/sem: do not sleep with a spin lock held
Date:   Thu, 23 Dec 2021 02:56:23 +0000
Message-Id: <20211223025623.556044-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <63840bf3-2199-3240-bdfa-abb55518b5f9@colorfullife.com>
References: <63840bf3-2199-3240-bdfa-abb55518b5f9@colorfullife.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

We can't call kvfree() with a spin lock held, so defer it.
Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo
allocation")

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
changelog since v2:
+ Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo
+ allocation")
 ipc/sem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 6693daf4fe11..0dbdb98fdf2d 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1964,6 +1964,7 @@ static struct sem_undo *find_alloc_undo(struct
ipc_namespace *ns, int semid)
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
+		spin_unlock(&ulp->lock);
 		kvfree(new);
 		goto success;
 	}
@@ -1976,9 +1977,8 @@ static struct sem_undo *find_alloc_undo(struct
ipc_namespace *ns, int semid)
 	ipc_assert_locked_object(&sma->sem_perm);
 	list_add(&new->list_id, &sma->list_id);
 	un = new;
-
-success:
 	spin_unlock(&ulp->lock);
+success:
 	sem_unlock(sma, -1);
 out:
 	return un;
-- 
2.25.1

