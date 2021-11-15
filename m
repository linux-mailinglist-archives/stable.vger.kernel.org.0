Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A918450E96
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhKOSQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240684AbhKOSLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 13:11:47 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6622DC0386D0
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 09:38:52 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id q29-20020a631f5d000000b002dfcc4e0201so7598301pgm.3
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 09:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=gFHzpDmZVv3KTzaa99s4GcDQLq8lkQoNbMRzfWvXXRU=;
        b=E0lMrhcUzQ+Xxg7MzzracGH2o8ZPywwPNThCN8B2PV1+YsxQ7pcG6fw/LsdoL5DhpJ
         Po3s0ulyU4vPeedC/oWHYgY2QT/E5n8f1j7yGJCR4TH0EDLR7pHs43w4Fn0CYmqbDa0b
         C0axRULUIX1exCYTmfoFg2/WV3luxC+wnavfxXcrma1naBKaP+Qwb/UAzxoe3aOMfF+9
         /LhYB/QdqhlAwXaExqi0xERMWK/ww3Q0LLDDgsSqjoH2cQ6ymB4g9FuH95+4++E+m+gv
         gJIlxXphc6ecxg7H1I/CcfAWBgO6rECPBHy08g79iQ2oAy5ZYNMdQUXVfhQ7q0IgGMdk
         CAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=gFHzpDmZVv3KTzaa99s4GcDQLq8lkQoNbMRzfWvXXRU=;
        b=qqis3/FqT5CnjpzBttjvT/0eeBnyXc3qIxKzWQAlGhzaS6eFwcUsgLQQLYetZpPWQp
         nKtPuF1yZJgIIq62t2pa0PAABT9gxsG3Zm2RaDydZ3N+BIQ6H+mqKkj/VfkfLvURwttP
         3lijQezamZ/L2IF3IGJFpEswP8jea15AKAbb+NJt9YnsEc+JlUSpRavo3DgPTa61pVNI
         zdxotm6IGRJRtr8J24QtYH3N5y6fJDLNegNLG40GBHkihP4OOZ2NjC6ZqQLrIFQnJivR
         /RQKeL/KxWOBll/99c2y0Jh4YxvAUecKwc2wc4lq7GjuGtGY6+8sXJdOl6vD2KjrCX5i
         qW+w==
X-Gm-Message-State: AOAM531vVR5GjgOEUjl3QgRwwXZwXZnj+KBLPfIxr8WFoYUjfEkKAulw
        iSH7XyZv87ClBAX6qI+iosd43fUdRms=
X-Google-Smtp-Source: ABdhPJwTAV+ZG+2XqLkeiSQpjZ7KK5I0FTpAB9sdXiyOS+6eC4Xc72hJckhedQD25PX8UC+kT43g6OJrmDU=
X-Received: from adelva.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:b2b])
 (user=adelva job=sendgmr) by 2002:a17:90a:c287:: with SMTP id
 f7mr60754043pjt.114.1636997931798; Mon, 15 Nov 2021 09:38:51 -0800 (PST)
Date:   Mon, 15 Nov 2021 17:38:50 +0000
Message-Id: <20211115173850.3598768-1-adelva@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
From:   Alistair Delva <adelva@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Booting to Android userspace on 5.14 or newer triggers the following
SELinux denial:

avc: denied { sys_nice } for comm="init" capability=23
     scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
     permissive=0

Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
better compatibility with older SEPolicy, check ADMIN before NICE.

Fixes: 9d3a39a5f1e4 ("block: grant IOPRIO_CLASS_RT to CAP_SYS_NICE")
Signed-off-by: Alistair Delva <adelva@google.com>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: selinux@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-team@android.com
Cc: stable@vger.kernel.org # v5.14+
---
 block/ioprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/ioprio.c b/block/ioprio.c
index 0e4ff245f2bf..4d59c559e057 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -69,7 +69,7 @@ int ioprio_check_cap(int ioprio)
 
 	switch (class) {
 		case IOPRIO_CLASS_RT:
-			if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
+			if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 				return -EPERM;
 			fallthrough;
 			/* rt has prio field too */
-- 
2.34.0.rc1.387.gb447b232ab-goog

