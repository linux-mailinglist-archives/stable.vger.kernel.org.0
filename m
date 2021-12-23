Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB2D47DDC7
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 03:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238478AbhLWCiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 21:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbhLWCiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 21:38:17 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4BAC061574;
        Wed, 22 Dec 2021 18:38:16 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id p4so4138493qkm.7;
        Wed, 22 Dec 2021 18:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SeDS6NYXrws6CvV5v+btXZxjBWdFilmIPCi4J1Jsij4=;
        b=cdTN2Lyd2qFtzNqQAa/hurw13ieJSZQh2PA20jJMNSvTUduwO10i2uTmdWPEX56k5B
         WXq0QwfsQkgyHZzhCV+RS+yRJAHoDCLWuHR94ZSBmWNuKEQEqQiCVns7zMx5f2O3wr1c
         TmlKEuuj9r0yf1B+A4IuVeiMRs0fe/QsQ+rJ89tTlG5BKaMlsmX5rOrPzvVsPs/qhYWb
         S9aZE5dpDbQWTuSuG7hXwcxzxRjum9cI1SPnwJ18cvy5CAqmGNwa3pkTnSQgqeWV1cYw
         p+YW8SUeMck6Q334shIIqKo+sTXHTgQ+farzvBOi1f/MXTL+YQS8oi0ugjcu1uT1uGNT
         dt6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeDS6NYXrws6CvV5v+btXZxjBWdFilmIPCi4J1Jsij4=;
        b=I2Gb00oAz+ZteI7jPuQDMqkP7aRWK6Na204zVbzky/pgOooK6IdqDyUoBdpFkgOaCh
         0dad5w1+wGvkd8AH6DQNKGQdQJdJuoCHLKMSKVVlcnFNByAk2yEO1Cr/po6sQHppI653
         jJvMRTChDNt501suT7fp6VXLx3VzU15GHWZnj4d3ZEjPWaaOgfB7CdBcEZzIAb0BJ8QB
         eMHK/wgG5p4fM8suw1r55wfSNHZPVS9+lwD50ig8NrBOwZSXXIn1mOf7+YmvtmAlnOuL
         LcwvFvf4NJniyx0cNkEIkVqFhtYfBsxXnvo430XqgTNQDGpPMkuh4QPd3XLE73r5BKP/
         6kIg==
X-Gm-Message-State: AOAM533uNDquh89dzqoO87PW1tGLsHod/hP/HneoPqto5euo2AOte3cc
        hCWRTpQ72N3x3wtBmKXQAs8=
X-Google-Smtp-Source: ABdhPJxNr0cmyXs322jx+2McPs82lFRBDqx3ec2ndsROtQFSy3Ji3MEzxlozfESAx7p97chFnmdKsQ==
X-Received: by 2002:a05:620a:68a:: with SMTP id f10mr224581qkh.651.1640227095888;
        Wed, 22 Dec 2021 18:38:15 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id w10sm3350407qtk.90.2021.12.22.18.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 18:38:15 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     manfred@colorfullife.com
Cc:     stable@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        cgel.zte@gmail.com, chi.minghao@zte.com.cn, dbueso@suse.de,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        shakeelb@google.com, unixbhaskar@gmail.com, vvs@virtuozzo.com,
        zealci@zte.com.cn
Subject: [PATCH v2] ipc/sem: do not sleep with a spin lock held
Date:   Thu, 23 Dec 2021 02:37:56 +0000
Message-Id: <20211223023756.555856-1-chi.minghao@zte.com.cn>
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

