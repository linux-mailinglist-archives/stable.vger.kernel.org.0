Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B143F58E14F
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbiHIUqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343783AbiHIUpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:45:38 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146E6AE53
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 13:45:32 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bq11so18610404lfb.5
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=0Qy02k6+Ajv4Ag2mivoqOXtUuUF/P/EOzfJ1STVBz2M=;
        b=CG4Dw1M9UdPqZpV8B0sI5Fkw+fAHw9yeykPb4+HjQ5x2t6jF4FoQ1T90PopQrzs3T7
         BTLRToS9FGiKCaENH9YkBqYwuHt/P0qOdBwajxJreFpIUwgyaakUxHw2sm+eVOF3liYK
         aYKET9RkISdjZA3h9TtIFRIhmNKbirx0ITCsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0Qy02k6+Ajv4Ag2mivoqOXtUuUF/P/EOzfJ1STVBz2M=;
        b=W6HU+2gY9ealaHhV0EbstWkmXv9/an6FwjaBkCVOg00A/zmfySoDQi0zJuAS83fXhm
         HEbnijWbwroPRiTe48u0gvp47muKUJFAaQGPZs3pvmNi4OZQ+EDRcA7vX1IKGnD1W5sB
         S/UOf/nyXCcxADmJq0uViS6vY3l0dVakcuHmvsPWJ8aHebHwvFxpqMKeijmtAXCiTCfB
         wyFJ1kizTnR+SMMFSkajNB060TDJwNkNJBeZe3U6whQJm1rWI1YyosWOE71yDbY5OJuv
         UgUKE2GNgx7im9UViqQwyIeTdyKFJmcwUSA5SRS1noikeF8E3nBTyq9ceM0sHDd3mpnO
         y6/g==
X-Gm-Message-State: ACgBeo02B8FEczSA93O2jciwoVQsmOUkVXh2KdddNgGHhxs4rezqc/v6
        himBCq4PZZQ2Lcf4RWS0KOrxmAnNPcJU2+dfQxQ=
X-Google-Smtp-Source: AA6agR6Ci2ag2QzpSPLUQPrADOYeXRua8Y3WGVqZQkKwLuCUN6DnBWYdWbpz0peeiww6twGzKOrNWA==
X-Received: by 2002:a19:7717:0:b0:48a:eae8:35d with SMTP id s23-20020a197717000000b0048aeae8035dmr9077426lfc.276.1660077930090;
        Tue, 09 Aug 2022 13:45:30 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id v21-20020a2e9f55000000b0025e2ff06c19sm99149ljk.50.2022.08.09.13.45.29
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:45:29 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id r17so18535322lfm.11
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:45:29 -0700 (PDT)
X-Received: by 2002:a5d:638b:0:b0:220:6e1a:8794 with SMTP id
 p11-20020a5d638b000000b002206e1a8794mr15548804wru.193.1660077527286; Tue, 09
 Aug 2022 13:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com> <CAHk-=wgsDOz5MfYYS9mE7PvFn4kLhTFdBwXvN6HCEsw1kvJnRQ@mail.gmail.com>
 <91e18a2f-c93d-00b8-7c1b-6d8493c3b2d5@redhat.com> <CAHk-=whg0ddey-LqFAPfZJDXHMjaHJNojAV3q17yvjc6W8QRvQ@mail.gmail.com>
 <c096cc82-60b4-9e75-06ad-156461292941@redhat.com> <CAHk-=wh1q7ZSWhDWOyqmVawqjq55sUVkn8ASjE_b2VOcE1vFaA@mail.gmail.com>
In-Reply-To: <CAHk-=wh1q7ZSWhDWOyqmVawqjq55sUVkn8ASjE_b2VOcE1vFaA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Aug 2022 13:38:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi_PfZ1_8pjMmRftiq1dshheTFnctEwRt8PZMGndCisdA@mail.gmail.com>
Message-ID: <CAHk-=wi_PfZ1_8pjMmRftiq1dshheTFnctEwRt8PZMGndCisdA@mail.gmail.com>
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
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

On Tue, Aug 9, 2022 at 1:30 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And here we are, 30 years later, and it still does that, but it leaves
> the VM_MAYSHARE flag so that /proc/<pid>/maps can show that it's a
> shared mapping.

.. thinking about it, we end up still having some things that this helps.

For example, because we clear the VM_SHARED flags for read-only shared
mappings, they don't end up going through mapping_{un}map_writable(),
and don't update i_mmap_writable, and don't cause issues with
mapping_deny_writable() or mapping_writably_mapped().

So it ends up actually having random small semantic details due to
those almost three decades of history.

I'm sure there are other odd pieces like that.

                  Linus
