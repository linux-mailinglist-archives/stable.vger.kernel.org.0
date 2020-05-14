Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8BC1D27F8
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 08:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgENGko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 02:40:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36334 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgENGkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 02:40:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id w19so16332417wmc.1;
        Wed, 13 May 2020 23:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LakL8r2zLTcB3K02mFhWm6Jrh+IpU4qwGN3UNJ1Qag8=;
        b=XISAqZw4Q1JL7fVNlOChtsG+NC4YDeThft8DsFc7Y+JzdHDH17n4MM/oUM53SqsaF0
         xzRH3u2oAcsq3Gh+LBJOQWg8us7vyDeQtWxwhPW+OZKCz0sGOWUKjShHaEo+kVq8y31D
         jntIVKOvNFIpi1g2NgZUTVty+En/XL33+gVHZIVK2CGPywLmMmCrNE69Gc7EPeCXkIMk
         d/Q2TvW4TrFfInPHD+zIApmYbS6CA3kZCU3XMJeNJ4xES2KqHZVhkgPYZf1eXFt9Ba7T
         dRRrRCkOYCZMDt66qfgL8V8k17jGesT5VUNoEQtptNziSgLyipSAk45FY651qQclJkgG
         3Fiw==
X-Gm-Message-State: AGi0Pualil/BhWg8CTt1HxLvs7GhrWzGB94UW3U9MjFnE/F+1z9R2SA6
        cloCd628OEqoDwb7jsS55YY=
X-Google-Smtp-Source: APiQypLnRy9NL6J37yZyCR51Mt9JO5Mhk9186M9YmoEjdBcIKM0vK1HsL2Q4ThrUUwgpGjOqCTc8sw==
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr44463293wmc.114.1589438441521;
        Wed, 13 May 2020 23:40:41 -0700 (PDT)
Received: from localhost (ip-37-188-249-36.eurotel.cz. [37.188.249.36])
        by smtp.gmail.com with ESMTPSA id j1sm2423429wrm.40.2020.05.13.23.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 23:40:40 -0700 (PDT)
Date:   Thu, 14 May 2020 08:40:39 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        lkft-triage@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: stable-rc 5.4: libhugetlbfs fallocate_stress.sh: Unable to
 handle kernel paging request at virtual address ffff00006772f000
Message-ID: <20200514064039.GY29153@dhcp22.suse.cz>
References: <CA+G9fYvvDjA5t+zi0Zyn2F6D=7aE-Gu-m13o47LXYYfCD3SvrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvvDjA5t+zi0Zyn2F6D=7aE-Gu-m13o47LXYYfCD3SvrA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 13-05-20 23:11:40, Naresh Kamboju wrote:
> While running libhugetlbfs fallocate_stress.sh on stable-rc 5.4 branch kernel
> on arm64 hikey device. The following kernel Internal error: Oops:
> crash dump noticed.

Is the same problem reproducible on vanilla 5.4 without any stable
patches?

> 
> fallocate_stress.sh (2M: 64):
> [  129.706506] Unable to handle kernel paging request at virtual
> address ffff00006772f000
> [  129.714638] Mem abort info:
> [  129.717553]   ESR = 0x96000047
> [  129.720726]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  129.726188]   SET = 0, FnV = 0
> [  129.729338]   EA = 0, S1PTW = 0
> [  129.732573] Data abort info:
> [  129.735546]   ISV = 0, ISS = 0x00000047
> [  129.739493]   CM = 0, WnR = 1
> [  129.742534] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000013ad000
> [  129.749409] [ffff00006772f000] pgd=0000000077ff7003,
> pud=0000000077e0d003, pmd=0000000077cd1003, pte=006800006772f713
> [  129.760294] Internal error: Oops: 96000047 [#1] PREEMPT SMP
> [  129.765988] Modules linked in: wl18xx wlcore mac80211 cfg80211
> hci_uart snd_soc_audio_graph_card adv7511 crct10dif_ce wlcore_sdio
> btbcm snd_soc_simple_card_utils cec kirin_drm bluetooth drm_kms_helper
> dw_drm_dsi rfkill drm fuse
> [  129.786626] CPU: 1 PID: 1263 Comm: fallocate_stres Not tainted
> 5.4.41-rc1-00091-g132220af41e6 #1
> [  129.795601] Hardware name: HiKey Development Board (DT)
> [  129.800940] pstate: 80000005 (Nzcv daif -PAN -UAO)
> [  129.805847] pc : clear_page+0x10/0x24
> [  129.809594] lr : __cpu_clear_user_page+0xc/0x18
> [  129.814225] sp : ffff800012a1bbe0
> [  129.817609] x29: ffff800012a1bbe0 x28: fffffe00017d8000
> [  129.823039] x27: ffff000073070268 x26: ffff800011adf000
> [  129.828466] x25: ffff800011ae06c8 x24: 0000000000001000
> [  129.833893] x23: 0000000000000000 x22: fffffe00017d8000
> [  129.839320] x21: 0000000000000000 x20: 0000000006a00000
> [  129.844747] x19: ffff000037945400 x18: 0000000000000000
> [  129.850174] x17: 0000000000000000 x16: 0000000000000000
> [  129.855602] x15: 0000000000000000 x14: 0000000000000000
> [  129.861031] x13: 0000000000000000 x12: 0000000000000000
> [  129.866458] x11: 0000000000000000 x10: ffff800012a1bbd0
> [  129.871886] x9 : 0000000000000200 x8 : 0ffff00000010000
> [  129.877314] x7 : 0000000000000000 x6 : 0000000000000080
> [  129.882741] x5 : 0000000000000036 x4 : 0000020000200000
> [  129.888170] x3 : 0000000000004bc0 x2 : 0000000000000004
> [  129.893597] x1 : 0000000000000040 x0 : ffff00006772f000
> [  129.899025] Call trace:
> [  129.901530]  clear_page+0x10/0x24
> [  129.904926]  clear_subpage+0x54/0x90
> [  129.908580]  clear_huge_page+0x6c/0x208
> [  129.912503]  hugetlbfs_fallocate+0x2e0/0x4a0
> [  129.916869]  vfs_fallocate+0x1b8/0x2e0
> [  129.920699]  ksys_fallocate+0x44/0x90
> [  129.924446]  __arm64_sys_fallocate+0x1c/0x28
> [  129.928811]  el0_svc_common.constprop.0+0x68/0x160
> [  129.933708]  el0_svc_handler+0x20/0x80
> [  129.937539]  el0_svc+0x8/0xc
> [  129.940488] Code: d53b00e1 12000c21 d2800082 9ac12041 (d50b7420)
> [  129.946719] ---[ end trace df98e92a449be749 ]---
> [  129.959274] note: fallocate_stres[1263] exited with preempt_count 1
> 
> ref:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.40-91-g132220af41e6/testrun/1428986/log
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.4-oe/build/v5.4.40-91-g132220af41e6/testrun/1428986/
> 
> kernel config:
> https://builds.tuxbuild.com/SqvcoklXmvQsC70j6rfcgA/kernel.config
> 
> -- 
> Linaro LKFT
> https://lkft.linaro.org

-- 
Michal Hocko
SUSE Labs
