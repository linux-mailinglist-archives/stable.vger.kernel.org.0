Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4761382A9
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 18:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbgAKRlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 12:41:22 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39936 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730671AbgAKRlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 12:41:22 -0500
Received: by mail-oi1-f193.google.com with SMTP id c77so4741303oib.7
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 09:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vURIp5OkMqsQKj2rZ69zRSR7WBHOsnIzv1RRvafYQZM=;
        b=L43oGdX9yy3rjkRtJUhtCZQB4Ug6JBVXzhPixH+6vui6VO/Ph5ASarVzj6f0ouD3Hw
         Z3N/Cr4fuo8giPxd5Vft1O03XiJWWsay9nMuD7x11VQHXG7GJUY30+ge8qzjsMJDlREK
         9CyrU17imfstdfvQYFGggQaHDDXnmVRQnzokVsVNoGIz4JVMxoP2UFbBJfqYRrXB4Zgx
         BnBFq3b+gGMs7roxnEAPnobz9V5COXiNI/NUTr31zzq932Z6IOTxXNeObue4fuTDG1L9
         Yk1PsE2vBgmI4NaCQPMrYbeMKYSaeqqp2K3tWD0hXNitg+Iav6ky/GgmB9A/WtHc3ZYY
         mO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vURIp5OkMqsQKj2rZ69zRSR7WBHOsnIzv1RRvafYQZM=;
        b=Tbg966/CUBX2DKPN8jKdGLBzOYVD2IW3f7tnFAKtJ9yX7PIG17Hlhgc0LXEBekNYiv
         ZFzWgOOVHfW7khEq/D2nu+PPuNeHo0g11Fm74DIsv5Q61DNG6qK8zg1jZU7ITwonjS3x
         O/6JItU3e/XMPchsqQ5gJbIjGrn/Xw25GCfHDTpwFI7snRn0yfiUDHvwL19ZoqwynEkC
         WNauARxXGd3gjoe9AervjD4Q46ntoTQYJv+GgkH4Tq6WFGeIyeZFK5+R85Kmjlwb3qWj
         h0NC2KlFgIcWqLMNFNowtdXsVHhrQ1kcheMZhPM4nha1HaBdhyYqL9ZTOgb66V6xw9xJ
         z1eA==
X-Gm-Message-State: APjAAAX7s0bTb391qozBmYakKmCA4MRN15ESAD9pSVgHsms+Z+XWQHIA
        o94Tfn0ebNuPhiqukLIeKHirYzsCMt8WidzurqlcAw==
X-Google-Smtp-Source: APXvYqxb3f/o87RH8Y6Z3KBTkNfO5vS8R+FnqquMeXGfJpWajIZieMeyLLmHbOpdps5qdQaccRiPAw67mOFgSsnGt5Y=
X-Received: by 2002:a05:6808:b37:: with SMTP id t23mr7126364oij.149.1578764481384;
 Sat, 11 Jan 2020 09:41:21 -0800 (PST)
MIME-Version: 1.0
References: <0BE8F7EF-01DC-47BD-899B-11FB8B40EB0A@lca.pw> <A5A31713-0D55-487C-814A-1415BB26DC1F@redhat.com>
 <4fa0a559-dd5a-8405-0533-37cfe6973eeb@redhat.com>
In-Reply-To: <4fa0a559-dd5a-8405-0533-37cfe6973eeb@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Sat, 11 Jan 2020 09:41:10 -0800
Message-ID: <CAPcyv4hbGnTnAHg0yxoj41KUfFf8z4yH8nVmhhZ4Z7AoxNooHA@mail.gmail.com>
Subject: Re: [PATCH v4] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     David Hildenbrand <david@redhat.com>
Cc:     Qian Cai <cai@lca.pw>, Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 11, 2020 at 6:52 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 11.01.20 15:25, David Hildenbrand wrote:
> >
> >
> >> Am 11.01.2020 um 14:56 schrieb Qian Cai <cai@lca.pw>:
> >>
> >> =EF=BB=BF
> >>
> >>> On Jan 11, 2020, at 6:03 AM, David Hildenbrand <david@redhat.com> wro=
te:
> >>>
> >>> So I just remember why I think this (and the previously reported done
> >>> for ACPI DIMMs) are false positives. The actual locking order is
> >>>
> >>> onlining/offlining from user space:
> >>>
> >>> kn->count -> device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_l=
ock
> >>>
> >>> memory removal:
> >>>
> >>> device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_lock -> kn->co=
unt
> >>>
> >>>
> >>> This looks like a locking inversion - but it's not. Whenever we come =
via
> >>> user space we do a mutex_trylock(), which resolves this issue by back=
ing
> >>> up. The device_hotplug_lock will prevent
> >>>
> >>> I have no clue why the device_hotplug_lock does not pop up in the
> >>> lockdep report here. Sounds wrong to me.
> >>>
> >>> I think this is a false positive and not stable material.
> >>
> >> The point is that there are other paths does kn->count =E2=80=94> cpu_=
hotplug_lock without needing device_hotplug_lock to race with memory remova=
l.
> >>
> >> kmem_cache_shrink_all+0x50/0x100 (cpu_hotplug_lock.rw_sem/mem_hotplug_=
lock.rw_sem)
> >> shrink_store+0x34/0x60
> >> slab_attr_store+0x6c/0x170
> >> sysfs_kf_write+0x70/0xb0
> >> kernfs_fop_write+0x11c/0x270 ((kn->count)
> >> __vfs_write+0x3c/0x70
> >> vfs_write+0xcc/0x200
> >> ksys_write+0x7c/0x140
> >> system_call+0x5c/0x6
> >>
> >
> > But not the lock of the memory devices, or am I missing something?
> >
>
> To clarify:
>
> memory unplug will remove e.g., /sys/devices/system/memory/memoryX/,
> which has a dedicated kn->count AFAIK
>
> If you do a "echo 1 > /sys/kernel/slab/X/shrink", you would not lock the
> kn->count of /sys/devices/system/memory/memoryX/, but the one of some
> slab thingy.
>
> The only scenario I could see is if remove_memory_block_devices() will
> not only remove /sys/devices/system/memory/memoryX/, but also implicitly
> e.g., /sys/kernel/slab/X/. If that is the case, then this is indeed not
> a false positive, but something rather hard to trigger (which would
> still classify as stable material).

Yes, already agreed to drop stable.

However, the trylock does not solve the race it just turns the
blocking wait to a spin wait, but the subsequent 5ms sleep does make
the theoretical race nearly impossible, Thanks for pointing that out.

The theoretical race is still a problem because it hides future
lockdep violations, but I otherwise can't point to whether the
kn->count in question is a false positive concern for an actual
deadlock or not. Tracking that down is possible, but not something I
have time for at present.
