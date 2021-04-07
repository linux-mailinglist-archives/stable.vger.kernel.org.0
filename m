Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BA1356D53
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 15:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244362AbhDGNbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 09:31:09 -0400
Received: from smtprelay0232.hostedemail.com ([216.40.44.232]:46780 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244346AbhDGNbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 09:31:07 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2021 09:31:07 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 442668123FE9
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 13:21:19 +0000 (UTC)
Received: from omf07.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 115EE182CCCAD;
        Wed,  7 Apr 2021 13:21:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id 78264315D7A;
        Wed,  7 Apr 2021 13:21:12 +0000 (UTC)
Message-ID: <cf36c95f3f92bd76f2d6c81c5795acefbe358f09.camel@perches.com>
Subject: Re: [QUESTION] WARNNING after 3d8e2128f26a ("sysfs: Add sysfs_emit
 and sysfs_emit_at to format sysfs output")
From:   Joe Perches <joe@perches.com>
To:     yangerkun <yangerkun@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, vbabka@suse.cz, linux-mm@kvack.org,
        open-iscsi@googlegroups.com, cleech@redhat.com,
        "zhangyi (F)" <yi.zhang@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        liuyongqiang13@huawei.com,
        "Zhengyejian (Zetta)" <zhengyejian1@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        chenzhou10@huawei.com
Date:   Wed, 07 Apr 2021 06:21:11 -0700
In-Reply-To: <08b739b5-4401-e550-2028-1ce43db38141@huawei.com>
References: <5837f5d9-2235-3ac2-f3f2-712e6cf4da5c@huawei.com>
         <YGbLiIL8ewIX1Hrt@kroah.com> <20210402144120.GO351017@casper.infradead.org>
         <08b739b5-4401-e550-2028-1ce43db38141@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.10
X-Stat-Signature: iur8j878jaxoipa5hsxfxp4zx6d6p8km
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 78264315D7A
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19tPg5BY8oiEk400kiihuFsLCQX8VKOJ1I=
X-HE-Tag: 1617801672-488380
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-04-07 at 20:14 +0800, yangerkun wrote:
> 
> 在 2021/4/2 22:41, Matthew Wilcox 写道:
> > On Fri, Apr 02, 2021 at 09:45:12AM +0200, Greg KH wrote:
> > > Why is the buffer alignment considered a "waste" here?  If that change
> > > is in Linus's tree and newer kernels (it showed up in 5.4 which was
> > > released quite a while ago), where are the people complaining about it
> > > there?
> > > 
> > > I think backporting 59bb47985c1d ("mm, sl[aou]b: guarantee natural
> > > alignment for kmalloc(power-of-two)") seems like the correct thing to do
> > > here to bring things into alignment (pun intended) with newer kernels.
> > 
> > It's only a waste for slabs which need things like redzones (eg we could
> > get 7 512-byte allocations out of a 4kB page with a 64 byte redzone
> > and no alignment ; with alignment we can only get four).  Since slub
> > can enable/disable redzones on a per-slab basis, and redzones aren't
> > terribly interesting now that we have kasan/kfence, nobody really cares.
> > 
> > .
> > 
> 
> Thanks for your explain! The imfluence seems minimal since the "waste" 
> will happen only when we enable slub_debug.
> 
> One more question for Joe Perches. Patch v2[1] does not add the
> alignment check for buf and we add it in v3[2]. I don't see the
> necessity for this check... Can you help to explain that why we need this?

It's to make sure it's a PAGE_SIZE aligned buffer.
It's just so it would not be misused/abused in non-sysfs derived cases.

