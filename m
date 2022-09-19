Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2269F5BCAF7
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 13:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiISLmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 07:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiISLmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 07:42:45 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7036812AEB;
        Mon, 19 Sep 2022 04:42:44 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id bh13so26525764pgb.4;
        Mon, 19 Sep 2022 04:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=12fgk+jsYvG7v7iD5QGUvEAun3h93mPzfIrtFSud5yk=;
        b=f2gdwB7ToyC22kyn/wBNG/E66gJHivgNo/FFXOq15ebhULX9DutOrQLsbhu1+VQZCo
         Yt6aKj9l7HMmF6T38Y6TSWQBcEX9m6xovV+v62UY7tcc9Jk1a1t6JGPKhOownshNXehd
         +v0EEZ7gYbvFORtfBKiXyBNPr2+fr/hjEwYl/BNRNZnxogFJWRUB9tqsP6jrOz6bsQk1
         pUNBoaRULAQQhwFFCbrketPMy6YudlJ0wv2QcPFPmnLxl+LSzYq2r0639U0JGQFTO0k3
         nmwr+bm6CY3oqM3c45zKZgBYwL74hyWWnztq5xEEWjqejn9SqYkZiAjsTyJFoo7VNVCU
         fcUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=12fgk+jsYvG7v7iD5QGUvEAun3h93mPzfIrtFSud5yk=;
        b=CMy6hJTkGPK90znrvTTFlaM5DskVIgHPgk1IQeFFqn786ceVqW/BsSojuSn4LKqAmu
         5CIrFcI3Le17WgwpxFS4VtqEdc8FSwmjVP27vWC2Cs3xLYhdQLKZlkVkTXgZP8oi08/W
         EsOs5KYqt6pueDtVdH6lBzEoKcLGdcV2Falnuf0CzrhD6LMctqwWeKvfgNkgbm92ZP83
         Y3ay3HPm4rG0jxWtu6iKkbQK0/MokiU00uGGZGp4x1Wu5MXyZKxNg9do34n26BHJ5vkh
         jjwy3JTSnTaKhkM/GZHB/0A4bb4HojX8ySX8XFFtkoKIj1bQFeEckYO83eFUnCcfw85Z
         zsqQ==
X-Gm-Message-State: ACrzQf0jObRPQVvtUFYQ1+NqH5IJta8hlnK/mree/EdxqOdma88rOttz
        3ppDOvxkbxYHjCy0i0tN2Po=
X-Google-Smtp-Source: AMsMyM6kpoD2oqdXy4WNlaZYYtAcZHuKJrbF/B7xnmdAvXI+BrhTwqCTkTVgUqB4meawbHJECeRXNQ==
X-Received: by 2002:a63:470e:0:b0:438:a091:5a3b with SMTP id u14-20020a63470e000000b00438a0915a3bmr15438641pga.332.1663587763924;
        Mon, 19 Sep 2022 04:42:43 -0700 (PDT)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id d2-20020a17090abf8200b00202d1745014sm6477476pjs.31.2022.09.19.04.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 04:42:43 -0700 (PDT)
Date:   Mon, 19 Sep 2022 20:42:37 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Peter Collingbourne <pcc@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] kasan: call kasan_malloc() from __kmalloc_*track_caller()
Message-ID: <YyhVrepabvXPTKa6@hyeyoo>
References: <20220914020001.2846018-1-pcc@google.com>
 <YyF6N8uHGVrqpoDM@hyeyoo>
 <f06965ea-c7e5-3a8d-f819-64baedf75d96@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f06965ea-c7e5-3a8d-f819-64baedf75d96@suse.cz>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 16, 2022 at 07:32:50PM +0200, Vlastimil Babka wrote:
> On 9/14/22 08:52, Hyeonggon Yoo wrote:
> 
> Thanks for the Cc.
> 
> > On Tue, Sep 13, 2022 at 07:00:01PM -0700, Peter Collingbourne wrote:
> >> We were failing to call kasan_malloc() from __kmalloc_*track_caller()
> >> which was causing us to sometimes fail to produce KASAN error reports
> >> for allocations made using e.g. devm_kcalloc(), as the KASAN poison was
> >> not being initialized. Fix it.
> >>
> >> Signed-off-by: Peter Collingbourne <pcc@google.com>
> >> Cc: <stable@vger.kernel.org> # 5.15
> >> ---
> >> The same problem is being fixed upstream in:
> 
> The "upstream" here is now only in -next, not mainline yet, so we still
> have more options at this point.
> 
> >> https://lore.kernel.org/all/20220817101826.236819-6-42.hyeyoo@gmail.com/
> >> as part of a larger patch series, but this more targeted fix seems
> >> more suitable for the stable kernel. Hyeonggon, maybe you can add
> >> this patch to the start of your series and it can be picked up
> >> by the stable maintainers.
> ...
> > 
> > Ah, I should have sent it to stable team ;)
> > 
> > I think "Option 3" in Documentation/process/stable-kernel-rules.rst will be appropriate,
> > So will resend this after the series goes to Linus's tree.
> 
> I'll pick this for sending to Linus after rc6, which means the series in
> slab.git / -next will afterwards cause a trivial conflict to resolve
> when merging. AFAIK Linus prefers that over late rebasing.
> It will also make it simple for stable.

I think that is better option, thanks!

> 
> > Thank you Peter!
> > 
> 

-- 
Thanks,
Hyeonggon
