Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B108BDE64F
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 10:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbfJUI2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 04:28:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27496 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727047AbfJUI2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 04:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571646512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gz00+Twny7yE9efbQh6949Yl0LL93FuRzfJ8xHPNvtw=;
        b=OxwIoB+CJ2qtBBQyfam9Q97WOIYsoI5zZx7R9lP5BxBC9KQlapatxwmF/OoTFjOnWrsHDl
        Wi36VqbeR/Chn8YdDvxtQX3D+PS+dM8xAQLHt5ESebOezRsxKyY975XlkGd+kCP6vGzwWJ
        t5D6b0tPDoLSo56TdYJNKkByOGLmx70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-Tc0YJI4sMVeMAx8tzIlxfQ-1; Mon, 21 Oct 2019 04:28:29 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D38DB47B;
        Mon, 21 Oct 2019 08:28:27 +0000 (UTC)
Received: from [10.36.116.198] (ovpn-116-198.ams2.redhat.com [10.36.116.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3FFD60126;
        Mon, 21 Oct 2019 08:28:16 +0000 (UTC)
Subject: Re: [patch 07/26] mm/memunmap: don't access uninitialized memmap in
 memunmap_pages()
To:     Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org
Cc:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        cai@lca.pw, catalin.marinas@arm.com, christophe.leroy@c-s.fr,
        dalias@libc.org, damian.tometzki@gmail.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        fenghua.yu@intel.com, gerald.schaefer@de.ibm.com,
        glider@google.com, gor@linux.ibm.com, gregkh@linuxfoundation.org,
        heiko.carstens@de.ibm.com, hpa@zytor.com, ira.weiny@intel.com,
        jgg@ziepe.ca, linux-mm@kvack.org, logang@deltatee.com,
        luto@kernel.org, mark.rutland@arm.com, mgorman@techsingularity.net,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        osalvador@suse.de, pagupta@redhat.com, pasha.tatashin@soleen.com,
        pasic@linux.ibm.com, paulus@samba.org,
        pavel.tatashin@microsoft.com, peterz@infradead.org,
        richard.weiyang@gmail.com, richardw.yang@linux.intel.com,
        robin.murphy@arm.com, rppt@linux.ibm.com, stable@vger.kernel.org,
        steve.capper@arm.com, tglx@linutronix.de, thomas.lendacky@amd.com,
        tony.luck@intel.com, torvalds@linux-foundation.org, vbabka@suse.cz,
        will@kernel.org, willy@infradead.org,
        yamada.masahiro@socionext.com, yaojun8558363@gmail.com,
        ysato@users.sourceforge.jp, yuzhao@google.com
References: <20191019031939.9XlSnLGcS%akpm@linux-foundation.org>
 <20191021082610.GC9379@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <8ae0ba46-371b-9fed-0225-2c05bd3d6748@redhat.com>
Date:   Mon, 21 Oct 2019 10:28:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191021082610.GC9379@dhcp22.suse.cz>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Tc0YJI4sMVeMAx8tzIlxfQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.10.19 10:26, Michal Hocko wrote:
> Has this been properly reviewed? I do not see any Acks nor Reviewed-bys.
>=20

As I modified this patch while carrying it along, it at least has my=20
implicit Ack/RB.

--=20

Thanks,

David / dhildenb

