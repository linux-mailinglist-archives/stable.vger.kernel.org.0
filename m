Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56FE76219D1
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 17:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiKHQwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 11:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiKHQv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 11:51:57 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4701159856
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 08:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1667926317; x=1699462317;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sF2bCGrwrD//6ElRF5KBU9M8GZKMayt2fzTSvjNTBIA=;
  b=GVWeCyxWl0YlL7SAo0BTwBpCXmtwDs5QYZZxdyZJdMJKE/WzkezWoEbO
   0D7hVLIwU17DxYlzae0upXqwSjU9sgOFEXqoeCPp+PXxcgMQ5y+Zf9pO+
   z9mPy6ZkbEmDJczq0rviR4Ka4W7h+4R3x92E7VrJ0cOmerXZYZndtjdvN
   8=;
X-IronPort-AV: E=Sophos;i="5.96,148,1665446400"; 
   d="scan'208";a="148911755"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 16:51:53 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id 4DA1B41FC7;
        Tue,  8 Nov 2022 16:51:44 +0000 (UTC)
Received: from EX13D25UEA004.ant.amazon.com (10.43.61.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 8 Nov 2022 16:51:17 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D25UEA004.ant.amazon.com (10.43.61.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 8 Nov 2022 16:51:17 +0000
Received: from dev-dsk-luizcap-1d-af6a6fef.us-east-1.amazon.com
 (10.39.202.216) by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Tue, 8 Nov 2022 16:51:17 +0000
Received: by dev-dsk-luizcap-1d-af6a6fef.us-east-1.amazon.com (Postfix, from userid 23276196)
        id 9038F29BA; Tue,  8 Nov 2022 16:51:16 +0000 (UTC)
Date:   Tue, 8 Nov 2022 16:51:16 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <lcapitulino@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Shakeel Butt <shakeelb@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Andrei Vagin" <avagin@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Dmitry Safonov" <0x7f454c46@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Roman Gushchin <guro@fb.com>,
        Serge Hallyn <serge@hallyn.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Yutian Yang <nglaive@gmail.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.10, 5.4] memcg: enable accounting of ipc resources
Message-ID: <20221108165116.GA9011@dev-dsk-luizcap-1d-af6a6fef.us-east-1.amazon.com>
References: <20221104184131.17797-1-luizcap@amazon.com>
 <Y2jMXfbLTHwDBInx@kroah.com> <Y2pPhBL2g8fmqdql@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y2pPhBL2g8fmqdql@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 01:45:56PM +0100, Greg Kroah-Hartman wrote:

> 
> 
> On Mon, Nov 07, 2022 at 10:14:05AM +0100, Greg Kroah-Hartman wrote:
> > On Fri, Nov 04, 2022 at 06:41:31PM +0000, Luiz Capitulino wrote:
> > > From: Vasily Averin <vvs@virtuozzo.com>
> > >
> > > Commit 18319498fdd4cdf8c1c2c48cd432863b1f915d6f upstream.
> > >
> > > [ This backport fixes CVE-2021-3759 for 5.10 and 5.4. Please, note that
> > >   it caused conflicts in all files being changed because upstream
> > >   changed ipc object allocation to and from kvmalloc() & friends (eg.
> > >   commits bc8136a543aa and fc37a3b8b4388e). However, I decided to keep
> > >   this backport about the memcg accounting fix only. ]
> >
> > Looks good, now queued up, thanks.
> 
> Ah, but you missed a fix-up patch for this one {sigh}
> 
> I've now queued up 18319498fdd4 ("memcg: enable accounting of ipc
> resources") as well.  Please be more careful in the future when
> backporting changes that you also include the fixes for those changes.

Good catch, the fixup is actually 6a4746ba06191e23d30230738e94334b26590a8a

Will try to be more careful next time.

- Luiz

> 
> thanks,
> 
> greg k-h
