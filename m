Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D692B3A9EE5
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234570AbhFPPZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbhFPPZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 11:25:43 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95508C061574;
        Wed, 16 Jun 2021 08:23:36 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id l3so1785581qvl.0;
        Wed, 16 Jun 2021 08:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4RkdmNkrf3BBo78m/TAwjqmLT/OENZZH2eOGrb77vX4=;
        b=bzw1YVXlqLHxxl0qzwq/c6+VuhQjm1Q7apIuxtL9KODROgrBOp8xFfHPc7sdYh58zK
         Qlx3fMYO2vZG2Sqt7uot9as7F2HRHaQhoL5sLOWTiYZb/ghMCKTEg1rqfXiZg44IeC/F
         vzDKzrZnhMmo6h2PyiMMna8wFpVapRgjYKymXkGnijnQ74KqiFUZLrNFRvmzAQK40Wvc
         StrYm4C8OG7gM6fi2qit+uz6odcqhOPiJN8rKAL92+PumUvpkXcIS3w13gT4L6y2oCsW
         eX5cbx/HLm4kTGoXWUvQ46S+xa/OBpHAxIo57bMx6Kmrpuga5JrIoSd36nPP+VouLgIg
         muXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=4RkdmNkrf3BBo78m/TAwjqmLT/OENZZH2eOGrb77vX4=;
        b=f2OK+IOY+Mnm6soVUTRkuSBxOtYtE4zgIztS3eWzepDOMf3TRQPRe9R2tYc/zeCcnO
         31dJGKLQVgwkLHaLs6qya03rLwljJBq5fpZZ+8EhfYhn6m5hAsDssnV6Cw5zfMHwtWy1
         uo/+Z8J/eZONYpwiVdKZ4+PtwNjZA3+5kmywfclfa35HDUkhU7mpauJ1G6JJmLDOuYQo
         PHsq+ZwR3gb+tTwos6SpkFOYQzIWHpfbpf7A634F/ovK4znmkYMW7zaTfQBtY+KqXECV
         PMplp8KE3cEeHhiXSZ4WzoeCKfQDygbNWQJdq0qgTuakLHJ9TE7w/kGm5uKaiSRlc26Z
         1rDw==
X-Gm-Message-State: AOAM532Kyt2voduorEz3gF+XtY47FfEYoCBq5Etim2cLe8ymMQtLxoC3
        6eJmGn5lUKrpiLvaJJoQ4Oc=
X-Google-Smtp-Source: ABdhPJySeztxTGzuyyO33w/6itru5QmUPDH/0zMlmja2lGi0SRz243v2CgiFD4L9g1ywMFMYOknnkA==
X-Received: by 2002:a05:6214:1c0d:: with SMTP id u13mr445980qvc.49.1623857015666;
        Wed, 16 Jun 2021 08:23:35 -0700 (PDT)
Received: from localhost ([199.192.137.73])
        by smtp.gmail.com with ESMTPSA id l3sm1392700qth.87.2021.06.16.08.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 08:23:35 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 16 Jun 2021 11:23:34 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Paul Gortmaker <paul.gortmaker@windriver.com>
Cc:     linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH] cgroup1: fix leaked context root causing sporadic NULL
 deref in LTP
Message-ID: <YMoXdljfOFjoVO93@slm.duckdns.org>
References: <20210616125157.438837-1-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210616125157.438837-1-paul.gortmaker@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Wed, Jun 16, 2021 at 08:51:57AM -0400, Paul Gortmaker wrote:
> A fix would be to not leave the stale reference in fc->root as follows:
> 
>    --------------
>                   dput(fc->root);
>   +               fc->root = NULL;
>                   deactivate_locked_super(sb);
>    --------------
> 
> ...but then we are just open-coding a duplicate of fc_drop_locked() so we
> simply use that instead.

As this is unlikely to be a real-world problem both in probability and
circumstances, I'm applying this to cgroup/for-5.14 instead of
cgroup/for-5.13-fixes.

Thanks.

-- 
tejun
