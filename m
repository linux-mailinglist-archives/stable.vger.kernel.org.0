Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA53E2B75A1
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 06:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgKRFRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 00:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgKRFRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 00:17:12 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4F6C061A4D
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 21:17:11 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id gj5so934054ejb.8
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 21:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ZGiaC/aZwLqgseKttDTSIk4SHX5hWDlbguFGb2lvQsw=;
        b=Hp3KxZu707bFASJokOgasIWZ0YTtF0yduORhdQn4GqgcZKodREFdfS4+0kbF4hHcaX
         rjQvze4chJ73hkSkRBeRkqI3dxvBXC5YN5jyFnbFkSoQzd0jHKOTNZOk6Ej0nLwD9DWc
         a1XRUVdDKh8Kq29MVl1yh0dNIeTKZvCEHuupo8VjuxT69dP1jWabO7zhQkpDCOwbT4pL
         PQyJVf9mxor78ukEegS3kQafRNfEwXwNzeQOIHEHUB4Jl3rsV6OgVoQIURsvHnT8KmYs
         /DXEe057g268HFxKvXnSDYtWn6YKX3tToACWgeNEijwJUzbisWpC+DEhXAeBx5iWnHv7
         ox9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ZGiaC/aZwLqgseKttDTSIk4SHX5hWDlbguFGb2lvQsw=;
        b=L51mo8yde+/T8PnMRPRCkHLvIzn89Rz4N8p5AWX/FMgwo7Rjycdu6KLA+E2QmymaWq
         5UctCdzcaB2GbjNPdrLKb+WgFB7WCsNUqx+Ie96SFOP/vYiAqMz5VQ9oI3Ud9wx+4IcO
         QnEPb/sFNOc/Kf27MdN/D/OVBOcbNQ0nUz5jMXrcE+TJ4mrWRRlsaTSon34VXcggc89s
         vPcfXUYYS+fEFBZ1nMj+aBaWuhoiZzuLfg8msqLUlPfhMSdTbZlnAB69azAUFYSs2bXC
         7+JRKQOBEFTuILurTstgAOe+8xuHPms5C4ec+HQHFpeMOAsjl19iwXp9MDg5Ffzd0lxo
         264g==
X-Gm-Message-State: AOAM531C9jvsz9A+bPQ92sTI7MDrvwEIc0a7ta+GnlwmEJ5Jw90C3YfQ
        Q63f45gqGY9utWTxEdGvs35bsF7Kwea9tceiwJr54wdRnblj6a1d
X-Google-Smtp-Source: ABdhPJwIWP1pAH5eg7LQv2y3gsh374/S6tLuSFmZ+PtssJwoSBTnUyvucU+I858Ch5WNsi7PtIAoUD6HbZsW60xhxPU=
X-Received: by 2002:a17:906:3087:: with SMTP id 7mr21817189ejv.375.1605676629505;
 Tue, 17 Nov 2020 21:17:09 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Nov 2020 10:46:58 +0530
Message-ID: <CA+G9fYsk54r9Re4E9BWpqsoxLjpCvxRKFWRgdiKVcPoYE5z0Hw@mail.gmail.com>
Subject: [stable-rc 5.9] BUG: Invalid wait context on arm64 db410c device
To:     linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While booting stable rc 5.9.9-rc1 kernel on arm64 Qualcomm db410c device
the following BUG: Invalid wait context noticed.

This issue has not reproduced after several testing loops.

[   18.667840]
[   18.667865] =============================
[   18.668392] [ BUG: Invalid wait context ]
[   18.672301] 5.9.9-rc1 #1 Not tainted
[   18.676291] -----------------------------
[   18.679939] systemd-udevd/415 is trying to lock:
[   18.683846] ffff00003a73c718 (&mm->mmap_lock){++++}-{3:3}, at:
__might_fault+0x60/0xa8
[   18.688537] other info that might help us debug this:
[   18.696259] context-{4:4}
[   18.701379] 1 lock held by systemd-udevd/415:
[   18.703982]  #0: ffff800012781a38 (rcu_read_lock){....}-{1:2}, at:
xa_load+0x0/0x178
[   18.708328] stack backtrace:
[   18.716137] CPU: 0 PID: 415 Comm: systemd-udevd Not tainted 5.9.9-rc1 #1
[   18.719003] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[   18.725687] Call trace:
[   18.732369]  dump_backtrace+0x0/0x1f8
[   18.734540]  show_stack+0x2c/0x38
[   18.738360]  dump_stack+0xec/0x158
[   18.741658]  __lock_acquire+0x520/0x1478
[   18.744956]  lock_acquire+0x120/0x4c8
[   18.749035]  __might_fault+0x84/0xa8
[   18.752597]  copy_page_to_iter+0xb4/0x3e8
[   18.756242]  generic_file_buffered_read+0x4bc/0xa98
[   18.760148]  generic_file_read_iter+0xd4/0x168
[   18.764836]  blkdev_read_iter+0x50/0x78
[   18.769349]  new_sync_read+0x100/0x1a0
[   18.773082]  vfs_read+0x1b4/0x1d8
[   18.776900]  ksys_read+0x74/0xf8
[   18.780286]  __arm64_sys_read+0x24/0x30
[   18.783586]  el0_svc_common.constprop.3+0x7c/0x198
[   18.787143]  do_el0_svc+0x34/0xa0
[   18.792005]  el0_sync_handler+0x16c/0x210
[   18.795390]  el0_sync+0x140/0x180

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

full test log details,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.8-256-gfb1622495321/testrun/3452274/suite/linux-log-parser/test/check-kernel-bug-1951524/log
https://lkft.validation.linaro.org/scheduler/job/1951524#L4210

metadata:
  git branch: linux-5.9.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: fb1622495321923cbb1ae2c6cf2da1e9ca286800
  git describe: v5.9.8-256-gfb1622495321
  make_kernelversion: 5.9.9-rc1
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/dragonboard-410c/lkft/linux-stable-rc-5.9/32/config

-- 
Linaro LKFT
https://lkft.linaro.org
