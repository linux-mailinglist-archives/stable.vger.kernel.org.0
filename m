Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5212B32038C
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 04:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhBTDlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 22:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhBTDla (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 22:41:30 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284F5C06178A
        for <stable@vger.kernel.org>; Fri, 19 Feb 2021 19:40:50 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d2so5341831pjs.4
        for <stable@vger.kernel.org>; Fri, 19 Feb 2021 19:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6jt3gbYErGCzVqXwrw0j1MDwi/V+DbPwPhbFBvdatBQ=;
        b=QI5McYwyk5IxzUIodb0NsvibxF0lPDxPVuLZalTge8OpQMDC12Pf3nhM9tq8NanqF9
         jSZzBKl2HVechPMkcqtaco8yMZ2iphW88WZX1sxIoQkag2lbuDMKzhamw5ifULchy/ik
         2kK3NkUDTFgJS2Yp5XSVqbsI6KDvG+GH9CYx/gGCMcclTUfC8fbpI9rwcgDMY6DpApZy
         QYg28l0P1Slc3M/6OxQA2BOzn8vepmjawRxaHVfC9n1NlkShkiX3rEQmxa/FmVeZbv9I
         m+kHaebKsh6s95fZkJM3wE1Q00ONWXhDmcsTcsjEYBNTBiWiwvbLpKBY1vSqr6TcTIst
         CElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6jt3gbYErGCzVqXwrw0j1MDwi/V+DbPwPhbFBvdatBQ=;
        b=Bv0PJeV3Aga3Un3wIzQ7Cl9GGRRp/Yfx1MHLm07taBZQ2hMDAVnzp6zQBfpzWRTjmS
         xTM8+Tf3VrF//mJCKCU1Gr1+PTdjzgnE9ZecKvatoAXQBDfEJIcB/T5P1jZyOIyg9ais
         LL+gkycTj9iX7ZLJQxY/fAvfJFxWqtqH9AXL5F0Kvv7O1wH3GeRjjWR7MPoxmR9Blza8
         FvVcy4ZjXDWen3oqFH6WaOyKlhNR0GwonM7uSwTKoG4siGalijmXjoPo8ejDrFftQBLp
         vt8S0EmDKkr5NzCFElRBD/UnML2bAU+U6RbbF/YgcWHicYuRVXVdhAdHfa6IQwvt0t9Q
         zVVQ==
X-Gm-Message-State: AOAM5330qeWi7tZH50ygqXnCljqxOX+7lQWU5GEyPl0+zx74ydlZ1Vnz
        hAZvkbO4phHMLnY/mjX9fvCPzNoERuWiBQ==
X-Google-Smtp-Source: ABdhPJyRfz7ie9+qo2jZoSEjRvqrzJTBXcAo3gAKbhmJKB0GRGOVP/0SqXAnUkUV+BF9iixr+xriEg==
X-Received: by 2002:a17:90b:224f:: with SMTP id hk15mr12194864pjb.31.1613792449316;
        Fri, 19 Feb 2021 19:40:49 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y23sm10837002pfo.50.2021.02.19.19.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 19:40:48 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: wait potential ->release() on resurrect
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1613785076.git.asml.silence@gmail.com>
 <75e1c94aff46a5bc409f50e50207f4d9a01ff9a0.1613785076.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <914848f1-f30e-4d3a-ab40-9db78e1321b7@kernel.dk>
Date:   Fri, 19 Feb 2021 20:40:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <75e1c94aff46a5bc409f50e50207f4d9a01ff9a0.1613785076.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/19/21 6:39 PM, Pavel Begunkov wrote:
> There is a short window where percpu_refs are already turned zero, but
> we try to do resurrect(). Play nicer and wait for all users to leave RCU
> section.

We need to do something better than synchronize_rcu() here, that can
take a long time on a loaded box. I'll try and think about this one.

-- 
Jens Axboe

