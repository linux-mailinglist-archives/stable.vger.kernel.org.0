Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625E6138173
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 14:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgAKN4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 08:56:02 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:37811 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729301AbgAKN4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 08:56:02 -0500
Received: by mail-qv1-f68.google.com with SMTP id f16so2100310qvi.4
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 05:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=pLHRqkxg+SGX61pyQZgO27/FZ0iiiEv81an7baxGtT8=;
        b=OK9i4wKZg4fpUMfvuXi2xTweFEImd2guEcKGUGG9TGCnq/lnobxG5dIEKh+f5v4Z5t
         RJguCkMFef6Kyh658FgBzhIuXfuA2DgakWfeWnR5v8dRbT9qsGppLVUSHaQx1fTTI3pp
         7jSMOw8w7XL1PQ+Xuzu9phKMirES4XYeQUnPXdJIjnRp6Q5jifr+F7juLnTV6HiKHdsh
         7hEzCE4KcXFZkEVQjIKHWm0BmPvivOR6+QT7EzNH/rUSKN9P1VIxVYEEfV42I9+WrzwV
         wf8m+vDhPxjuRfRnPbZUta1RTimN7ihWkbwg8ulLOVSY0hBdFoYkV6x01ICtFF3AJHnM
         CRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=pLHRqkxg+SGX61pyQZgO27/FZ0iiiEv81an7baxGtT8=;
        b=YnM25ikHXumBleWkZlpYMTqa3OnzWuVOdX8lhiYEJXuhAsD/ljJsOSY3W+/YNNubza
         IoV9mQY+kfWLBzMjYeC4GZS0PMLQ23vo5Sak7gHnIj14Y4i+gqTSDJngSwcCjCL4xa/J
         3eIDnFKoyvD3wYw4G0/cJFQ6CjQugDehpZPWEKgKKBtsXqcBl//GdCZUaMnUivUjx3IA
         UiGhgRLhFo3hHjkJqQ6WjOKm/i2Ao0S/5v385AQHiICTd1eodJbA8VEw+9SGCSfVImHF
         rluocDVt88nmEhFo/Q/tZYTWyumQG/70MnOQofuhRiLrxqtZVDoIktlItDZDxtW5jRTP
         lolg==
X-Gm-Message-State: APjAAAUtDbMKfwdr29UWcCmMbn6xeqr99ITsN6qIaMt+HuVJ4wv0rg/R
        2Qa1L/QDP059BuP35GaRf6RGlQ==
X-Google-Smtp-Source: APXvYqyGmywokZQjVyxs1thk3QfLbiLA75tqN71SQZ7K+dfrdGpw+G6es//twpI2Pr5mRwsHAW+hHA==
X-Received: by 2002:a05:6214:180e:: with SMTP id o14mr3499290qvw.209.1578750961706;
        Sat, 11 Jan 2020 05:56:01 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id c8sm2636707qtv.61.2020.01.11.05.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 05:56:01 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v4] mm/memory_hotplug: Fix remove_memory() lockdep splat
Date:   Sat, 11 Jan 2020 08:55:59 -0500
Message-Id: <0BE8F7EF-01DC-47BD-899B-11FB8B40EB0A@lca.pw>
References: <a3d58f0b-145f-1e70-434f-e97e1f08ebcf@redhat.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
In-Reply-To: <a3d58f0b-145f-1e70-434f-e97e1f08ebcf@redhat.com>
To:     David Hildenbrand <david@redhat.com>
X-Mailer: iPhone Mail (17C54)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jan 11, 2020, at 6:03 AM, David Hildenbrand <david@redhat.com> wrote:
>=20
> So I just remember why I think this (and the previously reported done
> for ACPI DIMMs) are false positives. The actual locking order is
>=20
> onlining/offlining from user space:
>=20
> kn->count -> device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_lock
>=20
> memory removal:
>=20
> device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_lock -> kn->count
>=20
>=20
> This looks like a locking inversion - but it's not. Whenever we come via
> user space we do a mutex_trylock(), which resolves this issue by backing
> up. The device_hotplug_lock will prevent
>=20
> I have no clue why the device_hotplug_lock does not pop up in the
> lockdep report here. Sounds wrong to me.
>=20
> I think this is a false positive and not stable material.

The point is that there are other paths does kn->count =E2=80=94> cpu_hotplu=
g_lock without needing device_hotplug_lock to race with memory removal.

kmem_cache_shrink_all+0x50/0x100 (cpu_hotplug_lock.rw_sem/mem_hotplug_lock.r=
w_sem)
shrink_store+0x34/0x60
slab_attr_store+0x6c/0x170
sysfs_kf_write+0x70/0xb0
kernfs_fop_write+0x11c/0x270 ((kn->count)
 __vfs_write+0x3c/0x70
 vfs_write+0xcc/0x200
ksys_write+0x7c/0x140
system_call+0x5c/0x6=
