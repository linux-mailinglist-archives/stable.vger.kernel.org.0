Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4122698AEC
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 04:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjBPDJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 22:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBPDJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 22:09:23 -0500
X-Greylist: delayed 442 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Feb 2023 19:09:22 PST
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3614328867
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 19:09:22 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676516518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oBZ4aOX54Qf7DGSR8bvaHs3h5OL6RVtn8Ath+roiWSw=;
        b=PPrj1pgKhCBIVQT6V5CAEKhDG2BzDiYhhsg9aF32ZgqPvB7BBWqKLJH2LzHR5BrkEv0C7R
        aV47siLcyBaZbfUQ5tsCiwxbotIunF3ouZyWXc5ZgM7VYCNhioI4hALbscQkB5bhuiOJjQ
        e3mpXeRDln2mUFIzl1W3zchyQRbDORg=
MIME-Version: 1.0
Subject: Re: [PATCH] hugetlb: check for undefined shift on 32 bit
 architectures
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20230216013542.138708-1-mike.kravetz@oracle.com>
Date:   Thu, 16 Feb 2023 11:01:13 +0800
Cc:     Linux Memory Management List <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9B09A3E9-09E6-44E4-9B4F-30975C6947B7@linux.dev>
References: <20230216013542.138708-1-mike.kravetz@oracle.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Feb 16, 2023, at 09:35, Mike Kravetz <mike.kravetz@oracle.com> =
wrote:
>=20
> Users can specify the hugetlb page size in the mmap, shmget and
> memfd_create system calls.  This is done by using 6 bits within the
> flags argument to encode the base-2 logarithm of the desired page =
size.
> The routine hstate_sizelog() uses the log2 value to find the
> corresponding hugetlb hstate structure.  Converting the log2 value
> (page_size_log) to potential hugetlb page size is the simple =
statement:
>=20
> 1UL << page_size_log
>=20
> Because only 6 bits are used for page_size_log, the left shift can not
> be greater than 63.  This is fine on 64 bit architectures where a long
> is 64 bits.  However, if a value greater than 31 is passed on a 32 bit
> architecture (where long is 32 bits) the shift will result in =
undefined
> behavior.  This was generally not an issue as the result of the
> undefined shift had to exactly match hugetlb page size to proceed.
>=20
> Recent improvements in runtime checking have resulted in this =
undefined
> behavior throwing errors such as reported below.
>=20
> Fix by comparing page_size_log to BITS_PER_LONG before doing shift.
>=20
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Link: =
https://lore.kernel.org/lkml/CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=3DPB7kT0=3D=
yv4MiPgVg@mail.gmail.com/
> Fixes: 42d7395feb56 ("mm: support more pagesizes for =
MAP_HUGETLB/SHM_HUGETLB")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>

Acked-by: Muchun Song <songmuchun@bytedance.com>

Thanks.

