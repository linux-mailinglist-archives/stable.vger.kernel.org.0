Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42994696F1E
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbjBNVSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbjBNVSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:18:33 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4862068B;
        Tue, 14 Feb 2023 13:18:29 -0800 (PST)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PGYq41C2vz6J7QQ;
        Wed, 15 Feb 2023 05:13:52 +0800 (CST)
Received: from localhost (10.81.204.253) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Tue, 14 Feb
 2023 21:18:26 +0000
Date:   Tue, 14 Feb 2023 21:18:24 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Gregory Price <gregory.price@memverge.com>
CC:     Dan Williams <dan.j.williams@intel.com>,
        <linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, <stable@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Michal Hocko" <mhocko@suse.com>, <linux-mm@kvack.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <20230214211824.00007f91@Huawei.com>
In-Reply-To: <Y+vag3hg3VRNRUti@memverge.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
        <Y+vSj8FD6ZaHhfoN@memverge.com>
        <63ebd56e639e9_32d61294f4@dwillia2-xfh.jf.intel.com.notmuch>
        <Y+vag3hg3VRNRUti@memverge.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.81.204.253]
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
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

On Tue, 14 Feb 2023 14:01:23 -0500
Gregory Price <gregory.price@memverge.com> wrote:

> On Tue, Feb 14, 2023 at 10:39:42AM -0800, Dan Williams wrote:
> > Gregory Price wrote:  
> > > On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:  
> > > > Summary:
> > > > --------
> > > > 
> > > > CXL RAM support allows for the dynamic provisioning of new CXL RAM
> > > > regions, and more routinely, assembling a region from an existing
> > > > configuration established by platform-firmware. The latter is motivated
> > > > by CXL memory RAS (Reliability, Availability and Serviceability)
> > > > support, that requires associating device events with System Physical
> > > > Address ranges and vice versa.
> > > >   
> > > 
> > > Ok, I simplified down my tests and reverted a bunch of stuff, figured i
> > > should report this before I dive further in.
> > > 
> > > Earlier i was carrying the DOE patches and others, I've dropped most of
> > > that to make sure i could replicate on the base kernel and qemu images
> > > 
> > > QEMU branch: 
> > > https://gitlab.com/jic23/qemu/-/tree/cxl-2023-01-26
> > > this is a little out of date at this point i think? but it shouldn't
> > > matter, the results are the same regardless of what else i pull in.
> > > 
> > > Kernel branch:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-6.3/cxl-ram-region  
> > 
> > Note that I acted on this feedback from Greg to break out a fix and
> > merge it for v6.2-final
> > 
> > http://lore.kernel.org/r/Y+CSOeHVLKudN0A6@kroah.com
> > 
> > ...i.e. you are missing at least the passthrough decoder fix, but that
> > would show up as a region creation failure not a QEMU crash.
> > 
> > So I would move to testing cxl/next.
> >   
> 
> I just noticed this, already spinning a new kernel.  Will report back
> 
> > Not ruling out the driver yet, but Fan's tests with hardware has me
> > leaning more towards QEMU.  
> 
> Same, not much has changed and I haven't tested with hardware yet. Was
> planning to install it on our local boxes sometime later this week.
> 
> Was just so close to setting up a virtual memory pool in the lab, was
> getting antsy :]

Could you test it with TCG (just drop --enable-kvm)?  We have a known
limitation with x86 instructions running out of CXL emulated memory
(side effect of emulating the interleave).  You'll need a fix even on TCG
for the corner case of an instruction bridging from normal ram to cxl memory.
https://lore.kernel.org/qemu-devel/20230206193809.1153124-1-richard.henderson@linaro.org/

Performance will be bad, but so far this is only way we can do it correctly.

Jonathan

