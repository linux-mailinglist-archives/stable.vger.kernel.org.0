Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F631DE821
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 15:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgEVNfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 09:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgEVNfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 09:35:31 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0403DC061A0E
        for <stable@vger.kernel.org>; Fri, 22 May 2020 06:35:30 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id d7so8204475qtn.11
        for <stable@vger.kernel.org>; Fri, 22 May 2020 06:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=654C6HMAJavjEr0S4/IKvBvbc+mHWyzBMrpEJYlc/nQ=;
        b=DmsE28c0J4Ygt6MtPOMJu6De7QbehaWK0RU3Yt0kC42y6Vc7yki+njWWBM7fLypkG/
         UEXTDSBaYM3HFOvM8cVvl53RjaU6IhdSf0zLQ0DUHW4aXXe5/znsiuC1r0m6VIenhnt/
         8+yupTCx847h5bTOXDYzsIAHc6vXTr9aNLSGE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=654C6HMAJavjEr0S4/IKvBvbc+mHWyzBMrpEJYlc/nQ=;
        b=OQDF+1MCINQfF2UuTg4F4wr6oc5ZtfUkfYx0h7VmjL1eQtCVp4dSbsCk6oBB/8+sS7
         ePXZBF9vgG1VzkhZUfVSSKaBjss0QeOLyAOH1FIHJidHFMCehRUyupqkwM5VFWEEaLM2
         mNPMUdij2CwURlk3dQq1MjGhmgZZl3yooXyj9wQ0knbXi8mkSsfqxXbIE74e6Z7htTfn
         5I/0j4pBBgiUFEDWLSkGQSSr29fj2Fe+wFskNKDElA9rM1Z/Gc5iOlenB4r4H+7Xghcf
         E5QVDlqflzwpfDIAMlrnHo2i1YN0u/fdBIDa5dRWjIxvn0HKieB4h0Mv3NUsOLXrXr1A
         s75Q==
X-Gm-Message-State: AOAM532knCVzKKfMHZBSiUwCXpghdzDu0kkjbGNqLhUHnJJcbD46SPJN
        0QN8vd8akQwQ9jH9B/WSkO92Rg==
X-Google-Smtp-Source: ABdhPJz1FUSjDoLtfHJN/Zeql66rPIzcdUtptDSzo52IvftehA3efMQx/T0H8ocig9sAnzaM1pbAfQ==
X-Received: by 2002:ac8:71c1:: with SMTP id i1mr7363784qtp.320.1590154529140;
        Fri, 22 May 2020 06:35:29 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id q46sm2013046qta.79.2020.05.22.06.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 06:35:28 -0700 (PDT)
Date:   Fri, 22 May 2020 09:35:28 -0400
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        matthewb@google.com, jsbarnes@google.com, vapier@google.com,
        christian@brauner.io, vpillai@digitalocean.com,
        vineethrp@gmail.com, peterz@infradead.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, libc-alpha@sourceware.org
Subject: [PATCH RFC v2] sched/headers: Fix sched_setattr userspace
 compilation issues
Message-ID: <20200522133528.GA210175@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
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

This is also causing a problem with using sched_attr in Chrome. The issue is
struct sched_param is already provided by glibc and is in POSIX.

Guard the kernel's UAPI definition of sched_param with __KERNEL__ so
that userspace and the kernel can both compile.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
v1->v2:
With the chance that libc needs resolving something, I'm resending with
libc-alpha added as suggested by Christian, and minor commit message fixes.

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

