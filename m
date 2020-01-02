Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4712712E943
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 18:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgABRYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 12:24:25 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55580 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727880AbgABRYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 12:24:23 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so6190248wmj.5;
        Thu, 02 Jan 2020 09:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vn6xY74ZAHf5UXr9SkY5xfMygu9Z5Gc/im6mstwFvf0=;
        b=h4rz0FNbsGFBoCp9A74wHTOndORuPQ0li2XYGekvUA2OyINJgjgFUX3YhOPQCGJt30
         uoDbXxwA5mLFlnFeecPALaEQQD8T4qunF9Yc1KjfEvMDJL7hTMIf3E/VRiP992QN67MD
         rlSd8QmM9osfSfYjZacCchY15eUB6uTTR+uSzII+0b/CdK0AShMgWeZmUc7pAtW0puGu
         UgddoyEoxt0eu6NB/4TWmLQIU8pc29ZXZtUAZQJdj3IYJKOot0dVySR5AWfntF1aWDlp
         YiEVFzxiHI/4mDqmoOkYYekatoYgjaYaz/KHSXYa4Q/p7zpBzs/jJ4ksC+tt10GVr3t9
         apSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vn6xY74ZAHf5UXr9SkY5xfMygu9Z5Gc/im6mstwFvf0=;
        b=pLWy5ojzukBgteMpl/OU9ceIc++52M2Fs+CzOuuukmSEEKUMp4rAjkwHvgZjTn07Hl
         2yURQO5P68NHEHDfI/scOsTO3wGWtstG1dmEI7ZxhZRO+U5FuRIAsVpX+72nD1JvscZl
         cqKdKkBau8tmQxjGqpQg3i+0e4ozuPqsW20MyGP+YfAhT90TAGR/34thk+mlajyASlQ7
         PrgHh2mNWV9YEo4z/e+bDUvTM+U0HOu3x0aJC/unvP7aMAUw7rDHYO7yoYJf5Tmm2Teq
         czElzigYVMyenrQJ3fsV93KkT4+F1xYaJ1cqOA/SYF/kTunELGdHfOTRlq5M//cOe6cO
         LFXw==
X-Gm-Message-State: APjAAAXxzjPKwUtALPdb4DXX7Usm5Npa8a+qb0c2RVsMt+09NUM8DEv1
        3bkjZNhWIv2LNJb1AZ5vxiVaQ79peVZ6rh3T
X-Google-Smtp-Source: APXvYqwyb8nu0nKF/2GxMONQB6130c1fK0CNWOm9EaQnistFdiJE9rEtJTHx+J++25XZoJEDS/g8AQ==
X-Received: by 2002:a1c:964f:: with SMTP id y76mr15063961wmd.62.1577985862154;
        Thu, 02 Jan 2020 09:24:22 -0800 (PST)
Received: from amanieu-laptop.home ([2a01:cb19:8051:6200:3fe7:84:7f3:e713])
        by smtp.gmail.com with ESMTPSA id z21sm9480328wml.5.2020.01.02.09.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 09:24:21 -0800 (PST)
From:   Amanieu d'Antras <amanieu@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>, stable@vger.kernel.org,
        Amanieu d'Antras <amanieu@gmail.com>
Subject: [PATCH 7/7] clone3: ensure copy_thread_tls is implemented
Date:   Thu,  2 Jan 2020 18:24:13 +0100
Message-Id: <20200102172413.654385-8-amanieu@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102172413.654385-1-amanieu@gmail.com>
References: <20200102172413.654385-1-amanieu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

copy_thread implementations handle CLONE_SETTLS by reading the TLS
value from the registers containing the syscall arguments for
clone. This doesn't work with clone3 since the TLS value is passed
in clone_args instead.

Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
Cc: <stable@vger.kernel.org> # 5.3.x
---
 kernel/fork.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 2508a4f238a3..080809560072 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2578,6 +2578,16 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 #endif
 
 #ifdef __ARCH_WANT_SYS_CLONE3
+
+/*
+ * copy_thread implementations handle CLONE_SETTLS by reading the TLS value from
+ * the registers containing the syscall arguments for clone. This doesn't work
+ * with clone3 since the TLS value is passed in clone_args instead.
+ */
+#ifndef CONFIG_HAVE_COPY_THREAD_TLS
+#error clone3 requires copy_thread_tls support in arch
+#endif
+
 noinline static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 					      struct clone_args __user *uargs,
 					      size_t usize)
-- 
2.24.1

