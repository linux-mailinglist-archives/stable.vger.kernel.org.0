Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747266D85B5
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 20:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbjDESKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 14:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbjDESKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 14:10:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E2C191
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 11:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680718203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQaR8cLruAgHBCHSLgU+0MSFf8a4qwol/WFeB+l5N2I=;
        b=EDqBYSHadGx6whOgb87cwnEb4PUip4+DZuWZL3jsKeS/Tx2MmDfqojCDd+brMfYbAjKssW
        mSjCAt1ogqYA/8As8A1aSW2uo5lLzvWjInF1X/y57x34xk1YoFIA8uqhcvknPMic30ynUx
        xxUtUkUMeIi441QWnR00k1iDgM2ZGyo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-j8EZ-MdwP9Sr5Us2ylVlUg-1; Wed, 05 Apr 2023 14:10:02 -0400
X-MC-Unique: j8EZ-MdwP9Sr5Us2ylVlUg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3e2daffa0d4so12475131cf.0
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 11:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680718202;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iQaR8cLruAgHBCHSLgU+0MSFf8a4qwol/WFeB+l5N2I=;
        b=OmSVi/l2DxcGj3AD4Dd/uzNxqKsT/sxqdzTOL3NNequGSaaCvuuldeL7P9i90wlA5Q
         4jPbZqemC7kPhw+KKpDRYbA/P1EoDhVpM9p3WT2s8CVj7NSLefK8N4p3qx8faywrqrro
         vktdUYhxtvxQPhcX1mSUTApV8tNLuPxDQWfzkrIeHH/n1dMDPJm/aQ+GR45pag1XmQtk
         NP6M8YxYRoe29nuUNmlU6zFWHLOXDtea2UqI/2pdS3+KNUUNRpaMhCKNfaPvUzPeWLlR
         Y/3KdUTB9p7ZxGg8DRajkZmB8yFSKGupHDOxH70t9rY82Kknb1RggrxazmGsniiHtG3Q
         EfZA==
X-Gm-Message-State: AAQBX9fxKDxXqBTO0nxZrQj44dtGxVQKVNIiKRlTxqvHBi1FkJjyo74k
        TpfDlT+JK3wFXK6D1xnggAM2Nrips9RqbvsnkyNw/Ec/bawCENuL64ii1dAeVnQP+LUt6KwihQ/
        uoggcMDfJCtgMHmUw
X-Received: by 2002:a05:622a:1a24:b0:3e6:707e:d3c2 with SMTP id f36-20020a05622a1a2400b003e6707ed3c2mr7427866qtb.0.1680718201961;
        Wed, 05 Apr 2023 11:10:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350YSvj/32iOp1pxSx0WMu3r+k7g2O68tq9YtIyZ2lMFIwHgD2EkuFNYDwmPWW8noOYsVZWdd+Q==
X-Received: by 2002:a05:622a:1a24:b0:3e6:707e:d3c2 with SMTP id f36-20020a05622a1a2400b003e6707ed3c2mr7427806qtb.0.1680718201547;
        Wed, 05 Apr 2023 11:10:01 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id c30-20020ac86e9e000000b003e388264753sm4116280qtv.65.2023.04.05.11.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 11:10:01 -0700 (PDT)
Date:   Wed, 5 Apr 2023 14:09:59 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Yang Shi <shy828301@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/khugepaged: Check again on anon uffd-wp during
 isolation
Message-ID: <ZC25d12d0sc1L7tS@x1n>
References: <20230405155120.3608140-1-peterx@redhat.com>
 <CAHbLzkqKE-TE9Od1E=PQDGuhoR+r-TOz4LP8WQgucm_6ZVYTRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkqKE-TE9Od1E=PQDGuhoR+r-TOz4LP8WQgucm_6ZVYTRA@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 09:59:15AM -0700, Yang Shi wrote:
> On Wed, Apr 5, 2023 at 8:51 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > Khugepaged collapse an anonymous thp in two rounds of scans.  The 2nd round
> > done in __collapse_huge_page_isolate() after hpage_collapse_scan_pmd(),
> > during which all the locks will be released temporarily. It means the
> > pgtable can change during this phase before 2nd round starts.
> >
> > It's logically possible some ptes got wr-protected during this phase, and
> > we can errornously collapse a thp without noticing some ptes are
> > wr-protected by userfault.  e1e267c7928f wanted to avoid it but it only did
> > that for the 1st phase, not the 2nd phase.
> >
> > Since __collapse_huge_page_isolate() happens after a round of small page
> > swapins, we don't need to worry on any !present ptes - if it existed
> > khugepaged will already bail out.  So we only need to check present ptes
> > with uffd-wp bit set there.
> >
> > This is something I found only but never had a reproducer, I thought it was
> > one caused a bug in Muhammad's recent pagemap new ioctl work, but it turns
> > out it's not the cause of that but an userspace bug.  However this seems to
> > still be a real bug even with a very small race window, still worth to have
> > it fixed and copy stable.
> 
> Yeah, I agree. But I got confused by userfaultfd_wp(vma) and
> pte_uffd_wp(pte). If a vma is armed with uffd wp, shall we skip the
> whole vma? If so, whether it is better to just check vma? We do
> revalidate vma once reacquiring mmap_lock, so we should be able to
> bail out earlier.

Checking against VMA is safe too, the difference is current code still
allows thp to be collapsed as long as none of the page is explicitly
protected over the thp range, even if the range is registered with
userfault-wp.  That's also what e1e267c7928f does.

Here we have slightly different handling between anon / file thps (file
thps checks against the vma flags), IMHO mostly because we don't scan
pgtables when making decisions to collapse a shmem thp, so we made it
simple by checking against vma flags.  We can make it the same as anon but
it might be an overkill just to scan the entries for uffd-wp purpose.

For anon we always scans the pgtable anyway so it's easier to make a more
accurate decision.

Thanks,

-- 
Peter Xu

