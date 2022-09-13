Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91CD5B6EB6
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 15:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbiIMN7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 09:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiIMN7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 09:59:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614DA52808
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 06:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2A9B61491
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 13:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B994C433C1;
        Tue, 13 Sep 2022 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663077561;
        bh=LAbj1gXndhpnVop335Nf9NDILxxUKgtF5mTZ5Xnnz2U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XV4xHPj/umiF9mpKQd+LC53xCW8YrGDwojz5r2hVheQZc9iHttT5mzZYJA+rm15H1
         aIS43BcFIkYrsu+Ul6giS4utd8JXt4pdrJTU5sWdf/DnWyw5KeEA9XnA/sPpgFnJdF
         tbIXbeOHaRWZGvkAE3/JV53uEBJwzQU63fVjuDmmuJ7ELQC6g4ojBa+sSQrsB/z+kh
         69VEbqPiWCoHLRIgwk7V7GxT3+rNucrZvcjNnI4a4qZOQdhlLLjXz5DAj5yU1nDyYI
         VFdoo3Czu5LZZU0jXTzTu+NAKn6PZFP9f0VeTDMwRGrpvmSF7y0ATkaeov0vWGRRux
         OKYbXa75ldecQ==
Date:   Tue, 13 Sep 2022 09:59:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        Imran Khan <imran.f.khan@oracle.com>,
        Xuewen Yan <xuewen.yan@unisoc.com>
Subject: Re: stable-rc: 5.4: cgroup.c:2404:2: error: implicit declaration of
 function 'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
Message-ID: <YyCMtuuft3Uc4ka7@sashalap>
References: <CA+G9fYtro2f2u3Wug7YS7kC=iVGWsee+Vnvm4U20+xXsYVjK5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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
>On stable-rc 5.4 arm and arm64 builds failed due to following errors / warnings.
>
>kernel/cgroup/cgroup.c:2404:2: error: implicit declaration of function
>'cpus_read_lock' [-Werror,-Wimplicit-function-declaration]
>        cpus_read_lock();
>        ^
>kernel/cgroup/cgroup.c:2404:2: note: did you mean 'cpuset_read_lock'?
>include/linux/cpuset.h:58:13: note: 'cpuset_read_lock' declared here
>extern void cpuset_read_lock(void);
>            ^
>kernel/cgroup/cgroup.c:2417:2: error: implicit declaration of function
>'cpus_read_unlock' [-Werror,-Wimplicit-function-declaration]
>        cpus_read_unlock();
>        ^
>kernel/cgroup/cgroup.c:2417:2: note: did you mean 'cpuset_read_unlock'?
>include/linux/cpuset.h:59:13: note: 'cpuset_read_unlock' declared here
>extern void cpuset_read_unlock(void);
>            ^
>2 errors generated.
>
>drivers/gpu/drm/drm_lock.c:363:6: warning: misleading indentation;
>statement is not part of the previous 'if' [-Wmisleading-indentation]
>         */     mutex_lock(&dev->struct_mutex);
>                ^
>drivers/gpu/drm/drm_lock.c:357:2: note: previous statement is here
>        if (!drm_core_check_feature(dev, DRIVER_LEGACY))
>        ^
>1 warning generated.
>
>Build link:
> - https://builds.tuxbuild.com/2EfrNYbejRQczhhqndawRkHARHZ/
>
>
>Steps to reproduce:
>-------------------
># To install tuxmake on your system globally:
># sudo pip3 install -U tuxmake
>#
>
>tuxmake --runtime podman --target-arch arm64 --toolchain clang-nightly
>--kconfig defconfig LLVM=1 LLVM_IAS=1

Hm, I can't reproduce this one, (and can't install tuxmake on the work
machine). What's the actual config that you end up using here?

-- 
Thanks,
Sasha
