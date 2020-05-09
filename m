Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74701CBDCE
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 07:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgEIFkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 01:40:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24393 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725820AbgEIFkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 01:40:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589002839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mTjszWW/EefMrw7aIGeEPuK1Cqsav+nLkGOW2S21ZN0=;
        b=cPLqtTmk0abJ/hBbOqR8Lj/4tS7FTfVExcDTGwffbYb0v5UyzSW2r4d+fIoFmRVDYpiEW/
        hjrxFlYUYBDRgr38TnSPpZgBRNoWi0O9ahUExLVztEbmrtMmbBXOL1IoKKRSCBKGedYDCb
        lvZDutk6DZQiB+jHwLv+exODYdBw4jY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-UpxE3P7dOe6VOiCALyug4w-1; Sat, 09 May 2020 01:40:37 -0400
X-MC-Unique: UpxE3P7dOe6VOiCALyug4w-1
Received: by mail-wr1-f72.google.com with SMTP id a12so1939969wrv.3
        for <stable@vger.kernel.org>; Fri, 08 May 2020 22:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=mTjszWW/EefMrw7aIGeEPuK1Cqsav+nLkGOW2S21ZN0=;
        b=JPlXv2nxIm3zvM+ThWCeF2O+g5oFJDjPuBt0UPKpHuB4CboW1WMnq/wtaSEktrD5QD
         Lu/5/11Ej9tF1gyx6RsV9Mu29lCgvaqIvnZLojh9a5pOEa8DBLHzHETLC8Zz7uzA9OZi
         mFKHn/AaXsy8KTcX7aOUEN72RHBNC4ldm5vKA3to5yfyuunMI8GNm9YpC3HEEwFQq9Hu
         nW+gTk4s1e91e37z2dV9DmqtFYExBQrO6Q+Hs0c3cTsv0ujpatocpvPR0wA4ubA6C4wz
         scUA2HRd4Mk4+Yc7wHBn/UFY8mfa1IdaXf9eCzHZFfCzuciDPhmUM08yxQ/vgvVkOMd7
         9YiA==
X-Gm-Message-State: AGi0PuadM50HPc+HO6iVnPYrHSXAa4j5Ztj93BQs1d4skl1gMADSQsVh
        947tfLe/LEqe6mSrGoBVdanofgLhaY3g6pLGcmgvQOd/i2h/IgX/MtAKTiF/i3XqZqhZTBogH8L
        NpX+OKtHk/7p7+tQl
X-Received: by 2002:a5d:52ce:: with SMTP id r14mr7021347wrv.334.1589002835882;
        Fri, 08 May 2020 22:40:35 -0700 (PDT)
X-Google-Smtp-Source: APiQypLh46b+OJHiK+BmOVxHBKBIBg126/s6UEDmzeKxMWF5zY7CcNlENVRlnP1JVfzUUAXHjN/rxA==
X-Received: by 2002:a5d:52ce:: with SMTP id r14mr7021307wrv.334.1589002835393;
        Fri, 08 May 2020 22:40:35 -0700 (PDT)
Received: from ?IPv6:2a01:598:b901:53f:9037:7517:2497:29c? ([2a01:598:b901:53f:9037:7517:2497:29c])
        by smtp.gmail.com with ESMTPSA id z6sm437028wrq.1.2020.05.08.22.40.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 22:40:34 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v4 1/4] device-dax: Don't leak kernel memory to user space after unloading kmem
Date:   Sat, 9 May 2020 07:40:33 +0200
Message-Id: <B72EB609-44DC-4133-820C-9BEA95CA012D@redhat.com>
References: <20200508165306.7cd806f7e451c5c9bc2a40ac@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-nvdimm@lists.01.org,
        kexec@lists.infradead.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <20200508165306.7cd806f7e451c5c9bc2a40ac@linux-foundation.org>
To:     Andrew Morton <akpm@linux-foundation.org>
X-Mailer: iPhone Mail (17D50)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> Am 09.05.2020 um 01:53 schrieb Andrew Morton <akpm@linux-foundation.org>:
>=20
> =EF=BB=BFOn Fri,  8 May 2020 10:42:14 +0200 David Hildenbrand <david@redha=
t.com> wrote:
>=20
>> Assume we have kmem configured and loaded:
>>  [root@localhost ~]# cat /proc/iomem
>>  ...
>>  140000000-33fffffff : Persistent Memory$
>>    140000000-1481fffff : namespace0.0
>>    150000000-33fffffff : dax0.0
>>      150000000-33fffffff : System RAM
>>=20
>> Assume we try to unload kmem. This force-unloading will work, even if
>> memory cannot get removed from the system.
>>  [root@localhost ~]# rmmod kmem
>>  [   86.380228] removing memory fails, because memory [0x0000000150000000=
-0x0000000157ffffff] is onlined
>>  ...
>>  [   86.431225] kmem dax0.0: DAX region [mem 0x150000000-0x33fffffff] can=
not be hotremoved until the next reboot
>>=20
>> Now, we can reconfigure the namespace:
>>  [root@localhost ~]# ndctl create-namespace --force --reconfig=3Dnamespac=
e0.0 --mode=3Ddevdax
>>  [  131.409351] nd_pmem namespace0.0: could not reserve region [mem 0x140=
000000-0x33fffffff]dax
>>  [  131.410147] nd_pmem: probe of namespace0.0 failed with error -16names=
pace0.0 --mode=3Ddevdax
>>  ...
>>=20
>> This fails as expected due to the busy memory resource, and the memory
>> cannot be used. However, the dax0.0 device is removed, and along its name=
.
>>=20
>> The name of the memory resource now points at freed memory (name of the
>> device).
>>  [root@localhost ~]# cat /proc/iomem
>>  ...
>>  140000000-33fffffff : Persistent Memory
>>    140000000-1481fffff : namespace0.0
>>    150000000-33fffffff : =EF=BF=BD_=EF=BF=BD^7_=EF=BF=BD=EF=BF=BD/_=EF=BF=
=BD=EF=BF=BDwR=EF=BF=BD=EF=BF=BDWQ=EF=BF=BD=EF=BF=BD=EF=BF=BD^=EF=BF=BD=EF=BF=
=BD=EF=BF=BD ...
>>    150000000-33fffffff : System RAM
>>=20
>> We have to make sure to duplicate the string. While at it, remove the
>> superfluous setting of the name and fixup a stale comment.
>>=20
>> Fixes: 9f960da72b25 ("device-dax: "Hotremove" persistent memory that is u=
sed like normal RAM")
>> Cc: stable@vger.kernel.org # v5.3
>=20
> hm.
>=20
> Is this really -stable material?  These are all privileged operations,
> I expect?

Yes, my thought was rather that an admin could bring the system into such a s=
tate (by mistake?). Let=E2=80=98s see if somebody has a suggestion.

I guess if we were really unlucky, we could access invalid memory and trigge=
r a BUG (e.g., page at the end of memory and does not contain a 0 byte).

>=20
> Assuming "yes", I've queued this separately, staged for 5.7-rcX.  I'll
> redo patches 2-4 as a three-patch series for 5.8-rc1.

Make sense, let=E2=80=98s wait for review feedback, thanks!=

