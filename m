Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCA360821C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 01:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJUXjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 19:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJUXjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 19:39:14 -0400
X-Greylist: delayed 420 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Oct 2022 16:39:14 PDT
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064C32ADD3B
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 16:39:13 -0700 (PDT)
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <riel@shelob.surriel.com>)
        id 1om1Ul-0002Ll-0V;
        Fri, 21 Oct 2022 19:32:07 -0400
Message-ID: <3de4bb41badd79953df5af72827279e897344791.camel@surriel.com>
Subject: Re: [PATCH] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED
 processing
From:   Rik van Riel <riel@surriel.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Date:   Fri, 21 Oct 2022 19:32:06 -0400
In-Reply-To: <20221021230722.370587-1-mike.kravetz@oracle.com>
References: <20221021230722.370587-1-mike.kravetz@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-BltVCMQR0UYFZX5Kjqch"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Sender: riel@shelob.surriel.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-BltVCMQR0UYFZX5Kjqch
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-10-21 at 16:07 -0700, Mike Kravetz wrote:
> madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear the
> page tables associated with the address range.=C2=A0 For hugetlb vmas,
> zap_page_range will call __unmap_hugepage_range_final.=C2=A0 However,
> __unmap_hugepage_range_final assumes the passed vma is about to be
> removed and deletes the vma_lock to prevent pmd sharing as the vma is
> on the way out.=C2=A0 In the case of madvise(MADV_DONTNEED) the vma
> remains,
> but the missing vma_lock prevents pmd sharing and could potentially
> lead to issues with truncation/fault races.
>=20
> This issue was originally reported here [1] as a BUG triggered in
> page_try_dup_anon_rmap.=C2=A0 Prior to the introduction of the hugetlb
> vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag
> to
> prevent pmd sharing.=C2=A0 Subsequent faults on this vma were confused as
> VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping
> was not set in new pages added to the page table.=C2=A0 This resulted in
> pages that appeared anonymous in a VM_SHARED vma and triggered the
> BUG.
>=20
> Create a new routine clear_hugetlb_page_range() that can be called
> from
> madvise(MADV_DONTNEED) for hugetlb vmas.=C2=A0 It has the same setup as
> zap_page_range, but does not delete the vma_lock.
>=20
Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

--=-BltVCMQR0UYFZX5Kjqch
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmNTK/YACgkQznnekoTE
3oO1ewf7BRz85x843rfqU2bU6WR23hUrg1J5DkgmUU8YM+g6MSRoAy4aNMr01e8G
myXy05UuZzLNL1wfW3N3qomU+iTVlYjHAzV8a4g6P63sCzejdwAFMEOXUoKtqQYk
KzZueG9xhh+ael0APQlQ3JaU4p2UQ7nF2JSjLUJcUt9wE/t8gkOxYHg5MmkrkEgl
tmuVrQ4WmxkM7GLwbKJB+38lmQSbj1UNx4RZWDIG5k6VISoCRsH0XR2JitS5hYw8
OmWsU/iAs/zxXewjmSM0fHeDO2tutLo0S634GYBTfrMOZ3+TtEvakYy94LINEVKZ
J61B5PFjcwmYGJ4e4Q0rqmCKTPlc1w==
=nIj+
-----END PGP SIGNATURE-----

--=-BltVCMQR0UYFZX5Kjqch--
