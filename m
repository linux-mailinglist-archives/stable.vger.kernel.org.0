Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CED61DD261
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 17:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgEUPx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 11:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUPx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 11:53:59 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0322EC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 08:53:59 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id g20so3263467qvb.9
        for <stable@vger.kernel.org>; Thu, 21 May 2020 08:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QmEALzhwk7Eo5Ax0b5kpGfmrNonq7wH4jHxYDbMzde8=;
        b=R+635lHhwNb7hME38+md3gHM+CMhfadHVoL2cPwqZk2EVBed1yM+9HNCUK5dpJ+5N1
         WTLhIYe1Vjf3Pa+G29u6AsHFK498lLnjDzv3j4N5p5NmgCdJ9GVpLRVL4NUu9ntugvjH
         bcSoYqNLcRQwKijL/29amOQzu/HHNoqLyFs+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QmEALzhwk7Eo5Ax0b5kpGfmrNonq7wH4jHxYDbMzde8=;
        b=ReTTIfwo53bf8DoMCPbcdiKikItZ4nQgYqAdo4bM/I8S13Z7CNmU0TFc395yLAKd9K
         cXa13FA6U//+BMgDzBpR6ko4vE+erF6BJ7eL9QEMgKuxohLEsiifa+EzFO7zC1YBQ+q9
         2RfOSFck2pgvNpZq5oDG9dfetNwt31DsfuAYfG6nFDT66q4yhkJZ9IUtKTzS4hZLU7xc
         59s+GBzYxo7c5GL0qbUZoU/Mft7dmuIbJy675ljRYXoCwglRicYo/1/zl/dQDKFoAfp3
         f0R8ADB98VQHEPucMdpRk4VmtHVnosKfLDsreNK94U8yKFtaVKSG+zTQ3/PvhvymlLcj
         9/jA==
X-Gm-Message-State: AOAM5321F+ZbE98amciQtEsh5TvkGB/EH17wjL8IX3kh4sl/5M9da8c5
        yBlCl073VNBtYhSrWeCaif5e/A==
X-Google-Smtp-Source: ABdhPJyEWi0GkkYhZZQ2Agt0JEoZv4HIT8vhQHuH7WRbGRrGfL5Wk8l2o369RucwAKJcILEpOQVHQg==
X-Received: by 2002:a0c:fe03:: with SMTP id x3mr10273553qvr.18.1590076438134;
        Thu, 21 May 2020 08:53:58 -0700 (PDT)
Received: from joelaf.cam.corp.google.com ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id z185sm5365661qka.79.2020.05.21.08.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 08:53:57 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        matthewb@google.com, jsbarnes@google.com, vapier@google.com,
        christian@brauner.io, vpillai@digitalocean.com,
        vineethrp@gmail.com, peterz@infradead.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH RFC] sched/headers: Fix sched_setattr userspace compilation issues
Date:   Thu, 21 May 2020 11:53:46 -0400
Message-Id: <20200521155346.168413-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On a modern Linux distro, compiling the following program fails:
 #include<stdlib.h>
 #include<stdint.h>
 #include<pthread.h>
 #include<linux/sched/types.h>

 void main() {
         struct sched_attr sa;

         return;
 }

with:
/usr/include/linux/sched/types.h:8:8: \
			error: redefinition of ‘struct sched_param’
    8 | struct sched_param {
      |        ^~~~~~~~~~~
In file included from /usr/include/x86_64-linux-gnu/bits/sched.h:74,
                 from /usr/include/sched.h:43,
                 from /usr/include/pthread.h:23,
                 from /tmp/s.c:4:
/usr/include/x86_64-linux-gnu/bits/types/struct_sched_param.h:23:8:
note: originally defined here
   23 | struct sched_param
      |        ^~~~~~~~~~~

This is also causing a problem on using sched_attr Chrome. The issue is
sched_param is already provided by glibc.

Guard the kernel's UAPI definition of sched_param with __KERNEL__ so
that userspace can compile.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/uapi/linux/sched/types.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/sched/types.h b/include/uapi/linux/sched/types.h
index c852153ddb0d3..1f10d935a63fe 100644
--- a/include/uapi/linux/sched/types.h
+++ b/include/uapi/linux/sched/types.h
@@ -4,9 +4,11 @@
 
 #include <linux/types.h>
 
+#if defined(__KERNEL__)
 struct sched_param {
 	int sched_priority;
 };
+#endif
 
 #define SCHED_ATTR_SIZE_VER0	48	/* sizeof first published struct */
 #define SCHED_ATTR_SIZE_VER1	56	/* add: util_{min,max} */
-- 
2.26.2.761.g0e0b3e54be-goog

