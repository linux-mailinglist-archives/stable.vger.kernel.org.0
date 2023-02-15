Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3964969797E
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 11:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbjBOKDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 05:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbjBOKDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 05:03:45 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79BD3757B;
        Wed, 15 Feb 2023 02:03:31 -0800 (PST)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PGtp0322Dz6J67P;
        Wed, 15 Feb 2023 17:59:04 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 15 Feb
 2023 10:03:28 +0000
Date:   Wed, 15 Feb 2023 10:03:27 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Gregory Price <gregory.price@memverge.com>
CC:     Dan Williams <dan.j.williams@intel.com>,
        <linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>, <qemu-devel@nongnu.org>
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <20230215100327.0000728f@Huawei.com>
In-Reply-To: <Y+wC+rPRbAc9rudx@memverge.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
        <Y+vSj8FD6ZaHhfoN@memverge.com>
        <63ebd56e639e9_32d61294f4@dwillia2-xfh.jf.intel.com.notmuch>
        <Y+vag3hg3VRNRUti@memverge.com>
        <20230214211824.00007f91@Huawei.com>
        <Y+wCeSig++c3ACkj@memverge.com>
        <Y+wC+rPRbAc9rudx@memverge.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Feb 2023 16:54:02 -0500
Gregory Price <gregory.price@memverge.com> wrote:

> On Tue, Feb 14, 2023 at 04:51:53PM -0500, Gregory Price wrote:
> > On Tue, Feb 14, 2023 at 09:18:24PM +0000, Jonathan Cameron wrote:  
> > > On Tue, 14 Feb 2023 14:01:23 -0500
> > > Gregory Price <gregory.price@memverge.com> wrote:
> > > 
> > > Could you test it with TCG (just drop --enable-kvm)?  We have a known
> > > limitation with x86 instructions running out of CXL emulated memory
> > > (side effect of emulating the interleave).  You'll need a fix even on TCG
> > > for the corner case of an instruction bridging from normal ram to cxl memory.
> > > https://lore.kernel.org/qemu-devel/20230206193809.1153124-1-richard.henderson@linaro.org/
> > > 
> > > Performance will be bad, but so far this is only way we can do it correctly.
> > > 
> > > Jonathan
> > >   
> > 
> > Siiiggghh... i had this patch and dropped --enable-kvm, but forgot to
> > drop "accel=kvm" from the -machine line
> > 
> > This was the issue.
> > 
> > And let me tell you, if you numactl --membind=1 python, it is
> > IMPRESSIVELY slow.  I wonder if it's even hitting a few 100k
> > instructions a second.
> > 
> > 
> > This appears to be the issue.  When I get a bit more time, try to dive
> > into the deep dark depths of qemu memory regions to see how difficult
> > a non-mmio fork might be, unless someone else is already looking at it.
> > 
> > ~Gregory  
> 
> Just clarifying one thing:  Even with the patch, KVM blows up.
> Disabling KVM fixes this entirely.  I haven't tested without KVM but
> with the patch, i will do that now.

yup.  The patch only fixes TCG so that's expected behavior.

Fingers crossed on this 'working'.

I'm open to suggestions on how to work around the problem with KVM
or indeed allow TCG to cache the instructions (right not it has
to fetch and emulate each instruction on it's own).

I can envision how we might do it for KVM with userspace page fault handling
used to get a fault up to QEMU which can then stitch in a cache
of the underlying memory as a stage 2 translation to the page (a little
bit like how post migration copy works) though I've not prototyped
anything...

I think it would be complex code that would be little used
so we may just have to cope with the emulation being slow.

Intent is very much to be able to test the kernel code etc, not
test it quickly :)

Jonathan
