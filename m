Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269DC46FEF5
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 11:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbhLJKvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 05:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbhLJKvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 05:51:22 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4A2C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 02:47:47 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id j3so14257268wrp.1
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 02:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oeFfIaVG6Vjk5LxrBcJnGbc+tBqLMKdutZ/SryhO6s8=;
        b=eFNrn8xWzgcr8gtecFZHEC8aLkKUvRvl4jhPNky3Q9fCHrRWbBxmFtzQUitHuUUNTh
         WVskTP9YhXJpsYoMOAiiq61EmkpFId9TUzQ+4f0ZbNxaJjzeKE4LTwpOaXstLZDGT59M
         PEN0rJxh5oboxooIRIjpmoua4pog7Kv1tOOjzI1G7+IvR8ulJatJB+VpYuvhJRIp0GeB
         PNBOVL77IMciiAJ73Oki4Or7Hjki4V5URRytTp1+47rYYR1DSZi7c9YfmOD4+Awu/DHw
         Ulc3FANMAEK7n0THwGKK/Xx7wUc4gLvfLNYtlP5KN2ZSvKIwijI+9RkJbIWXEZ/qfJIT
         0SUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oeFfIaVG6Vjk5LxrBcJnGbc+tBqLMKdutZ/SryhO6s8=;
        b=n0NFRTgI9lAMiQEb0EvAC9zIkMg9fohMSRpGLDb4FTjRgKwOdnivX7rDyM6nFQybpg
         rIEUAxr9LX6krE0z1d7CijCq7FMZePPRJhsjqR4+1l/3Syw0E2Zi51FXwYpIdLrMut6l
         ZohhPNOMhJpn/73N4GfFHNPJwuNUKSY5B6WXQ32OXl985BxkTXSJRKCdcZBX5DveSzTn
         dhktaVkxj76DwjXLUUsgHCGFu/G1grQKYSA9hg4L4Vv6nPHhkVsOR8rrbrRBSB2px02P
         Cl7z+1MdOor1DMqmzwphz+BR7gCAr+9nzZJ5OoEMzBLa6GbZ4jRshpSCgTyyJOF0IcKz
         RbOQ==
X-Gm-Message-State: AOAM5324MTSTzWgNKQXBy5VtRSlMzGlft0HvC6r4nBn331YU4y7CZCN8
        +WfCLR6wlNUjPnFWVW0+1p2dIQ==
X-Google-Smtp-Source: ABdhPJwFChta3LQvzNbiDvZ9w30l6uLeUPNaUC6jLIiDRpz4YdPHrnsYLiaJBDumMErQUq4AHbUmkA==
X-Received: by 2002:a5d:4901:: with SMTP id x1mr12640600wrq.473.1639133266292;
        Fri, 10 Dec 2021 02:47:46 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id m3sm2159507wrv.95.2021.12.10.02.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:47:45 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Subject: [PATCH 4.19.y 4/5] net: sched: add helper function to take reference to Qdisc
Date:   Fri, 10 Dec 2021 10:47:28 +0000
Message-Id: <20211210104729.582403-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211210104729.582403-1-lee.jones@linaro.org>
References: <20211210104729.582403-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit 9d7e82cec35c027756ec97e274f878251f271181 ]

Implement function to take reference to Qdisc that relies on rcu read lock
instead of rtnl mutex. Function only takes reference to Qdisc if reference
counter isn't zero. Intended to be used by unlocked cls API.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Lee: Sent to Stable]
Link: https://syzkaller.appspot.com/bug?id=d7e411c5472dd5da33d8cc921ccadc747743a568
Reported-by: syzbot+5f229e48cccc804062c0@syzkaller.appspotmail.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/net/sch_generic.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 04a5133d875e8..c0147888b1555 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -118,6 +118,19 @@ static inline void qdisc_refcount_inc(struct Qdisc *qdisc)
 	refcount_inc(&qdisc->refcnt);
 }
 
+/* Intended to be used by unlocked users, when concurrent qdisc release is
+ * possible.
+ */
+
+static inline struct Qdisc *qdisc_refcount_inc_nz(struct Qdisc *qdisc)
+{
+	if (qdisc->flags & TCQ_F_BUILTIN)
+		return qdisc;
+	if (refcount_inc_not_zero(&qdisc->refcnt))
+		return qdisc;
+	return NULL;
+}
+
 static inline bool qdisc_is_running(struct Qdisc *qdisc)
 {
 	if (qdisc->flags & TCQ_F_NOLOCK)
-- 
2.34.1.173.g76aa8bc2d0-goog

