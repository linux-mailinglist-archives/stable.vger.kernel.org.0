Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BD33738E7
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 12:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhEEK7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 06:59:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231750AbhEEK7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 06:59:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620212318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=eVZxETJuG4ix7xHFzjgnIz8Efp0aN5fvWnhjs+O0we4=;
        b=eJCKQU+QofxKtMgLl5V9XI9P7hkEZ1Z05v7G0UxXVvpSYeiwTK41kiC6CSSV3l6t2KgdDu
        /3zAHKMvXlelPaLmlTTH6oALgABihdQNtknhuAYnlS6bx1/839OtB3gnqGUeBkEBW2dZRG
        YL6rCGNz5ctdRWOnnSTjAXmY9VB/rmI=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-B-_ss3NLMN-TRoByOojH7g-1; Wed, 05 May 2021 06:58:37 -0400
X-MC-Unique: B-_ss3NLMN-TRoByOojH7g-1
Received: by mail-yb1-f198.google.com with SMTP id y5-20020a2586050000b02904ee36d3b170so1867534ybk.10
        for <stable@vger.kernel.org>; Wed, 05 May 2021 03:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=eVZxETJuG4ix7xHFzjgnIz8Efp0aN5fvWnhjs+O0we4=;
        b=jN/ytUNN1EnvY7K5w6J74DIibBcB932u9RN/PI8xOYrtGYrO3qWePQO8gsddaA/8Lh
         5VdLygT5lxvVj3IJcg2sqhGEZM+PxxVGyGl8Pf4qGtrHComN6/WnqWjCIJZtfJi0p+yR
         ibPnNSaTjMAAuZlkZIT88Mg4g1OvAhY5SwgPnudve2mNE+bdoeZ0DC3bxVUDO7XHcrA8
         nnJ4hW6DA3NrLEiOPSplgl2WYah2KHxOuHgwutDAy7xatQl4GgaQR/Xc4FiMqTsyjcRF
         smhH1zMwL74tYx3LDpyqvO9Cuz9xj+cQ7HPOZOzQ2j5EEI953pRZKf1ffW2OA6Egyd0/
         5+/Q==
X-Gm-Message-State: AOAM5305wGQNhlM1kjL65iRe4F3ZWvut8cz5lnFyOabBvpAwwp7/6s41
        eIK0yI44VcE6gOGHMr6PQaiKDyPcOIe+dpC5MHd0Wt0rGIJoBpctl+vu0HrmqH7kVSE1762Jl/V
        ntj5lN/EXf100MkNHrH1DpJnTYDxELJJF
X-Received: by 2002:a25:6983:: with SMTP id e125mr32445012ybc.81.1620212316679;
        Wed, 05 May 2021 03:58:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXIY0ZJN0SM+xk24P20iM3/ySkzqOpDoii2yKz0bwuiZlKDJfgHhLNy3eOMJm8/1fDtijuxQ68c4t8NHZtr/E=
X-Received: by 2002:a25:6983:: with SMTP id e125mr32445001ybc.81.1620212316544;
 Wed, 05 May 2021 03:58:36 -0700 (PDT)
MIME-Version: 1.0
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Wed, 5 May 2021 12:58:24 +0200
Message-ID: <CAFqZXNvt-ezC2hwLC1zOVfgkRwd4483=dXw3k2ALkuRYfR4okA@mail.gmail.com>
Subject: Stable backport request - perf/core: Fix unconditional
 security_locked_down() call
To:     Linux Stable maillist <stable@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

please consider backporting commit 08ef1af4de5f ("perf/core: Fix
unconditional security_locked_down() call") to stable kernels, as
without it SELinux requires an extraneous permission for
perf_event_open(2) calls with PERF_SAMPLE_REGS_INTR unset.

The range of target kernel versions is implied by the Fixes: tag.

Thanks,

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

