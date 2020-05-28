Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9C21E6309
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 15:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390611AbgE1Nzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 09:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390608AbgE1Nzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 09:55:54 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1EEC05BD1E
        for <stable@vger.kernel.org>; Thu, 28 May 2020 06:55:54 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id l17so2570105qvd.9
        for <stable@vger.kernel.org>; Thu, 28 May 2020 06:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=hwB4H+90PXovf4SJvJe9+Rj3bMo+et+KhIqFvByMq6E=;
        b=u6+8QPPPQ1evhnU+zHhuhm+H6IU6aanMcMS3N8hvXpt7mbcsnohnFQr8PfqOqRzsuo
         sKSkl/Azd37Ky+PuLPfAPk1Q6hke/3fsvRg1YUS5wyyFnLnJWFKYU42bpZjHzRae8MJw
         iAzXuxKIWvvjrwsScr1hxlJuUnCmcKdiRoRb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=hwB4H+90PXovf4SJvJe9+Rj3bMo+et+KhIqFvByMq6E=;
        b=GqVeFoD3dic4v681HyyoJCUT9aAf1PeERElSt/YrB2ged90MvL083UA6DRnWSiLmGi
         Dszr2NfJjdpzq+3C9s+60Lbd5XdrcBkyBNYa9TtxEou4SwTL37Qm/s6R74W2jTIyp7pQ
         AOrflu33mWKcv2RFZuj0fH+0XChqinceOhJxUTyUQvMnIU6bkfgxDSG6BmRDP0hPOv7W
         LmM3FnbhSxUbFjNoZ8rBC7R8/zWpQpAiR8u+hh2GDgysE2RjKEm6/leRKCTP6eRfKw4a
         UNZIWB2YwetuoWaXbyZVkRMHK4+iV3VnKJwRpi8LJU8dyU/dLYdcNT/xrWoOmYUEUX7w
         pHaw==
X-Gm-Message-State: AOAM5326J4Bv8lvq09SsdmSeInsFTzCtx5K7vFdu+gAT1irZN1J76jQm
        dYQ08wEZ59wxr8V9A5Z9WGgCUw==
X-Google-Smtp-Source: ABdhPJy70GFvArqMi2mgfoq2tY3XsrKET+a2LQC62Miw0p6xa4bHHnAdp9Xaq4fHExO9rI2jeHDbJA==
X-Received: by 2002:ad4:404b:: with SMTP id r11mr3286859qvp.44.1590674153409;
        Thu, 28 May 2020 06:55:53 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id e34sm5186424qtb.21.2020.05.28.06.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 06:55:52 -0700 (PDT)
Date:   Thu, 28 May 2020 09:55:52 -0400
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-kernel@vger.kernel.org
Cc:     "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        matthewb@google.com, jsbarnes@google.com, vapier@google.com,
        christian@brauner.io, vpillai@digitalocean.com,
        vineethrp@gmail.com, peterz@infradead.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, torvalds@linux-foundation.org
Subject: [PATCH] sched/headers: Fix sched_setattr userspace compilation
 breakage
Message-ID: <20200528135552.GA87103@google.com>
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

This also causes a problem with using sched_attr in Chrome. The issue is
sched_param is already provided by glibc.

Guard the kernel's UAPI definition of sched_param with __KERNEL__ so
that userspace can compile.

Fixes: e2d1e2aec572a ("sched/headers: Move various ABI definitions to <uapi/linux/sched/types.h>"
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

