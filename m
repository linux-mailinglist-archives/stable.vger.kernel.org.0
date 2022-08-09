Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2758DFFC
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 21:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245728AbiHITPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 15:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345733AbiHITPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 15:15:00 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF75421814
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 12:07:59 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gk3so23840852ejb.8
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 12:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vMeWdqqUKrZihbEodx8DwkpktZOsjqJwuhJAUzg6EtM=;
        b=fsrqe+6vo9uENLGFyCV6+pgoTqjKv1mEg1PRj6og2Ud/MBa8diFjRhLhNp/FTkemmU
         vUWMlyD0tpPtsXxRgtuml1g7Ab5JSwvzh4+5oeiGYZVt4iAWoilXnit41pgP1cvRktE8
         SjaI6/b5+Nxv18jobwJDWK6xFLulMWU2a18Qs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vMeWdqqUKrZihbEodx8DwkpktZOsjqJwuhJAUzg6EtM=;
        b=0GndmqWTzBVVOkgeW1n3cxk5nvx7w9bAy8aZ5NKsAIZLeCk1DeFcWQ7Z27Wy4FguKc
         MjuBeehCDoj6a3dASBi8K/ZU1jzYZ6Lcg16mI3+ZTaGbIfE6oTdLuwwFaMzQ5zlN23C6
         SBudGALwgC0vVxdE40b/O4SgVav3/pgji0vvowsAFVp4myOSPOPM7JzTZahqAKCs5gLT
         5KJcWYYeUwH7XY0w+/Hk+oVTWUtKkxAzl/Ys2i0FIAztlAZwS6w+TupWmFYTp141gb+a
         XPQ343r/W2dsqIQQaggOVCPqXKyZtyOKVBiU/aYOtuEhu29Xw8idMByqtni49VN0yvbB
         JjtQ==
X-Gm-Message-State: ACgBeo0bMc1tIto3VSKh5EESGHohWZgu5dtw2Vp7tSFUhr4wVpkB7gr+
        1qqB+9m45c9wPUGup9c7VMZ+NXYuP6Pvtgk058c=
X-Google-Smtp-Source: AA6agR6i9mRDwgG6W44GRceHU70FM/7LsnGFvTFkUhNPbGy2lHFZ+3FbGO7IoLjeTI+xQ0AIev0XLw==
X-Received: by 2002:a17:907:94d2:b0:730:87c1:e86c with SMTP id dn18-20020a17090794d200b0073087c1e86cmr17948394ejc.129.1660072078215;
        Tue, 09 Aug 2022 12:07:58 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id da13-20020a056402176d00b00442b388c743sm132619edb.14.2022.08.09.12.07.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 12:07:51 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id s11-20020a1cf20b000000b003a52a0945e8so4505664wmc.1
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 12:07:48 -0700 (PDT)
X-Received: by 2002:a05:600c:1d94:b0:3a4:ffd9:bb4a with SMTP id
 p20-20020a05600c1d9400b003a4ffd9bb4amr16389223wms.8.1660072067208; Tue, 09
 Aug 2022 12:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com> <CAHk-=wi81ujYGP0gmyy2kDke_ExL742Lo_hLepGjCa8mS81A7w@mail.gmail.com>
 <YvKsBUuwLNlHwhnE@nvidia.com>
In-Reply-To: <YvKsBUuwLNlHwhnE@nvidia.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Aug 2022 12:07:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjh3wkhQWN8BHFUT6t52kfNMcRd+1JczD4Sgp_q11w8eA@mail.gmail.com>
Message-ID: <CAHk-=wjh3wkhQWN8BHFUT6t52kfNMcRd+1JczD4Sgp_q11w8eA@mail.gmail.com>
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 9, 2022 at 11:48 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> It is because of all this madness with COW.

Yes, yes, but we have the proper long-term pinning now with
PG_anon_exclusive, and it actually gets the pinning right not just
over COW, but even over a fork - which that early write never did.

David, I thought all of that got properly merged? Is there something
still missing?

                     Linus
