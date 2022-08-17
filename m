Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2159763B
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 21:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238316AbiHQTHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 15:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiHQTHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 15:07:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01BC60694
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660763233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ABSmkuZfQM3Y1mClHJcPhcabJ5jPBDhGKX1+BXsp40=;
        b=cNL2w9KwtFrAexsqGKBqsxuTgKWqkI35z4xRmEcZdUtDLMXQ1XAhW7FARnaeQIIPbahDMe
        OYR/FHYtsng2SBn1VYrp6QAOIskTrK1+dO4oNSe36AGssvdJmaDwzs7BmRkQISEydHGUtZ
        gngx81mxRbP8qjwkWU6xR5Ps+JwH/vo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-290-Icxm4sIYOBKpdnewOAG1mQ-1; Wed, 17 Aug 2022 15:07:12 -0400
X-MC-Unique: Icxm4sIYOBKpdnewOAG1mQ-1
Received: by mail-qv1-f69.google.com with SMTP id dc13-20020a056214174d00b0047b6f9a1a9aso6819437qvb.23
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:07:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=5ABSmkuZfQM3Y1mClHJcPhcabJ5jPBDhGKX1+BXsp40=;
        b=XjU+dA/iiJKdgTxQBjtK+MMenkgOlEgU4dle1NRSJ7yjhvqhRAM1KRPXz9F1fL826I
         CTajlvrduEdIEQnkLsJdDC8Oo52TEnp1m2R0TQnhnLX0q6nFL8+OZKO/nXZoN1PPr1e0
         cp3FwgiYYUJbe01b02bxjdQ7PzDwGKioEUXYmT3uekLm41NfFDO6NXLEy2j7x9SOu0BN
         PtR11Ho0nI1l51WUxVtkneTzMdIyFfjZu3s0MWgT7p57TETmCQUNcOYlWgB9E2jMLvni
         aYsga2yTVXUCAYDTmKPry9JLTt0T7xwwCNWccnUB9UrWk/OEndbrAiJEg92BwOxXVSIy
         cpmg==
X-Gm-Message-State: ACgBeo1Z/RkccviffHXRFTHIetVaCEDhFiCWlVQpTkv24jvC4NZbYRbV
        zRM7d5b4RBFrOOURLxCb2idYQzotvn4ltSJA4OLwt+yQd7pA95o6BAFaYKlXaFbCZSpQaFT3MiY
        DfGOQAXbXgfMbqvni
X-Received: by 2002:ac8:5b15:0:b0:343:6789:193a with SMTP id m21-20020ac85b15000000b003436789193amr23697815qtw.647.1660763232202;
        Wed, 17 Aug 2022 12:07:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7htcPsTa+zO6/5dGIcJF7fto7SLs+oLa5/xcRr6PogKT9KpDCzjPlwU09EoMQTzAndOv0Wtg==
X-Received: by 2002:ac8:5b15:0:b0:343:6789:193a with SMTP id m21-20020ac85b15000000b003436789193amr23697775qtw.647.1660763231904;
        Wed, 17 Aug 2022 12:07:11 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id bl26-20020a05620a1a9a00b006b8e63dfffbsm15302093qkb.58.2022.08.17.12.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:07:11 -0700 (PDT)
Date:   Wed, 17 Aug 2022 15:07:09 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     huang ying <huang.ying.caritas@gmail.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, Huang Ying <ying.huang@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Message-ID: <Yv08XTRv3I5zY4M5@xz-m1.local>
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
 <Yvv/eGfi3LW8WxPZ@xz-m1.local>
 <871qtfvdlw.fsf@nvdebian.thelocal>
 <YvxWUY9eafFJ27ef@xz-m1.local>
 <87o7wjtn2g.fsf@nvdebian.thelocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87o7wjtn2g.fsf@nvdebian.thelocal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 03:41:16PM +1000, Alistair Popple wrote:
> My primary concern with batching is ensuring a CPU write after clearing
> a clean PTE but before flushing the TLB does the "right thing" (ie. faults
> if the PTE is not present).

Fair enough.  Exactly I have that same concern. But I think Nadav replied
very recently on this in the previous thread, quotting from him [1]:

  I keep not remembering this erratum correctly. IIRC, the erratum says
  that the access/dirty might be set, but it does not mean that a write is
  possible after the PTE is cleared (i.e., the dirty/access might be set on
  the non-present PTE, but the access itself would fail). So it is not an
  issue in this case - losing A/D would not impact correctness since the
  access should fail.

I don't really know whether he means this, but I really think the hardware
should behave like that or otherwise I can't see how it can go right.

Let's assume if after pte cleared the page can still be written, then
afaict ptep_clear_flush() is not safe either, because fundamentally it is
two operations happening in sequence, of: (1) ptep_get_and_clear(), and (2)
conditionally do flush_tlb_page() when needed.

If page can be written with TLB cached but without pte present, what if
some process writes to memory during step (1) and (2)?  AFAIU that's the
same question as using raw ptep_get_and_clear() and a batched tlb flush.

IOW, I don't see how a tlb batched solution can be worse than using per-pte
ptep_clear_flush().  It may enlarge the race window but fundamentally
(iiuc) they're the same thing here as long as there's no atomic way to both
"clear pte and flush tlb".

[1] https://lore.kernel.org/lkml/E37036E0-566E-40C7-AD15-720CDB003227@gmail.com/

-- 
Peter Xu

