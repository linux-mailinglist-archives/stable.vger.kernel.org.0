Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E762B40CD1C
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 21:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhIOTV5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 15:21:57 -0400
Received: from rfvt.org.uk ([37.187.119.221]:50460 "EHLO rfvt.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230451AbhIOTV5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 15:21:57 -0400
Received: from wylie.me.uk (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by rfvt.org.uk (Postfix) with ESMTPS id F0B17827CB;
        Wed, 15 Sep 2021 20:20:33 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wylie.me.uk;
        s=mydkim005; t=1631733634;
        bh=ogDUH93s53wuqMg2oUAx5yzY8kc92Y7RrFfX/CWZBsw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=VEmyGhSE+7/dsMBN+Yi5HccUfp3jGNfqgv4vmhvirMouO76s1G/l9QWobSspJjYdl
         LuL9d7/AjGTVmIpr2WdO/fFuaFklQ5447HfU6qTBekUvtvNRuC1M73IWWPc4qqRHGO
         smpv/9KJ48gVWYhlBMiLqAeQEU6YuiCMpk16IFpMKEIA+65oZbrsWYaqWZhMbKXcUA
         l9SR6gHYVi8XDtXY+DbH7Iy0JmqELzHx8+ugu/ssJxL3FKSEyRaDhcZ2Gm9stv8QKD
         5ybG8fWJyeeQH4jrnKdfb8TQt3ASMdr+jspsJXhCtJwdRc6WfOxvn6YErVbdPFeg5n
         j3unSSLIwE4aw==
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24898.18305.575576.22805@wylie.me.uk>
Date:   Wed, 15 Sep 2021 20:20:33 +0100
From:   "Alan J. Wylie" <alan@wylie.me.uk>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in posix-cpu-timers.c (was Re: Linux 5.14.4)
In-Reply-To: <20210915183152.GA22415@lothringen>
References: <1631693373201133@kroah.com>
        <87ilz1pwaq.fsf@wylie.me.uk>
        <20210915183152.GA22415@lothringen>
X-Mailer: VM 8.2.0b under 27.2 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

at 20:31 on Wed 15-Sep-2021 Frederic Weisbecker (frederic@kernel.org) wrote:

> Right, this should fix the issue: https://lore.kernel.org/lkml/20210913145332.232023-1-frederic@kernel.org/

Indeed it does.

# uname -a
Linux bilbo 5.14.4-dirty #15 SMP PREEMPT Wed Sep 15 20:10:28 BST 2021
x86_64 AMD FX(tm)-4300 Quad-Core Processor AuthenticAMD GNU/Linux

# su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --off"
Maintenance mode disabled
#

$ git diff
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index a002685f688d..8cb280237327 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1346,7 +1346,8 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clkid,
                        }
                }
 
-               *newval += now;
+               if (*newval)
+                       *newval += now;
        }
 
        /*

Thanks
Alan

-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience
