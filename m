Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2E01AE8F0
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 02:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgDRAXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 20:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgDRAXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 20:23:50 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CF8C061A0C
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 17:23:49 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f82so3919638ilh.8
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 17:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n2qLE2G8t+4kBjJT4y5Xe4DOkOSyCHux45pVS8x0Spg=;
        b=gs/7xHPEUNSHl0NwQVcWeBYp4sMe4h1lH2lSbTuiFVnnGLuKRkMowZlDEnZU/Y5W0o
         O2ai9DhGRW7EqjjCU3aLB7u40h8SGTMEcyxjrO1NrWl8d/tDfjnBa5VRLZUUneF0KFrd
         MF5VKfiAGYIYtQvI9DH5EvZi9N7QhAz4UGjeuQM95WfC8PmAO4BAX/iVPdnRctRZ5qYK
         I2YO0SbfNQZ4zHnX17FMMz3VZ2cFd5gykLPo7tzD0BeDAUhXV50WR2BoOMVcPeUcEceM
         u2t7qYPfNhmc40ZEBOWTf3NaOdTLq6Q4+7SpfbaqG5YEWo2xUJytpD5tF1kU3yQjM6oO
         kAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n2qLE2G8t+4kBjJT4y5Xe4DOkOSyCHux45pVS8x0Spg=;
        b=g9TO7WXybMxN+PeoYADtjKmB3T5klFOIFpoFwCvcsdCAhNHigPKue3peFvUYfqhWIQ
         McKFs9JFnxTStdcDoV+c6D5/sAsF5dwCWmfuGlIWhqsIhYllTjV49tyMgOLVY4HKdUEm
         Xx4eWALGnPjm/v0c2BLkRZJmUppgyIEL4II9o8dRUt1n9TNQejNN599w8hh1P0sQ+W0d
         BPpter2DD2ZAnJXI1oGhX+h89DcuUP+n4yOpUWw/ogOfSHqVXOrvfupscYyqZVOOZGXB
         Yuye2QwyDagRc40L/Pf2Nj7CIbDIvbuOpde9cowlp+b70nHPo83/ouZh+kQpuz32QWvA
         C1lg==
X-Gm-Message-State: AGi0PuaBEdT1/+qI6pSZECzDzhzUjKqlCEVOR4drTuTkFNAlsH6RRfLn
        trOBATnBbDmHcrbx/3afoHaZ1r5W7Iuck4q0Shx90g==
X-Google-Smtp-Source: APiQypIswlXVNlq/cTlU7RiOgAIJbXe1nMiEWPEeoDDeQYS1EtG0lCLMhAhpnCwo3bKYIoW08yEYlr+g5K/s6caFjfI=
X-Received: by 2002:a92:9a4d:: with SMTP id t74mr6018056ili.168.1587169429042;
 Fri, 17 Apr 2020 17:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200412140427.6732-1-laoar.shao@gmail.com> <20200413193111.GA1559372@chrisdown.name>
 <20200414181921.GA1864550@chrisdown.name>
In-Reply-To: <20200414181921.GA1864550@chrisdown.name>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 18 Apr 2020 08:23:13 +0800
Message-ID: <CALOAHbBNb9AU5wdH5pN2cROQWOJqJnpP_zFjNVuLTid7i40+8Q@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix inconsistent oom event behavior
To:     Chris Down <chris@chrisdown.name>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Shakeel Butt <shakeelb@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 2:19 AM Chris Down <chris@chrisdown.name> wrote:
>
> To be clear, you're correct that this wasn't intended to result in any changes
> on cgroup v1, so I'm not against the change. Especially for stable, though, I'd
> like to understand what the real results and ramifications are here.

As explained above, the user tool parsing memory.oom_control is
affected by this behavioral change, and what's worse is there is no
documentation on it. I'm not agaist it if we think that is not enough
to cc:stable.

Thanks
Yafang
