Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096065463B7
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 12:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348313AbiFJKbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 06:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348338AbiFJKam (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 06:30:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D893541F8D
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 03:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AB4FB83404
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 10:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E47C34114;
        Fri, 10 Jun 2022 10:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654857038;
        bh=HomKEPM17tMZ7u3VPSPWhPx1TPmD9+N1ylD/vNId9V8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rBM1No9yfHqXbW6wEShIwQ2IYiGlTs3/9nJAQA9RM/wvdw5LfJqJk0S3X2k9cT0MF
         fvNa76WwMtrgAKfte1RNOjbhip4pIRUbWfIQnjEi4FYqBUTdNK7aJ5hQ25PTFbxJmK
         YFouMv+23kEEZwDtMR4bmKimsFF676H5UHyXRhew=
Date:   Fri, 10 Jun 2022 12:30:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Natalsson <harmoniesworlds@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: echo mem > /sys/power/state write error "Device or resource
 busy" on Amlogic A311D device
Message-ID: <YqMdS+3qpYHfWN9f@kroah.com>
References: <CADs9LoMEF86Fp2-0ji7d9CNA5F=8ArwPWnj09h_Cwo6poNsWVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADs9LoMEF86Fp2-0ji7d9CNA5F=8ArwPWnj09h_Cwo6poNsWVA@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 01:18:56PM +0300, Alex Natalsson wrote:
> Hello friends.
> Suspend to RAM on Amlogic A311D chip (Khadas VIM3 SBC) was broken with
> 5.17.13 and with 5.18.2 it also presents.
> 
> When I trying do this I recieve error message:
> VIM3 ~ # LANG=C echo mem > /sys/power/state
> [  952.824117] PM: suspend entry (deep)
> [  952.828333] Filesystems sync: 0.003 seconds
> [  952.829473] Freezing user space processes ...
> [  972.833509] Freezing of tasks failed after 20.003 seconds (1 tasks
> refusing to freeze, wq_busy=0):
> [  972.841178] task:mplayer         state:D stack:    0 pid:  779
> ppid:   736 flags:0x00000205
> [  972.849457] Call trace:
> [  972.851868]  __switch_to+0xf8/0x150
> [  972.855315]  __schedule+0x1f8/0x570
> [  972.858758]  schedule+0x48/0xc0
> [  972.861856]  schedule_preempt_disabled+0x10/0x20
> [  972.866417]  __mutex_lock.constprop.0+0x158/0x590
> [  972.871071]  __mutex_lock_slowpath+0x14/0x20
> [  972.875296]  mutex_lock+0x5c/0x70
> [  972.878573]  dpcm_fe_dai_open+0x44/0x194
> [  972.882456]  snd_pcm_open_substream+0xa4/0x174
> [  972.886857]  snd_pcm_open.part.0+0xd8/0x1dc
> [  972.890994]  snd_pcm_playback_open+0x64/0x94
> [  972.895223]  snd_open+0xac/0x1d0
> [  972.898411]  chrdev_open+0xdc/0x2c4
> [  972.901861]  do_dentry_open+0x12c/0x380
> [  972.905652]  vfs_open+0x30/0x3c
> [  972.908758]  do_open+0x1e4/0x3a0
> [  972.911948]  path_openat+0x10c/0x280
> [  972.915486]  do_filp_open+0x80/0x130
> [  972.919019]  do_sys_openat2+0xb4/0x170
> [  972.922731]  __arm64_sys_openat+0x64/0xb0
> [  972.926700]  invoke_syscall+0x48/0x114
> [  972.930421]  el0_svc_common.constprop.0+0xd4/0xfc
> [  972.935070]  do_el0_svc+0x28/0x90
> [  972.938347]  el0_svc+0x34/0xb0
> [  972.941367]  el0t_64_sync_handler+0xa4/0x130
> [  972.945595]  el0t_64_sync+0x18c/0x190
> 
> [  972.950674] OOM killer enabled.
> [  972.953781] Restarting tasks ... done.
> -bash: echo: write error: Device or resource busy
> VIM3 ~ :( #
> 
> With 5.16.2 kernel version suspend to RAM is working, but system very
> slow after resume.
> 

Can you use 'git bisect' to track down the offending commit?

And does 5.19-rc1 also have this issue?

thanks,

greg k-h
