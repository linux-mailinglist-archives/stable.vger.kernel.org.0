Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3C2E7471
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 16:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389003AbfJ1PHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 11:07:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33250 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726945AbfJ1PHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 11:07:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572275240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wy03vTKhGIoi/O2H6Dlq1tb/WWq4h8N+RHsApm8mCno=;
        b=OrfJteiaiXkqRewvhfiuuZnUlgbSnQOCEMiXSb9MpPx4KJhImoubtw63SCqEQO0a7mIORZ
        oPwREz82uBE/IRXwzE/PbCTf1tAElnjMpdZ5X1WTJLSCLO5KdbLbGzNQoSGssmCnmyocOP
        PNmbR7kv6QwqYzaUjjhaH6Aqp4T9gfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-BOB9xVolMheGmb5K0Jr7aA-1; Mon, 28 Oct 2019 11:07:14 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D0591804972;
        Mon, 28 Oct 2019 15:07:13 +0000 (UTC)
Received: from [10.36.117.63] (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE1145D6BE;
        Mon, 28 Oct 2019 15:07:11 +0000 (UTC)
Subject: Re: FAILED: patch "[PATCH] mm/memory-failure.c: don't access
 uninitialized memmaps in" failed to apply to 4.14-stable tree
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, mhocko@kernel.org,
        n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
References: <1572183691251118@kroah.com> <20191028084457.GJ1560@sasha-vm>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <a2defc30-700f-724f-7e59-fb1af9a528d5@redhat.com>
Date:   Mon, 28 Oct 2019 16:07:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191028084457.GJ1560@sasha-vm>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: BOB9xVolMheGmb5K0Jr7aA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.10.19 09:44, Sasha Levin wrote:
> On Sun, Oct 27, 2019 at 02:41:31PM +0100, gregkh@linuxfoundation.org wrot=
e:
>>
>> The patch below does not apply to the 4.14-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>>From 96c804a6ae8c59a9092b3d5dd581198472063184 Mon Sep 17 00:00:00 2001
>> From: David Hildenbrand <david@redhat.com>
>> Date: Fri, 18 Oct 2019 20:19:23 -0700
>> Subject: [PATCH] mm/memory-failure.c: don't access uninitialized memmaps=
 in
>> memory_failure()
>>
>> We should check for pfn_to_online_page() to not access uninitialized
>> memmaps.  Reshuffle the code so we don't have to duplicate the error
>> message.
>>
>> Link: http://lkml.kernel.org/r/20191009142435.3975-3-david@redhat.com
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Fixes: f1dd2cd13c4b ("mm, memory_hotplug: do not associate hotadded memo=
ry to zones until online")=09[visible after d0dc12e86b319]
>> Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: <stable@vger.kernel.org>=09[4.13+]
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>=20
> I took in 83b57531c58f4 ("mm/memory_failure: Remove unused trapno from
> memory_failure") for 4.14 to address this.
>=20

I guess that shouldn't be sufficient as we are missing the whole devmap=20
stuff? (at least not sufficient to cleanly cherry pick this patch)

The backport should be very simple, though. Did you already perform the=20
backport or shall I send one?

--=20

Thanks,

David / dhildenb

