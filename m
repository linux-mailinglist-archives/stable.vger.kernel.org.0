Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAA35A2BC3
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 17:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344606AbiHZPzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 11:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiHZPzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 11:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B638C445
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 08:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661529347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kxP+Dmq/9QrBSNE7t25KnXniHyhrvm0D5T7RzuSjQVM=;
        b=BckzJXwoci2ns9E9yfw/86jPHpQKs9xHUuTgB04a61ObWrE/GjkMlfGkizRzrgeLSh6102
        VdSC3T9bWcjGy7OR0WNyWSqiVx2RAs0lCXToLlpNWFoVMEccbDnSOcXLmDFE66DjJo9J91
        N5ugMYbRfRuHR/fSe59qGNfWsRmTfxo=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-388-eSZqlwEINguu82ycH68fFA-1; Fri, 26 Aug 2022 11:55:46 -0400
X-MC-Unique: eSZqlwEINguu82ycH68fFA-1
Received: by mail-qt1-f199.google.com with SMTP id fy12-20020a05622a5a0c00b00344569022f7so1562973qtb.17
        for <stable@vger.kernel.org>; Fri, 26 Aug 2022 08:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=kxP+Dmq/9QrBSNE7t25KnXniHyhrvm0D5T7RzuSjQVM=;
        b=4qbTvvWmxL3RZ4PqkblBuUMLJzUg/tUcefbfD3Bhx58tQvtcJVWxsoeG2jjgO0M7yX
         VLV7VoD5Qk+C9vDDiDFvF0TuuLUz51YeSBeN/jFisX2cptmtMAbk5iSDK0BBdI50LHoN
         GwF2A22bbTgGA1DIOKY4ySWUi7TBZ6+4eX6OjNobUeJg3MYMaeu3Oir/AOh1UXMK9Bwq
         NpwRsGuQe8VU3MtdghrfORnE97hbttzqgW/fl5vV1xdbyZiSpTOzeqULIgu3hZMiZQpv
         j/kb9FN4iQZC5MAO4rIFLxW+PMkIS7dZwfPm1+0i0dZpjynfH0oDFZCKzGCXRFgufQGj
         Qscw==
X-Gm-Message-State: ACgBeo07mny62lxUIsQst3xyqBLm6QxL8RTBTldwF+PFyfO2e/gFeWNK
        cNWEutG0zs2CbYfoHFgwUstyWfSubat7ifXOX4L1JB0z3iRha/lxGYGZtxaXzoXXNak9/7uLPmd
        E9aET2gV3Fk9Rv1o6
X-Received: by 2002:a05:620a:4549:b0:6bb:bcd5:bebd with SMTP id u9-20020a05620a454900b006bbbcd5bebdmr237494qkp.281.1661529345624;
        Fri, 26 Aug 2022 08:55:45 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ptvaOj1PH8113xcy+IwXkhfYIf0njU7CP9Dg6jANrLlzn5ahE+pvxpqeln6UJrgFHbun7Bg==
X-Received: by 2002:a05:620a:4549:b0:6bb:bcd5:bebd with SMTP id u9-20020a05620a454900b006bbbcd5bebdmr237473qkp.281.1661529345399;
        Fri, 26 Aug 2022 08:55:45 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id y6-20020a05620a25c600b006b59f02224asm2017524qko.60.2022.08.26.08.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 08:55:44 -0700 (PDT)
Date:   Fri, 26 Aug 2022 11:55:42 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, Nadav Amit <nadav.amit@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH v3 2/3] mm/migrate_device.c: Copy pte dirty bit to page
Message-ID: <Ywjs/i4kIVlxZwpb@xz-m1.local>
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
 <ffbc824af5daa2c44b91c66834a341894fba4ce6.1661309831.git-series.apopple@nvidia.com>
 <YwZGHyYJiJ+CGLn2@xz-m1.local>
 <8735dkeyyg.fsf@nvdebian.thelocal>
 <YwgFRLn43+U/hxwt@xz-m1.local>
 <8735dj7qwb.fsf@nvdebian.thelocal>
 <YwjZamk4n/dz+Y/M@xz-m1.local>
 <72146725-3d70-0427-50d4-165283a5a85d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <72146725-3d70-0427-50d4-165283a5a85d@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 26, 2022 at 04:47:22PM +0200, David Hildenbrand wrote:
> > To me anon exclusive only shows this mm exclusively owns this page. I
> > didn't quickly figure out why that requires different handling on tlb
> > flushs.  Did I perhaps miss something?
> 
> GUP-fast is the magic bit, we have to make sure that we won't see new
> GUP pins, thus the TLB flush.
> 
> include/linux/mm.h:gup_must_unshare() contains documentation.

Hmm.. Shouldn't ptep_get_and_clear() (e.g., xchg() on x86_64) already
guarantees that no other process/thread will see this pte anymore
afterwards?

-- 
Peter Xu

