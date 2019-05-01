Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E20106FE
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 12:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfEAKdB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 1 May 2019 06:33:01 -0400
Received: from ozlabs.org ([203.11.71.1]:50579 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfEAKdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 May 2019 06:33:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44vF8m5zk3z9s9N;
        Wed,  1 May 2019 20:32:56 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, rguenther@suse.de,
        mhocko@suse.com, vbabka@suse.cz, luto@amacapital.net,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] x86/mpx: fix recursive munmap() corruption
In-Reply-To: <4e1bbb14-e14f-8643-2072-17b4cdef5326@linux.vnet.ibm.com>
References: <20190401141549.3F4721FE@viggo.jf.intel.com> <alpine.DEB.2.21.1904191248090.3174@nanos.tec.linutronix.de> <87d0lht1c0.fsf@concordia.ellerman.id.au> <6718ede2-1fcb-1a8f-a116-250eef6416c7@linux.vnet.ibm.com> <4f43d4d4-832d-37bc-be7f-da0da735bbec@intel.com> <4e1bbb14-e14f-8643-2072-17b4cdef5326@linux.vnet.ibm.com>
Date:   Wed, 01 May 2019 20:32:55 +1000
Message-ID: <87k1faa2i0.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Laurent Dufour <ldufour@linux.vnet.ibm.com> writes:
> Le 23/04/2019 à 18:04, Dave Hansen a écrit :
>> On 4/23/19 4:16 AM, Laurent Dufour wrote:
...
>>> There are 2 assumptions here:
>>>   1. 'start' and 'end' are page aligned (this is guaranteed by __do_munmap().
>>>   2. the VDSO is 1 page (this is guaranteed by the union vdso_data_store on powerpc)
>> 
>> Are you sure about #2?  The 'vdso64_pages' variable seems rather
>> unnecessary if the VDSO is only 1 page. ;)
>
> Hum, not so sure now ;)
> I got confused, only the header is one page.
> The test is working as a best effort, and don't cover the case where 
> only few pages inside the VDSO are unmmapped (start > 
> mm->context.vdso_base). This is not what CRIU is doing and so this was 
> enough for CRIU support.
>
> Michael, do you think there is a need to manage all the possibility 
> here, since the only user is CRIU and unmapping the VDSO is not a so 
> good idea for other processes ?

Couldn't we implement the semantic that if any part of the VDSO is
unmapped then vdso_base is set to zero? That should be fairly easy, eg:

	if (start < vdso_end && end >= mm->context.vdso_base)
		mm->context.vdso_base = 0;


We might need to add vdso_end to the mm->context, but that should be OK.

That seems like it would work for CRIU and make sense in general?

cheers
