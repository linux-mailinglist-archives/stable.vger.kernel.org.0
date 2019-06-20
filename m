Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E44D3C7
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfFTQaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 12:30:22 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45292 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 12:30:22 -0400
Received: by mail-ot1-f68.google.com with SMTP id x21so3279598otq.12
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 09:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DApYrgtFGUX8hglw1AcOz6adgUtgKXSMo50u9kqGqWo=;
        b=IbYvmcN3FD1XsFJRWLBVeAh4cj+ztsE2rAJY2j9X45js8FuU/UPlkV5Z4mXnvi7Y7S
         A1GJpNUvJJbYn4ayjrn7/ANF+NiX7qKfqVlzDYpeflENEtIxLPu+qyys3bQLnsGfTQ1q
         nP6mTojxuOtLIWObuYkjJyA/1wtWC7fvvWuTmmiY8UwiqIT0/aeMmX6iPRbPwOg5iGPr
         uvfM5n2Dc7iiy1RvSAtGN0+PsX0kiVynUGI3ramtVIYzCGNtSNnR70SGPuHH87OdZOvD
         shvfqPmJ4PpbxFg34W9zwV3aCJNPq3GMuGB4dV59hH1kuK1Ja8KmFwrH/fL/dTGr3744
         /wLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DApYrgtFGUX8hglw1AcOz6adgUtgKXSMo50u9kqGqWo=;
        b=WEJoxv7CszsCl7ryoMUiHBUERTQYi4gWardI2lG2P5bT3g8E4nTbunorqup/Q7QYw9
         T5axGe6xprM9bvwcpS0RYtQAhzojyC+Mz/KtVLz+3oiQUReJfRMee5Wva9/g6HW51Is2
         N5qrNsJqm9jsbyopZaYlkTo/WmwuiyXflQdWA7IqBhBGDjLE5LgubRDp9a9Dx93VLXsM
         7euzG2LfE29fQDMO+jCEmKy58w3xkOEqh987zFtLYeDZo7gqdCVS7VPJ0UlUP4KcpHTH
         5vmWWmFNPq8a6z9/mEvTibgRp0Con0E11A+bSXkf5XB1uiEV5u0ALhuKL1+N48SgVPAm
         pZ/Q==
X-Gm-Message-State: APjAAAVO6tXTyXZgIn/GztSPh+I434peZmsO+TLLxX3rudRR3izaRx+9
        FUxqPXabQFddOFq4u4HMj9I98mlgQJUuN0J1qazQGw==
X-Google-Smtp-Source: APXvYqxIllarlavyR5g1oQ37eeWGGe9Qov4pSV/b7aFTtPwH8mY5U/JzeG/yRiJUeWSkE5MXZLJELq2eNsiljKeKmTU=
X-Received: by 2002:a9d:7b48:: with SMTP id f8mr14032030oto.207.1561048221363;
 Thu, 20 Jun 2019 09:30:21 -0700 (PDT)
MIME-Version: 1.0
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
 <874l4kjv6o.fsf@linux.ibm.com>
In-Reply-To: <874l4kjv6o.fsf@linux.ibm.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 20 Jun 2019 09:30:10 -0700
Message-ID: <CAPcyv4ioWRhU9AbyTHhf9PavL0GSs=6h3dGyaQPb7vLJ2+z23g@mail.gmail.com>
Subject: Re: [PATCH v10 00/13] mm: Sub-section memory hotplug support
To:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Jane Chu <jane.chu@oracle.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Jonathan Corbet <corbet@lwn.net>, Qian Cai <cai@lca.pw>,
        Logan Gunthorpe <logang@deltatee.com>,
        Toshi Kani <toshi.kani@hpe.com>,
        Oscar Salvador <osalvador@suse.de>,
        Jeff Moyer <jmoyer@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        stable <stable@vger.kernel.org>,
        Wei Yang <richardw.yang@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 20, 2019 at 5:31 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > Changes since v9 [1]:
> > - Fix multiple issues related to the fact that pfn_valid() has
> >   traditionally returned true for any pfn in an 'early' (onlined at
> >   boot) section regardless of whether that pfn represented 'System RAM'.
> >   Teach pfn_valid() to maintain its traditional behavior in the presence
> >   of subsections. Specifically, subsection precision for pfn_valid() is
> >   only considered for non-early / hot-plugged sections. (Qian)
> >
> > - Related to the first item introduce a SECTION_IS_EARLY
> >   (->section_mem_map flag) to remove the existing hacks for determining
> >   an early section by looking at whether the usemap was allocated from the
> >   slab.
> >
> > - Kill off the EEXIST hackery in __add_pages(). It breaks
> >   (arch_add_memory() false-positive) the detection of subsection
> >   collisions reported by section_activate(). It is also obviated by
> >   David's recent reworks to move the 'System RAM' request_region() earlier
> >   in the add_memory() sequence().
> >
> > - Switch to an arch-independent / static subsection-size of 2MB.
> >   Otherwise, a per-arch subsection-size is a roadblock on the path to
> >   persistent memory namespace compatibility across archs. (Jeff)
> >
> > - Update the changelog for "libnvdimm/pfn: Fix fsdax-mode namespace
> >   info-block zero-fields" to clarify that the "Cc: stable" is only there
> >   as safety measure for a distro that decides to backport "libnvdimm/pfn:
> >   Stop padding pmem namespaces to section alignment", otherwise there is
> >   no known bug exposure in older kernels. (Andrew)
> >
> > - Drop some redundant subsection checks (Oscar)
> >
> > - Collect some reviewed-bys
> >
> > [1]: https://lore.kernel.org/lkml/155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com/
>
>
> You can add Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> for ppc64.

Thank you!

> BTW even after this series we have the kernel crash mentioned in the
> below email on reconfigure.
>
> https://lore.kernel.org/linux-mm/20190514025354.9108-1-aneesh.kumar@linux.ibm.com
>
> I guess we need to conclude how the reserve space struct page should be
> initialized ?

Yes, that issue is independent of the subsection changes. I'll take a
closer look.
