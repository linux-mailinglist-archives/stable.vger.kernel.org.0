Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870DF69B2C4
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 19:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjBQS7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 13:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjBQS7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 13:59:02 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1FB5FC66
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 10:59:00 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id fn4so1357353qvb.12
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 10:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1676660339;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=120DZvQoUAyoMne1gLDdZW6VztRdluB/SNtOtp0dBXE=;
        b=HWHnbkjRQnNSEIxrvSuNgw015iDG0UYGSMRYvdvlCFyUG7IA88QJ/cgIw/BJiQkuqH
         SGBe/v9bzJ6x2dT13OGpv+bdX+oBZmtOWpzXvX0q3u/BfSOA8hNmPCw6EFJzppSBUhWh
         583c+E/4UWXb9hHPC9vI/qkWrNYmafdPHp+OWYXj6eQIVU3LdUF5I/VKMGMdHoH7rre6
         lBRNnsBDgBT7yJe2fBicS9PhitY1TBVqVywKHO5vvkm80sl6X0lQMrlE/o7yV+l0PSkp
         uHnaX0z9g1cVbP2Mh+pgohKxIiy7kaMlj75mfv5DgeiOpcUI3kbjbv55A9a/2z5pqjIu
         D8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676660339;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=120DZvQoUAyoMne1gLDdZW6VztRdluB/SNtOtp0dBXE=;
        b=QkKgeggpQWpp1aH4iOr1cMvcYgMxSaLLzJ1T4NaZOqEzSG9wR2YHtwzaqIhkMRevNs
         wywHRLhH5I1n3M2qJVZvsnHRIQm1s16O+2ZKPZaFYeibCLmueqcQULE6ClfoTV4cYdKK
         K67HBOl6PPkR0iFIQbyVBH1CFaEfstr3mzbQbQOCxy4mjQZ/zSmidB9EXL3rSbnBK6Kn
         NKdKxIy4IsukSmyFrBlO9SZJHA41vkXsBvQJuvMKCURN76ijpWG6mPbjvNVpgWZei1PQ
         d6w5Gw1jdOqb9HBDm2Y2d4lrxCuuFdG9/QNX5bZTtt3QAuMZESCHcHAzzY2dwPWH4P5v
         AJhw==
X-Gm-Message-State: AO0yUKXIIAXk1Zbk8Of07oHiYY2SJBHVlEWl6cRPsPctj5RzYsj1ziZJ
        fDqE+PHXlF0Ntd7aQYBKglaBlu1HZO1o1Fvds3JbdBBBta09BQ8V
X-Google-Smtp-Source: AK7set9sQXjvibYlOfpGG1s6aZBjsxvI/qhbl8oed0I1rQzHNLQ/EEclbb0BeC8mX0HIUmptFecbhFBs1chcqz59q4E=
X-Received: by 2002:a0c:e006:0:b0:570:7e91:3927 with SMTP id
 j6-20020a0ce006000000b005707e913927mr389684qvk.76.1676660338988; Fri, 17 Feb
 2023 10:58:58 -0800 (PST)
MIME-Version: 1.0
References: <167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com>
From:   Pasha Tatashin <pasha.tatashin@soleen.com>
Date:   Fri, 17 Feb 2023 13:58:23 -0500
Message-ID: <CA+CK2bD=Vp7UoYyrtNs3sLvdCZ_nTps0FQYV6MOp-Fni0MAtKg@mail.gmail.com>
Subject: Re: [PATCH] dax/kmem: Fix leak of memory-hotplug resources
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, stable@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 16, 2023 at 3:36 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> While experimenting with CXL region removal the following corruption of
> /proc/iomem appeared.
>
> Before:
> f010000000-f04fffffff : CXL Window 0
>   f010000000-f02fffffff : region4
>     f010000000-f02fffffff : dax4.0
>       f010000000-f02fffffff : System RAM (kmem)
>
> After (modprobe -r cxl_test):
> f010000000-f02fffffff : **redacted binary garbage**
>   f010000000-f02fffffff : System RAM (kmem)
>
> ...and testing further the same is visible with persistent memory
> assigned to kmem:
>
> Before:
> 480000000-243fffffff : Persistent Memory
>   480000000-57e1fffff : namespace3.0
>   580000000-243fffffff : dax3.0
>     580000000-243fffffff : System RAM (kmem)
>
> After (ndctl disable-region all):
> 480000000-243fffffff : Persistent Memory
>   580000000-243fffffff : ***redacted binary garbage***
>     580000000-243fffffff : System RAM (kmem)
>
> The corrupted data is from a use-after-free of the "dax4.0" and "dax3.0"
> resources, and it also shows that the "System RAM (kmem)" resource is
> not being removed. The bug does not appear after "modprobe -r kmem", it
> requires the parent of "dax4.0" and "dax3.0" to be removed which
> re-parents the leaked "System RAM (kmem)" instances. Those in turn
> reference the freed resource as a parent.
>
> First up for the fix is release_mem_region_adjustable() needs to
> reliably delete the resource inserted by add_memory_driver_managed().
> That is thwarted by a check for IORESOURCE_SYSRAM that predates the
> dax/kmem driver, from commit:
>
> 65c78784135f ("kernel, resource: check for IORESOURCE_SYSRAM in release_mem_region_adjustable")
>
> That appears to be working around the behavior of HMM's
> "MEMORY_DEVICE_PUBLIC" facility that has since been deleted. With that
> check removed the "System RAM (kmem)" resource gets removed, but
> corruption still occurs occasionally because the "dax" resource is not
> reliably removed.
>
> The dax range information is freed before the device is unregistered, so
> the driver can not reliably recall (another use after free) what it is
> meant to release. Lastly if that use after free got lucky, the driver
> was covering up the leak of "System RAM (kmem)" due to its use of
> release_resource() which detaches, but does not free, child resources.
> The switch to remove_resource() forces remove_memory() to be responsible
> for the deletion of the resource added by add_memory_driver_managed().
>
> Fixes: c2f3011ee697 ("device-dax: add an allocation interface for device-dax instances")
> Cc: <stable@vger.kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Thanks,
Pasha
