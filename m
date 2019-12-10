Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B493F117F51
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 06:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfLJFEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 00:04:54 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:41989 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfLJFEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 00:04:53 -0500
Received: by mail-pl1-f172.google.com with SMTP id x13so6773653plr.9
        for <stable@vger.kernel.org>; Mon, 09 Dec 2019 21:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w5Tt0Lysebe0M7lQlmlIOszNZiqffqGag4pqh1DTTKc=;
        b=ljzgP9T4D/lgTaP7SkOrWiaDE9GqJ6V2GI2q5cFavhRVL04iT4jGNn/muTKK9Wkboe
         dX6xJOOqqiPGshijeqVlmx405JjpOLyhKVEkbwtABYT6cN24ca1dTvzxrGn1QB2/vTHR
         b/p4aOcTNcAHh4+tHeByvSn0A3X3zW/vAmREuROoQDs8OfIWlb4h660SHkehBSn1ug3v
         kNJfGdM4cePzPz5Pa9R8Be7Ukdu1vA3MIzn9RENprmmlmzvH2L4Zd9djJOS7DCQRcPeo
         oNAMMcJPE9txJERZvjdIZDKt354AO/P9hqhDnVVjFHyX19CZRXQVxWt8WtIi756fdukw
         KfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w5Tt0Lysebe0M7lQlmlIOszNZiqffqGag4pqh1DTTKc=;
        b=lEYKuuoVVbxsMpa3MycRy5NBAN2fF1q46jt0eCVyH65ABpdU6gPKKUned0BZubeJmI
         IOsqCiSPqzb5sonhPF4lfJwjc1/jymk5dsP5z6Y9ZXP9PmCFHtV7XBu8f1ZyFfElFBu7
         39HPd/isytlz1v7wKsy4hABa06X7NaI8fy9wVX7PEn85zjNOdjDLqoK7qHtzvgwWA81p
         9o81b3FTU3/IUpO6QArquE85FJKtloexJmQI0G7mvQAW9D3n0Lg/0zV2SDZvToWJsf8n
         wJMPVVEh4JpVGPduoE2S4+Y67CVmVxdQ+h972yuTEuIcB0rDt4oCZKzbb4SNNGHGz0WU
         QWWw==
X-Gm-Message-State: APjAAAX4tqa96xIpaFqrVdyoYR0hy7ksaHIMtpSmy8C8QwIwlPzvxKXh
        vvNuioyeAuF84UX7E7B54l4t1YBSloU=
X-Google-Smtp-Source: APXvYqwa03MOkEo21d2LMth8ipN6oASoEbM9AtPlVBf90KSKstjZ152ZHbSqudsFAxn7pAoJdKgmXA==
X-Received: by 2002:a17:902:6a8a:: with SMTP id n10mr4981514plk.9.1575954292242;
        Mon, 09 Dec 2019 21:04:52 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1133::11c7? ([2620:10d:c090:180::240])
        by smtp.gmail.com with ESMTPSA id q11sm1237900pff.111.2019.12.09.21.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2019 21:04:50 -0800 (PST)
Subject: Re: [PATCH] block: fix "check bi_size overflow before merge"
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191209191114.17266-1-agruenba@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <de2ee79e-be07-8129-9ba6-9ec3e2bc1ab3@kernel.dk>
Date:   Mon, 9 Dec 2019 22:04:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191209191114.17266-1-agruenba@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/9/19 12:11 PM, Andreas Gruenbacher wrote:
> This partially reverts commit e3a5d8e386c3fb973fa75f2403622a8f3640ec06.
> 
> Commit e3a5d8e386c3 ("check bi_size overflow before merge") adds a bio_full
> check to __bio_try_merge_page.  This will cause __bio_try_merge_page to fail
> when the last bi_io_vec has been reached.  Instead, what we want here is only
> the bi_size overflow check.

Applied, thanks.

-- 
Jens Axboe

