Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B2A29D914
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389473AbgJ1Wnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388373AbgJ1Wm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:42:57 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3691C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:42:56 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id s17so578957qvr.11
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ghC9HLjoIKe8GXcTlT2zPn1hLazKF7pcN2u7tbbflEo=;
        b=PmSLCFJ0uoph9M7B+g+J3SSe/0c/VtZDWYJgmr6SK0mOriJHOIzoGukTlMyq5cikQT
         5u0q0XeTgrkUosfWs0x3tuTHOxyEkNRe/nRMrzlQvQ/Pr22dBDKkWmMDkalyNa+dpRFV
         jn8g27bSZmk9GbVYsIDPUJzooOtspllZY3rrxevCYzDbdJujIGdNEBL/QPeDrShGXoEd
         mqcr+yUZTDvZLbiwCJveWc8ZcGE6NI1s/eDVD+4rp5rt/XSjU/YyBndRm9psI2qNBpdb
         xHt/QOcrn60p4PbeY0ZgjUyv33+xbUbxSQqnzIfJbUYzLNYUhfOQsvg1HOr0SuPU+EIC
         SJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ghC9HLjoIKe8GXcTlT2zPn1hLazKF7pcN2u7tbbflEo=;
        b=XiNU3HJsu73nCchtMirINCz1+YCRZsRSzv5x15x6+5CCBOfFdmvjQ4Czv8budQsb40
         DaNmerbqqM+RCAlKR6Xp8GSMTzlffN4ntzsHQlnBRzrffr0098o5QYkJpdREe4ExKTz+
         OBKMnHk7Np9lzEdIk+XDhsLHij/OZnw463/rowXOGvz3XbYJeOBivm8K9SyQe8kJE5b+
         sytMT7utZEUaRWcOegL4oIpa0aWl58LoCT97AGC6xJ4wNCGRieoaoodpYaH5d59ZIgs0
         kCinPOKwgynxQQAS+f302oE1db8IgUC9v6tfk4nyP+Ym5iO6rORGNEqeTKDzpRpCwlVx
         7+YQ==
X-Gm-Message-State: AOAM531VspmDgMqcUI5P73IORZ55ed5f5N4blrZ0P2vRosdDd0qXkmZ7
        tO/GpQEVOkQ/85DErKguuHHTVfVQyjlnDQ==
X-Google-Smtp-Source: ABdhPJwHQkZP9s1t2d7caQ5+ODqg8EEAmhzubK8o5zaY2clc8hxJ46xJPYIk1LePsmSqkkghUcbAOQ==
X-Received: by 2002:a17:902:e993:b029:d6:41d8:9ca3 with SMTP id f19-20020a170902e993b02900d641d89ca3mr7761807plb.57.1603893077876;
        Wed, 28 Oct 2020 06:51:17 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::1268? ([2620:10d:c090:400::4:c0d3])
        by smtp.gmail.com with ESMTPSA id r187sm6328664pfc.137.2020.10.28.06.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 06:51:17 -0700 (PDT)
Subject: Re: [PATCH] block: advance iov_iter on bio_add_hw_page failure
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-block@vger.kernel.org
Cc:     johannes.thumshirn@wdc.com, Damien.LeMoal@wdc.com,
        stable@vger.kernel.org
References: <7e91d39fccbd06efdee40ad119833dbfeafd2fb7.1603868801.git.naohiro.aota@wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <90183284-3ecc-c276-a77f-f13eff2a39cd@kernel.dk>
Date:   Wed, 28 Oct 2020 07:51:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7e91d39fccbd06efdee40ad119833dbfeafd2fb7.1603868801.git.naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/28/20 1:25 AM, Naohiro Aota wrote:
> When the bio's size reaches max_append_sectors, bio_add_hw_page returns
> 0 then __bio_iov_append_get_pages returns -EINVAL. This is an expected
> result of building a small enough bio not to be split in the IO path.
> However, iov_iter is not advanced in this case, causing the same pages
> are filled for the bio again and again.
> 
> Fix the case by properly advancing the iov_iter for already processed
> pages.

Applied, thanks.

-- 
Jens Axboe

