Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3F258DF91
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244961AbiHIS5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348108AbiHISzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:55:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965F929818
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 11:27:41 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w3so16245675edc.2
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 11:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=IqVJxNw31cQs7x7vLdkBRYf56RsQMoz2IVQHanq9IpQ=;
        b=Mz533wEeIainxieri2T6/kLUzCHS1auwXeNqVpxcKibNIUElVoN7j622ZmbeuctLhd
         KBlwbRp7UoBAFyt0TTzfk3cDg+OeRcIEIG0mzz8D+bQ7jO9T8t+YG3zq/ICdBPoLblhS
         ZDLr2rEu0YOmG869ckXDpRM0fDbJcMqjQwIh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=IqVJxNw31cQs7x7vLdkBRYf56RsQMoz2IVQHanq9IpQ=;
        b=W5+0MN3KjZtzeu5etZpCA3Kjf6nWZh/FIximxeDPaIyfc+KEjDc2c9hkHYWxYMf0p4
         5mIQ4pxjG/sOihO6YqLqVYpi2UgHNNqLCs/QkMkqIxRaKd9UmH0b2iKWPbDcLMdIGoQH
         9/XxL25vqlLyQz9kTmjh31gsmTQz9DXzyqGb24ZqzxFCxFM/RcI/TLqSQaLOZ6wyXpwY
         n30ziUExafJKjvkzy2rYxdYw5Vd6HK3G6wowx+ANoQuckYpUwODNHU9nEp/WUHr/jDSf
         JU6tfL/nJMQ6AAVqD2jvZjmtAlMd8bNWfPibbaIgmPmwL9JNBREfNNCrtsx8dvOElF6s
         v4hw==
X-Gm-Message-State: ACgBeo0pZonY7lVywiWJGGbikgb5JpFwxfIJSWGc6NviuuFQWACI75gv
        qR0upSotnHNTGZqvL2HiYT4SOKnD+Yo396yS
X-Google-Smtp-Source: AA6agR7YTCBX4MgwkCSKmn0fLHp92t0DlqIS0jXalihjd1j7wWvUBkNU+Vy+HK888c8ZbHdxLAaXoQ==
X-Received: by 2002:a05:6402:1703:b0:43c:c03a:db3d with SMTP id y3-20020a056402170300b0043cc03adb3dmr22949400edu.384.1660069659946;
        Tue, 09 Aug 2022 11:27:39 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id lb11-20020a170907784b00b00722bc0aa9e3sm1354276ejc.162.2022.08.09.11.27.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 11:27:38 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id j1so15273254wrw.1
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 11:27:38 -0700 (PDT)
X-Received: by 2002:a05:6000:1888:b0:222:ca41:dc26 with SMTP id
 a8-20020a056000188800b00222ca41dc26mr6957079wri.442.1660069658303; Tue, 09
 Aug 2022 11:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com>
In-Reply-To: <20220808073232.8808-1-david@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Aug 2022 11:27:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
Message-ID: <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
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

I'm still reading through this, but

 STOP DOING THIS

On Mon, Aug 8, 2022 at 12:32 AM David Hildenbrand <david@redhat.com> wrote:
>
> +       VM_BUG_ON(!is_cow_mapping(vma->vm_flags));

Using BUG_ON() for debugging is simply not ok.

And saying "but it's just a VM_BUG_ON()" does not change *anything*.
At least Fedora enables that unconditionally for normal people, it is
not some kind of "only VM people do this".

Really. BUG_ON() IS NOT FOR DEBUGGING.

Stop it. Now.

If you have a condition that must not happen, you either write that
condition into the code, or - if you are convinced it cannot happen -
you make it a WARN_ON_ONCE() so that people can report it to you.

The BUG_ON() will just make the machine die.

And for the facebooks and googles of the world, the WARN_ON() will be
sufficient.

               Linus
