Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B331D0DCF
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 13:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730757AbfJILko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 07:40:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58708 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfJILko (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 07:40:44 -0400
Received: from [79.140.115.128] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iIAKg-0000Lg-97; Wed, 09 Oct 2019 11:40:42 +0000
Date:   Wed, 9 Oct 2019 13:40:41 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     parri.andrea@gmail.com
Cc:     bsingharora@gmail.com, dvyukov@google.com, elver@google.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] taskstats: fix data-race
Message-ID: <20191009114040.tqbbdxmkvvt6mia5@wittgenstein>
References: <20191008154418.GA16972@andrea>
 <20191009113134.5171-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191009113134.5171-1-christian.brauner@ubuntu.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 01:31:34PM +0200, Christian Brauner wrote:
> When assiging and testing taskstats in taskstats_exit() there's a race
> when writing and reading sig->stats when a thread-group with more than
> one thread exits:
> 
> cpu0:
> thread catches fatal signal and whole thread-group gets taken down
>  do_exit()
>  do_group_exit()
>  taskstats_exit()
>  taskstats_tgid_alloc()
> The tasks reads sig->stats without holding sighand lock seeing garbage.
> 
> cpu1:
> task calls exit_group()
>  do_exit()
>  do_group_exit()
>  taskstats_exit()
>  taskstats_tgid_alloc()
> The task takes sighand lock and assigns new stats to sig->stats.
> 
> Fix this by using smp_load_acquire() and smp_store_release().
> 
> Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
> Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>

_sigh_, let me resend since i fcked this one up.

Christian
