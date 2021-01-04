Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4633D2E910D
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 08:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbhADHa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 02:30:57 -0500
Received: from relay5.mymailcheap.com ([159.100.248.207]:43033 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbhADHa5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 02:30:57 -0500
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.154])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 487E2260EB;
        Mon,  4 Jan 2021 07:30:04 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id DD71C3F1CF;
        Mon,  4 Jan 2021 08:28:28 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id AC3792A7E5;
        Mon,  4 Jan 2021 08:28:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1609745308;
        bh=fjnZkoVTTU0sciv5VPvHtJlIseKPWNwKRM7jiM31Sc8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PNFE4Ao5pDhVlC5yauD2tXQalK4Jnqovb+520bEHreSQtImry2kDcQmv87B2pHING
         ut1noO6yhquJA6W5odOBVk1oUbxp4bzl/XdC7hM6Wrg51S8DBP2FL8hVXEw5gJ+B3t
         F76QyD2+riKGUIUniWqHQB8zUzMuJEvXmcawW5HU=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 248A5mayeMeK; Mon,  4 Jan 2021 08:28:27 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Mon,  4 Jan 2021 08:28:27 +0100 (CET)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id A9F4F41F21;
        Mon,  4 Jan 2021 07:28:25 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="hA4RwVr+";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from ICE-E5V2.lan (unknown [59.41.162.25])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 25C6041F21;
        Mon,  4 Jan 2021 07:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1609745299; bh=fjnZkoVTTU0sciv5VPvHtJlIseKPWNwKRM7jiM31Sc8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hA4RwVr+3RnYQfmb1U0QtTJJbQue5JHkytRUS8NkFeOBbK3yZYGF7J+iUm//UOBTA
         FJ9+p1w9rJAh00VwgbSwUBGbfLAvx+1OYqFYhMMlBiiDaWxmCpVYVU3Ceb235EDrcw
         FFtahrrANP94o83vM08EcDpxlmC+ceJaUed3j3fU=
Message-ID: <a77b2beb832d64f9f019c4505e91c7ffcbbfb61b.camel@aosc.io>
Subject: Re: [PATCH] ovl: use a dedicated semaphore for dir upperfile caching
From:   Icenowy Zheng <icenowy@aosc.io>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Date:   Mon, 04 Jan 2021 15:28:12 +0800
In-Reply-To: <CAOQ4uxgNWkzVphdB7cAkwdUXagM_NsCUYDRT1f-=X1rn1-KpUQ@mail.gmail.com>
References: <20210101201230.768653-1-icenowy@aosc.io>
         <CAOQ4uxgNWkzVphdB7cAkwdUXagM_NsCUYDRT1f-=X1rn1-KpUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.10 / 10.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         RECEIVED_SPAMHAUS_PBL(0.00)[59.41.162.25:received];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[aosc.io];
         R_SPF_SOFTFAIL(0.00)[~all];
         RCPT_COUNT_FIVE(0.00)[6];
         ML_SERVERS(-3.10)[213.133.102.83];
         TO_DN_ALL(0.00)[];
         DKIM_TRACE(0.00)[aosc.io:+];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1]
X-Rspamd-Queue-Id: A9F4F41F21
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

在 2021-01-03星期日的 16:10 +0200，Amir Goldstein写道：
> On Fri, Jan 1, 2021 at 10:12 PM Icenowy Zheng <icenowy@aosc.io>
> wrote:
> > 
> > The function ovl_dir_real_file() currently uses the semaphore of
> > the
> > inode to synchronize write to the upperfile cache field.
> > 
> > However, this function will get called by ovl_ioctl_set_flags(),
> > which
> > utilizes the inode semaphore too. In this case ovl_dir_real_file()
> > will
> > try to claim a lock that is owned by a function in its call stack,
> > which
> > won't get released before ovl_dir_real_file() returns.
> 
> oops. I wondered why I didn't see any warnings on this from lockdep.
> Ah! because the xfstest that exercises ovl_ioctl_set_flags() on
> directory,
> generic/079, starts with an already upper dir.
> 
> And the xfstest that checks chattr+i on lower/upper files,
> overlay/040,
> does not check chattr on dirs (ioctl on overlay dirs wasn't supported
> at
> the time the test was written).
> 
> Would you be able to create a variant of test overlay/040 that also
> tests
> chattr +i on lower/upper dirs to test your patch and confirm that the
> test
> fails on master with the appropriate Kconfig debug options.

https://gist.github.com/Icenowy/c7d8decb6812d6e5064d143c57281ad3

Here's a test that would break on master (I used linux-next/master for
test).

[  246.521880] INFO: task chattr:715 blocked for more than 122 seconds.
[  246.525659]       Not tainted 5.11.0-rc1-next-20210104+ #20
[  246.528498] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  246.535076] task:chattr          state:D stack:13736 pid:  715 ppid:
529 flags:0x00000000
[  246.538923] Call Trace:
[  246.540241]  __schedule+0x2a9/0x820
[  246.541986]  schedule+0x56/0xc0
[  246.543616]  rwsem_down_write_slowpath+0x375/0x630
[  246.545565]  ovl_dir_real_file+0xc1/0x120
[  246.547512]  ovl_real_fdget+0x35/0x80
[  246.549303]  ovl_real_ioctl+0x26/0x90
[  246.551050]  ? mnt_drop_write+0x2c/0x70
[  246.553068]  ovl_ioctl_set_flags+0x93/0x110
[  246.555407]  __x64_sys_ioctl+0x7e/0xb0
[  246.557175]  do_syscall_64+0x33/0x40
[  246.558869]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  246.561057] RIP: 0033:0x7fe4a3830b67
[  246.565799] RSP: 002b:00007ffe7ad504f8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  246.569438] RAX: ffffffffffffffda RBX: 0000000000000001 RCX:
00007fe4a3830b67
[  246.572061] RDX: 00007ffe7ad5050c RSI: 0000000040086602 RDI:
0000000000000003
[  246.575509] RBP: 0000000000000003 R08: 0000000000000001 R09:
0000000000000000
[  246.578932] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000010
[  246.581014] R13: 00007ffe7ad50810 R14: 0000000000000002 R15:
0000000000000001
[  246.582818] 
[  246.582818] Showing all locks held in the system:
[  246.584741] 1 lock held by khungtaskd/18:
[  246.586085]  #0: ffffffff9e951540 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x15/0x100
[  246.589775] 3 locks held by chattr/715:
[  246.591364]  #0: ffff96a74b92c450 (sb_writers#11){....}-{0:0}, at:
ovl_ioctl_set_flags+0x2f/0x110
[  246.597182]  #1: ffff96a7489c3500
(&ovl_i_mutex_dir_key[depth]){....}-{3:3}, at:
ovl_ioctl_set_flags+0x54/0x110
[  246.601325]  #2: ffff96a7489c3500
(&ovl_i_mutex_dir_key[depth]){....}-{3:3}, at:
ovl_dir_real_file+0xc1/0x120

> 
> > 
> > Define a dedicated semaphore for the upperfile cache, so that the
> > deadlock won't happen.
> > 
> > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR
> > ioctls for directories")
> > Cc: stable@vger.kernel.org # v5.10
> > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > ---
> >  fs/overlayfs/readdir.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index 01620ebae1bd..f10701aabb71 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -56,6 +56,7 @@ struct ovl_dir_file {
> >         struct list_head *cursor;
> >         struct file *realfile;
> >         struct file *upperfile;
> > +       struct semaphore upperfile_sem;
> 
> mutex please
> 
> >  };
> > 
> >  static struct ovl_cache_entry *ovl_cache_entry_from_node(struct
> > rb_node *n)
> > @@ -883,7 +884,7 @@ struct file *ovl_dir_real_file(const struct
> > file *file, bool want_upper)
> >                         ovl_path_upper(dentry, &upperpath);
> >                         realfile = ovl_dir_open_realfile(file,
> > &upperpath);
> > 
> > -                       inode_lock(inode);
> > +                       down(&od->upperfile_sem);
> >                         if (!od->upperfile) {
> >                                 if (IS_ERR(realfile)) {
> >                                         inode_unlock(inode);
> 
> You missed this unlock

Thanks, will send v2 now.

> 
> Thanks,
> Amir.

