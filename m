Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF67D18E84
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 18:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfEIQy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 12:54:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41541 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfEIQy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 12:54:29 -0400
Received: by mail-pg1-f196.google.com with SMTP id z3so1504045pgp.8
        for <stable@vger.kernel.org>; Thu, 09 May 2019 09:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=VjLMmGrBQrSeTrPwInoxRsPkAG9gPr0ot/6E1y/jS+k=;
        b=jpFo2X28alIOpHg+vMiHsRGmHkJP3eYXiB9OIidRyxJO237Um6i4uYjoPLcg/yqwfP
         yL29TVJEx3OzDQte+ixkF8qBGJhQkNnzPIX6TGWp3BDUI8ZBkyz7qIK8Bz/5eI43J+E4
         NAnhl3uOYDnyZfTVozEXCfC5AXBMSvc9eFUu8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=VjLMmGrBQrSeTrPwInoxRsPkAG9gPr0ot/6E1y/jS+k=;
        b=EcWwhwnDg6RdGNfsyKPpOwiOUlX/An9f6xdJU8h7xOoSdrY2PMKKs7NO0drwuchD6d
         p3qWJcU65znwoOeUE4KmiHe/0xLJHFe6DwvUT06pMn00qI9FgQ2KMTrEfBRcRV9xk2V6
         c88YDBFJNU8O5Papa8OgYFHqkqk3S/hJzwO0arXhpLgl5ReXYSvy5L0MepsyzS7tP3Hp
         +ghOUsh8KTonHAJ8NQa1aG8W4FK0h28mOq+xp5ewFO2tUh0K8kn58HkBcAztBezEz6uk
         RMZJmQA665VWQMowZ/MaUm5wIihfvSmdG9WrCktbpC671pO3S3pKUujWC3lUsn0m1dLL
         d0jA==
X-Gm-Message-State: APjAAAW0HbecMco0PHrQFV+BmyaOKtXwbs5xW5F/S3zdinf63EoXmYBa
        sm5vRbC+f/W5CIe3nyA11dSja98hfck=
X-Google-Smtp-Source: APXvYqw2Oncg8LRa6/QatbhDUkcy6rdYGiY5UIKeRUREEC537FFe2898oRbYjWE2Le51eFBjRVnbZA==
X-Received: by 2002:a63:3dcf:: with SMTP id k198mr7078440pga.60.1557420868018;
        Thu, 09 May 2019 09:54:28 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id o73sm5980412pfi.137.2019.05.09.09.54.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 May 2019 09:54:27 -0700 (PDT)
Date:   Thu, 9 May 2019 09:54:14 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net
Subject: 8651be8f14a1 ("ipv6: fix a potential deadlock in
 do_ipv6_setsockopt()")
Message-ID: <20190509165413.GA126940@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Syzkaller has triggered a lockdep warning when fuzzing a 4.4 kernel with the following stacktrace.

Call Trace:
 [<ffffffff81cb9fad>] __dump_stack lib/dump_stack.c:15 [inline]
 [<ffffffff81cb9fad>] dump_stack+0xc1/0x124 lib/dump_stack.c:51
 [<ffffffff813eceac>] print_circular_bug.cold.51+0x1bd/0x27d kernel/locking/lockdep.c:1226
 [<ffffffff81207f1a>] check_prev_add kernel/locking/lockdep.c:1853 [inline]
 [<ffffffff81207f1a>] check_prevs_add kernel/locking/lockdep.c:1958 [inline]
 [<ffffffff81207f1a>] validate_chain kernel/locking/lockdep.c:2144 [inline]
 [<ffffffff81207f1a>] __lock_acquire+0x38da/0x52a0 kernel/locking/lockdep.c:3213
 [<ffffffff8120b0be>] lock_acquire+0x15e/0x440 kernel/locking/lockdep.c:3592
 [<ffffffff82a53056>] __mutex_lock_common kernel/locking/mutex.c:624 [inline]
 [<ffffffff82a53056>] mutex_lock_nested+0xc6/0x10b0 kernel/locking/mutex.c:744
 [<ffffffff822e186c>] rtnl_lock+0x1c/0x20 net/core/rtnetlink.c:70
 [<ffffffff828ae743>] ipv6_sock_mc_close+0x113/0x350 net/ipv6/mcast.c:288
 [<ffffffff82875f06>] do_ipv6_setsockopt.isra.12+0xce6/0x2cc0 net/ipv6/ipv6_sockglue.c:202
 [<ffffffff82877f7c>] ipv6_setsockopt+0x9c/0x130 net/ipv6/ipv6_sockglue.c:905
 [<ffffffff828863af>] udpv6_setsockopt+0x4f/0x90 net/ipv6/udp.c:1436
 [<ffffffff82250fef>] sock_common_setsockopt+0x9f/0xe0 net/core/sock.c:2693
 [<ffffffff8224e223>] SYSC_setsockopt net/socket.c:1780 [inline]
 [<ffffffff8224e223>] SyS_setsockopt+0x163/0x250 net/socket.c:1759
 [<ffffffff82a5f267>] entry_SYSCALL_64_fastpath+0x1e/0xa0

Could the following patch be applied in order to v4.4.y? This patch is present in
linux-4.9.y.
* 8651be8f14a1 ("ipv6: fix a potential deadlock in do_ipv6_setsockopt()")

Tests run:
* Chrome OS tryjobs
* Syzkaller reproducer


Thanks,
- Zubin
