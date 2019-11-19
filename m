Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9C0103059
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 00:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKSXk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 18:40:58 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40716 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfKSXk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 18:40:58 -0500
Received: by mail-pj1-f66.google.com with SMTP id ep1so3335475pjb.7;
        Tue, 19 Nov 2019 15:40:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LGdI8nMvJO9Yp2V4F8P1ev7tTWwm2jfSwnW1T5/k5as=;
        b=s1Semn+6Dv5dbkdxqX9rBSd8PZOFcTn99KrRedSZLD5pyv+MYTTDWzY6ytMJ/r5UuM
         rLeZs01qmvEZH01Zf7DodcBILb1jEBoLAOctWD69HrfpcuCocCIOkwaYLwY8oohX9nuk
         YDCn1UHt8pOzeq+1szIdWkzmyf+3ZDOOXtew9rRGiaL1EcCf259izmykgt3viJTW1jdt
         5DLI6n+vgbOCy6uWwCvewCrM+Kv7XeRir/xpPhksRKCIGAzA4GPHoMyrO1FuwN9kmp9T
         mxtpaMlfWfXpE4B02sFWvlI38fZSEAIVXXb73CA1sETWB+8BUAGBIidX0YkSD/VmqiMq
         L84Q==
X-Gm-Message-State: APjAAAWwh/uKwrdkcf5MCS8GiZIT4Ib4ze0FBoeZOINvVkCsz+6oTcm7
        vVCtUIIt5NG8Nc2VjdSsJrwfZnTIatU=
X-Google-Smtp-Source: APXvYqxaqRKCdfDH6V8YoUt6s/ImovXm0GCKDyXavhCF1NO0+J23GblS0JEL8I94w3YrZSAKQMm05Q==
X-Received: by 2002:a17:90a:bd95:: with SMTP id z21mr246817pjr.10.1574206857435;
        Tue, 19 Nov 2019 15:40:57 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x192sm29727552pfd.96.2019.11.19.15.40.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 15:40:56 -0800 (PST)
Subject: Re: [PATCH v2] loop: avoid EAGAIN, if offset or block_size are
 changed
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
References: <20190518004751.18962-1-jaegeuk@kernel.org>
 <20190518005304.GA19446@jaegeuk-macbookpro.roam.corp.google.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1e1aae74-bd6b-dddb-0c88-660aac33872c@acm.org>
Date:   Tue, 19 Nov 2019 15:40:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190518005304.GA19446@jaegeuk-macbookpro.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/17/19 5:53 PM, Jaegeuk Kim wrote:
> This patch tries to avoid EAGAIN due to nrpages!=0 that was originally trying
> to drop stale pages resulting in wrong data access.
> 
> Report: https://bugs.chromium.org/p/chromium/issues/detail?id=938958#c38

Please provide a more detailed commit description. What is wrong with 
the current implementation and why is the new behavior considered the 
correct behavior?

This patch moves draining code from before the following comment to 
after that comment:

/* I/O need to be drained during transfer transition */

Is that comment still correct or should it perhaps be updated?

Thanks,

Bart.
