Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C936DE6A6
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 10:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfJUIgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 04:36:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25789 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726227AbfJUIgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 04:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571646966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ewVPPXtUzwa/2gMziVT4GfNhMvA6qBwP9ka3yYbfjF8=;
        b=DTaaddhh+PoLUlctAzPpOaipyBUNe9wlT+3sNfdRM6e3ogDMrId+6C3879Q4fWUTv4vAmw
        KpysYaSuDI927CqC74x/HyzDT7+Vc4ah4IkccdtUMhZmdAZ32twLjmDRMlfD70QFMHMx4u
        XFPclUfFD9i5xMKd3J4ht+7vnhR6P2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-zoWy5pCgP46PYWXgoF_mrg-1; Mon, 21 Oct 2019 04:36:04 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DBCE1005500;
        Mon, 21 Oct 2019 08:36:03 +0000 (UTC)
Received: from [10.36.116.198] (ovpn-116-198.ams2.redhat.com [10.36.116.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39B60F6FB;
        Mon, 21 Oct 2019 08:35:50 +0000 (UTC)
Subject: Re: [patch 06/26] mm/memory_hotplug: don't access uninitialized
 memmaps in shrink_pgdat_span()
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
References: <20191019031933.PakTLd2V_%akpm@linux-foundation.org>
 <20191021082841.GD9379@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <70fbf807-bd72-5192-ae38-f5a6b23fddf2@redhat.com>
Date:   Mon, 21 Oct 2019 10:35:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191021082841.GD9379@dhcp22.suse.cz>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: zoWy5pCgP46PYWXgoF_mrg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.10.19 10:28, Michal Hocko wrote:
> Has this been reviewed properly? I do not see any Acks nor Reviewed-bys.
> Did Aneesh gave it some testing?

No explicit ACK/RB. I know that Aneesh at leasted reviewed parts of the=20
v4/v5 series and gave it a test (which resulted in "[patch 07/26]=20
mm/memunmap: don't access uninitialized memmap in memunmap_pages()").

--=20

Thanks,

David / dhildenb

