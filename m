Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79C45B6EAE
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 15:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiIMN5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 09:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbiIMN5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 09:57:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D3B4360C
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 06:57:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EB0EB80EAC
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 13:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DB0C433D6;
        Tue, 13 Sep 2022 13:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663077469;
        bh=ZIyHkOzqx21MUlfKayxM1wfUOZPZ/gdoHn5CSruudnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=piD3eDZBua60SwjpPYCh5/oxTrw5/UPaw0sGWTmDRQCPbzMr+tt9FwEI/ihm4Iq3R
         VuWM2lGSbCDiQpbZFiRgaPIH6GY4kJogGiUXn+g6CWGfSVqala02r5fUIp57Th7YEb
         BQ1hn8OEzPqFuTBi785b3tMQ4ajzf69cPyRzLkS8=
Date:   Tue, 13 Sep 2022 15:58:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Imran Khan <imran.f.khan@oracle.com>,
        Xuewen Yan <xuewen.yan@unisoc.com>
Subject: Re: stable-rc: 5.4: cgroup.c:2404:2: error: implicit declaration of
 function 'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
Message-ID: <YyCMdfrtgtXhCXTy@kroah.com>
References: <CA+G9fYtro2f2u3Wug7YS7kC=iVGWsee+Vnvm4U20+xXsYVjK5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtro2f2u3Wug7YS7kC=iVGWsee+Vnvm4U20+xXsYVjK5w@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 04:48:44PM +0530, Naresh Kamboju wrote:
> On stable-rc 5.4 arm and arm64 builds failed due to following errors / warnings.
> 
> kernel/cgroup/cgroup.c:2404:2: error: implicit declaration of function
> 'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
>         cpus_read_lock();
>         ^
> kernel/cgroup/cgroup.c:2404:2: note: did you mean 'cpuset_read_lock'?
> include/linux/cpuset.h:58:13: note: 'cpuset_read_lock' declared here
> extern void cpuset_read_lock(void);
>             ^
> kernel/cgroup/cgroup.c:2417:2: error: implicit declaration of function
> 'cpus_read_unlock' [-Werror,-Wimplicit-function-declaration]
>         cpus_read_unlock();
>         ^
> kernel/cgroup/cgroup.c:2417:2: note: did you mean 'cpuset_read_unlock'?
> include/linux/cpuset.h:59:13: note: 'cpuset_read_unlock' declared here
> extern void cpuset_read_unlock(void);
>             ^
> 2 errors generated.
> 
> drivers/gpu/drm/drm_lock.c:363:6: warning: misleading indentation;
> statement is not part of the previous 'if' [-Wmisleading-indentation]
>          */     mutex_lock(&dev->struct_mutex);
>                 ^
> drivers/gpu/drm/drm_lock.c:357:2: note: previous statement is here
>         if (!drm_core_check_feature(dev, DRIVER_LEGACY))
>         ^
> 1 warning generated.
> 
> Build link:
>  - https://builds.tuxbuild.com/2EfrNYbejRQczhhqndawRkHARHZ/
> 
> 
> Steps to reproduce:
> -------------------
> # To install tuxmake on your system globally:
> # sudo pip3 install -U tuxmake
> #
> 
> tuxmake --runtime podman --target-arch arm64 --toolchain clang-nightly
> --kconfig defconfig LLVM=1 LLVM_IAS=1
> 
> Following patch might be the reason for these build errors:
> ---
> cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock
> [ Upstream commit 4f7e7236435ca0abe005c674ebd6892c6e83aeb3 ]
> 
> Bringing up a CPU may involve creating and destroying tasks which requires
> read-locking threadgroup_rwsem, so threadgroup_rwsem nests inside
> cpus_read_lock(). However, cpuset's ->attach(), which may be called with
> thredagroup_rwsem write-locked, also wants to disable CPU hotplug and
> acquires cpus_read_lock(), leading to a deadlock.
> 
> Fix it by guaranteeing that ->attach() is always called with CPU hotplug
> disabled and removing cpus_read_lock() call from cpuset_attach().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-and-tested-by: Imran Khan <imran.f.khan@oracle.com>
> Reported-and-tested-by: Xuewen Yan <xuewen.yan@unisoc.com>
> Fixes: 05c7b7a92cc8 ("cgroup/cpuset: Fix a race between
> cpuset_attach() and cpu hotplug")
> Cc: stable@vger.kernel.org # v5.17+
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Thanks, I've added an #include that should resolve this now.

greg k-h
