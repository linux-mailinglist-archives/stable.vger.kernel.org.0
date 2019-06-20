Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EC04D458
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 18:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfFTQ4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 12:56:23 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42284 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFTQ4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 12:56:23 -0400
Received: by mail-pg1-f196.google.com with SMTP id l19so1875904pgh.9
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 09:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uKRfqkiqfgxECym12/lOXgeduS6BOjwl7vg+X1/wh6A=;
        b=ml/9wVc84i9WtzxYB2+RlzSyfT3qzzF9Ef386U2L8q9Cc+O7EuV7Ueo3ija7j8Mh+S
         iX7lEMT1zoAMaaHDN0x8sjN5MBBPMkXVTgkbU4M0P2JgP1a6mv8I5FymibzQbCKenA15
         1oSK0E4e1++84/i6rXnKJvaJwTi6uPhQ3qhIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uKRfqkiqfgxECym12/lOXgeduS6BOjwl7vg+X1/wh6A=;
        b=FVxb8KTbXYwqbf180IlrOKKVYT3/iuolJwi0f+zhXX0NorPf1FO8+VFLZESimds39y
         4z3Uum71iqAYM4bGpog6jfmM4PZKvEjndDCqqdjyPZB6adUkuoCmYmp1KAksqNefbYKZ
         UN0J43npGb0Q4BR7HN7zGf1kKELW1iZIm78vB6LmXLWhcydFRJdmCs3HeKcQm5hVjp4a
         qZjQvZv+x8wvaRNPnUJ8WS2+/zQZVgp7Kdw3sZLqdiO8kTsdWcyKDD9W/MwwQWCK7m8f
         Xt+K4dhFsm7VY1n7TwO4QIGBkz4V7gWV+BnFLPrGSy122bOjY155Nm/BqHCuSFLhIrsw
         6cHQ==
X-Gm-Message-State: APjAAAWZSyKPVV0kqYk0cbngPlnHTn6KsUonWOYfQcyij70Y+bTt9ei0
        NMt5b11yXT3GoWVJQ846OhPK5g==
X-Google-Smtp-Source: APXvYqzcvHRG13YK5agaLcAZDY/Plsk7JOoootOQADIRe8WH3f+SmUtwoniEJXXkVKvxL8hWj8fjrg==
X-Received: by 2002:a62:2f04:: with SMTP id v4mr15261073pfv.14.1561049783011;
        Thu, 20 Jun 2019 09:56:23 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id a6sm34326pfa.51.2019.06.20.09.56.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 09:56:22 -0700 (PDT)
Date:   Thu, 20 Jun 2019 09:56:19 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        alexander.lochmann@tu-dortmund.de, viro@zeniv.linux.org.uk
Subject: Re: f69e749a4935 ("Abort file_remove_privs() for non-reg. files")
Message-ID: <20190620165618.GA75359@google.com>
References: <20190620163048.GA189243@google.com>
 <20190620164428.GA8610@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620164428.GA8610@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 06:44:28PM +0200, Greg KH wrote:
> On Thu, Jun 20, 2019 at 09:30:49AM -0700, Zubin Mithra wrote:
> > Hello,
> > 
> > Syzkaller has triggered a kernel WARNING when fuzzing a 4.14 kernel with the following stacktrace.
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:17 [inline]
> >  dump_stack+0x114/0x1cf lib/dump_stack.c:53
> >  panic+0x1bb/0x3a0 kernel/panic.c:181
> >  __warn.cold.9+0x149/0x186 kernel/panic.c:542
> >  report_bug+0x1f7/0x272 lib/bug.c:186
> >  fixup_bug arch/x86/kernel/traps.c:177 [inline]
> >  do_error_trap+0x1c1/0x430 arch/x86/kernel/traps.c:295
> >  do_invalid_op+0x20/0x30 arch/x86/kernel/traps.c:314
> >  invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:944
> >  __remove_privs fs/inode.c:1805 [inline]
> >  file_remove_privs+0x291/0x4c0 fs/inode.c:1827
> >  __generic_file_write_iter+0x166/0x5b0 mm/filemap.c:3096
> >  blkdev_write_iter+0x1f5/0x3b0 fs/block_dev.c:1905
> >  call_write_iter include/linux/fs.h:1782 [inline]
> >  new_sync_write fs/read_write.c:471 [inline]
> >  __vfs_write+0x53f/0x7d0 fs/read_write.c:484
> >  vfs_write+0x18c/0x500 fs/read_write.c:546
> >  SYSC_write fs/read_write.c:593 [inline]
> >  SyS_write+0xf4/0x230 fs/read_write.c:585
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:340 [inline]
> >  do_fast_syscall_32+0x3c1/0xbf1 arch/x86/entry/common.c:403
> >  entry_SYSENTER_compat+0x84/0x96 arch/x86/entry/entry_64_compat.S:139
> > 
> > 
> > Could the following patch be applied to 5.0.y, 4.19.y, 4.14.y? The commit is present in 5.1.y.
> > * f69e749a4935 ("Abort file_remove_privs() for non-reg. files")
> 
> 5.0 is long end-of-life, but 4.19.y and 4.14.y is good.  What about
> older kernels?  it seems to be applicable there too, right?

Yes, 4.9.y and 4.4.y as well.


Thanks,
- Zubin

> 
> thanks,
> 
> greg k-h
