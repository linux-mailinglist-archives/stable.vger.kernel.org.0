Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B70447DE04
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 04:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346143AbhLWDMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 22:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhLWDMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 22:12:30 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F23C061574;
        Wed, 22 Dec 2021 19:12:30 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id kd9so4006002qvb.11;
        Wed, 22 Dec 2021 19:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SeDS6NYXrws6CvV5v+btXZxjBWdFilmIPCi4J1Jsij4=;
        b=lnIpIIstAdf8lX2ODAZU9QNo9iQZyp9uwnlJLN2ClL3+GSd4fWiDnDfqr1uWNJujiK
         RTUMqsGf8o2locvL6oq8YRGvnVJdiLm49jG8tn6wyl1yec/RfIsaTtYeYQfQ0/BmXWih
         S3IGmpQp/E4qf2Zwlc8zWhKttfM4eAlZEZqqg7I5vqhM/LsMjkwUiWVHUTYkzut8PwbA
         C/yT3sQl15YacavA9xrNDW9SWFpa8mXsfejkxAT26IUlaPmkF5i1vTKI67BFdXPx3WwB
         VYT3zBky2vSCJF6hGyHkn7TwnIuMX42IVTUab08Je0Dsaliqns+kKUNk0syzLgQp1V58
         zEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeDS6NYXrws6CvV5v+btXZxjBWdFilmIPCi4J1Jsij4=;
        b=CdcOPPyeQTC67KhPW9P5Ow1muVNrcCh+HFvglmSA0nGO5+7mX1RmPIAMAedHujK/Yd
         j7WUbQjJuf/gJ36drJVauKMGu/O4c0ySKSpOo9bjCGVoOfXVPhP8SHaKiFHHaFKBlV56
         CCnd8ds9z26qZoWZz1rYghOnhy/iHA8PETZMI1NLmNCNYY6ajLr2/llaMbZNhHxEAMSg
         j4SSCHUS2cJXANOAJTt554avEsA7TGWTYGdc/QOr6mck0scoepECl0FzPV4FhbtRsLp0
         63hYsZO/pzgqDZ3UddQJjCgr57u3fSk9OXUf6e/H+wUPZBn0GSOpmu5iR4O3tPlyC6YS
         kBOA==
X-Gm-Message-State: AOAM530pBwIjjCCeCfXSqt7EULUEei8k8XsaxBIVaivgQht85x4QoS5A
        /9JHAY6VoE2/3dmB+13RreE=
X-Google-Smtp-Source: ABdhPJxkdOIAJTvKBiHqUS5KFlaxqCE8351plW30Qdp+Jliw+yEmj3hiVcN6Dxs+fIMnMShQt7x9tA==
X-Received: by 2002:a05:6214:4f0:: with SMTP id cl16mr448995qvb.72.1640229149594;
        Wed, 22 Dec 2021 19:12:29 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id bp38sm3275653qkb.66.2021.12.22.19.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 19:12:29 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     manfred@colorfullife.com
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        cgel.zte@gmail.com, chi.minghao@zte.com.cn, dbueso@suse.de,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        shakeelb@google.com, unixbhaskar@gmail.com, vvs@virtuozzo.com,
        zealci@zte.com.cn
Subject: [PATCH v2] ipc/sem: do not sleep with a spin lock held
Date:   Thu, 23 Dec 2021 03:12:07 +0000
Message-Id: <20211223031207.556189-1-chi.minghao@zte.com.cn>
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
@@ -1964,6 +1964,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
+		spin_unlock(&ulp->lock);
 		kvfree(new);
 		goto success;
 	}
@@ -1976,9 +1977,8 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
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

