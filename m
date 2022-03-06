Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F294CEE00
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 22:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbiCFVvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 16:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiCFVvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 16:51:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8D75DE43
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 13:50:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CF72B80EF4
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 21:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0ADC340EC;
        Sun,  6 Mar 2022 21:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646603446;
        bh=g49ffDtK4hxUNKU4fIJ9rylWVGoV8qoH/LNmKOXASt4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oJ11QuJBMWrQGtF3q1XgODd0QC/vjwhSMTbh+Bp04Ek8Apd3//MhOiBDKDe5A0Ea0
         MahOdVfGKlXr7TPbNIIuJ3HN+sJbTr897gX3lUjFBvCXgB7CqHKnRCrVszkgApVN8q
         9Pn6wb6yiL4HsYCD1aR7QOa52f3CxyUF8L0sO0JJbEM/Y6LfNrXyIPb6yvH052EZgh
         dunQ9PZ2valLQtV9wKPnQMlufZEOoQnSh0gFPvEh0UbcpcEGkeTjYSThq3hmUQqRdZ
         x88nvz+AjshlPLG7zEZB5hdgBeukG0cCc9zhRJWU8RD7xYI2SebQi/adUcdlk5/ZIp
         QdMBRpzUYVkTg==
Date:   Sun, 6 Mar 2022 16:50:42 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     surenb@google.com, akpm@linux-foundation.org, brauner@kernel.org,
        caoxiaofeng@yulong.com, ccross@google.com, chris.hyser@oracle.com,
        dave.hansen@intel.com, dave@stgolabs.net, david@redhat.com,
        ebiederm@xmission.com, gorcunov@gmail.com, hannes@cmpxchg.org,
        keescook@chromium.org, kirill.shutemov@linux.intel.com,
        legion@kernel.org, mhocko@suse.com, pcc@google.com,
        sumit.semwal@linaro.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, willy@infradead.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm: prevent vm_area_struct::anon_name
 refcount saturation" failed to apply to 5.15-stable tree
Message-ID: <YiUssomamBu84L/v@sashalap>
References: <1646559441105125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1646559441105125@kroah.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 06, 2022 at 10:37:21AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.15-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 96403e11283def1d1c465c8279514c9a504d8630 Mon Sep 17 00:00:00 2001
>From: Suren Baghdasaryan <surenb@google.com>
>Date: Fri, 4 Mar 2022 20:28:55 -0800
>Subject: [PATCH] mm: prevent vm_area_struct::anon_name refcount saturation
>
>A deep process chain with many vmas could grow really high.  With
>default sysctl_max_map_count (64k) and default pid_max (32k) the max
>number of vmas in the system is 2147450880 and the refcounter has
>headroom of 1073774592 before it reaches REFCOUNT_SATURATED
>(3221225472).
>
>Therefore it's unlikely that an anonymous name refcounter will overflow
>with these defaults.  Currently the max for pid_max is PID_MAX_LIMIT
>(4194304) and for sysctl_max_map_count it's INT_MAX (2147483647).  In
>this configuration anon_vma_name refcount overflow becomes theoretically
>possible (that still require heavy sharing of that anon_vma_name between
>processes).
>
>kref refcounting interface used in anon_vma_name structure will detect a
>counter overflow when it reaches REFCOUNT_SATURATED value but will only
>generate a warning and freeze the ref counter.  This would lead to the
>refcounted object never being freed.  A determined attacker could leak
>memory like that but it would be rather expensive and inefficient way to
>do so.
>
>To ensure anon_vma_name refcount does not overflow, stop anon_vma_name
>sharing when the refcount reaches REFCOUNT_MAX (2147483647), which still
>leaves INT_MAX/2 (1073741823) values before the counter reaches
>REFCOUNT_SATURATED.  This should provide enough headroom for raising the
>refcounts temporarily.

I think that this patch depends on 78db3412833d ("mm: add anonymous vma
name refcounting") which we don't have in any of the stable trees. (is
this why it wasn't tagged for stable?).

-- 
Thanks,
Sasha
