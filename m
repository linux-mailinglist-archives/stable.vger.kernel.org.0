Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2F7138189
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 15:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgAKOZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 09:25:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40274 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729446AbgAKOZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jan 2020 09:25:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578752747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uwm6fzYAwEwYeUfJoESjpA/0Z/xwqqojB6vogh+wkjc=;
        b=hdRCBOSXPuBExbHjmDfXCr9fKwJf29R4rIYcHXDUH9Is352NVa5OT3qAeh0mX8DoYdWqXm
        ZvJr9C104URymMN+rhmU0aZakYda6MDTfB9keYVF0C2QEt98bUmjYyIN/vvltCosxya+oG
        yANE6NtAmS/IK5Bc+Zyr78UK+gdJ2cA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-A-OyvlMvP42dyeMB6pdIxw-1; Sat, 11 Jan 2020 09:25:46 -0500
X-MC-Unique: A-OyvlMvP42dyeMB6pdIxw-1
Received: by mail-wr1-f69.google.com with SMTP id w6so2388806wrm.16
        for <stable@vger.kernel.org>; Sat, 11 Jan 2020 06:25:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=uwm6fzYAwEwYeUfJoESjpA/0Z/xwqqojB6vogh+wkjc=;
        b=ktiTmPxA8slaczl2YtLw1/G7jL6ooVsUW3OOy1sp61eMy2Ept+7hys9pEwNbG9cw/5
         kCYIHQleOFgsEBidQMXwyT7fRs1c4AyZ+AxqKec1DagVqDim3mnfflaKgKpi/ZiOKsi0
         CVZ1jCOja/H9KvLm78c1wGuxttYMmUC3yqpkHb1ScOtqqFr9lQJiN27lYN8CJOPZAYIi
         N7KTymb6GY2AB++xtosozk6h6JWhYrdW6WiOlv+yzCLcKNpD9gdWpPAtRckxQi3Eqnhl
         8GkZHvlvXmZcMbYM2vwMnrNf8Cqn7/p26tmZ4MlbbJr22HbnZkEozikNpZMhmq+IzuLd
         qGYw==
X-Gm-Message-State: APjAAAVE2dp4yK6Z+kNyltMa2iS9ZzUeM/SiuM04tKqEZeo7QW9eJ2Cw
        4r4qfapp3MmdBD7l3TxOzNRjw3L4PPxSsQ7qJeOkZvpu66HTeOQF1VHG9exgyk9LdWL9RRWCCbh
        nPow5tv6SALuSDOlF
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr10515199wmo.13.1578752744911;
        Sat, 11 Jan 2020 06:25:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSMY0g766OIWIeVMg+yNdNqGqj5e1pDAALjmcABqjRilt5M6mGJLkpE9/bqBayyDf6yzOWnA==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr10515180wmo.13.1578752744691;
        Sat, 11 Jan 2020 06:25:44 -0800 (PST)
Received: from ?IPv6:2a01:598:a803:c918:4c2f:c5d7:9026:f3de? ([2a01:598:a803:c918:4c2f:c5d7:9026:f3de])
        by smtp.gmail.com with ESMTPSA id z83sm6670184wmg.2.2020.01.11.06.25.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 06:25:44 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v4] mm/memory_hotplug: Fix remove_memory() lockdep splat
Date:   Sat, 11 Jan 2020 15:25:43 +0100
Message-Id: <A5A31713-0D55-487C-814A-1415BB26DC1F@redhat.com>
References: <0BE8F7EF-01DC-47BD-899B-11FB8B40EB0A@lca.pw>
Cc:     David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
In-Reply-To: <0BE8F7EF-01DC-47BD-899B-11FB8B40EB0A@lca.pw>
To:     Qian Cai <cai@lca.pw>
X-Mailer: iPhone Mail (17C54)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> Am 11.01.2020 um 14:56 schrieb Qian Cai <cai@lca.pw>:
>=20
> =EF=BB=BF
>=20
>> On Jan 11, 2020, at 6:03 AM, David Hildenbrand <david@redhat.com> wrote:
>>=20
>> So I just remember why I think this (and the previously reported done
>> for ACPI DIMMs) are false positives. The actual locking order is
>>=20
>> onlining/offlining from user space:
>>=20
>> kn->count -> device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_lock
>>=20
>> memory removal:
>>=20
>> device_hotplug_lock -> cpu_hotplug_lock -> mem_hotplug_lock -> kn->count
>>=20
>>=20
>> This looks like a locking inversion - but it's not. Whenever we come via
>> user space we do a mutex_trylock(), which resolves this issue by backing
>> up. The device_hotplug_lock will prevent
>>=20
>> I have no clue why the device_hotplug_lock does not pop up in the
>> lockdep report here. Sounds wrong to me.
>>=20
>> I think this is a false positive and not stable material.
>=20
> The point is that there are other paths does kn->count =E2=80=94> cpu_hotp=
lug_lock without needing device_hotplug_lock to race with memory removal.
>=20
> kmem_cache_shrink_all+0x50/0x100 (cpu_hotplug_lock.rw_sem/mem_hotplug_lock=
.rw_sem)
> shrink_store+0x34/0x60
> slab_attr_store+0x6c/0x170
> sysfs_kf_write+0x70/0xb0
> kernfs_fop_write+0x11c/0x270 ((kn->count)
> __vfs_write+0x3c/0x70
> vfs_write+0xcc/0x200
> ksys_write+0x7c/0x140
> system_call+0x5c/0x6
>=20

But not the lock of the memory devices, or am I missing something?=

