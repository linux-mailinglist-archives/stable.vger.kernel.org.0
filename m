Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9AB35785E
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 01:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhDGXSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 19:18:46 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:43677 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhDGXSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 19:18:44 -0400
Received: by mail-qk1-f178.google.com with SMTP id x14so371712qki.10
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 16:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2motuKeuu3J66m9xpFf2UYKnYQjOm5Hi7nool5WRAr4=;
        b=J6fI/IVU+tuliBpKbS+fhV4NBAn6AcfFXS5nV8diSx6UyxGgbKGXaEUnmGL9nom3Ar
         7kmMgBxR9C6IsCV4J0Lt2kUzqPUuKf8Y7FY0niaOUQvBoapotjtuHqEcE1+eYMfGpQMv
         WOBwagpuyN6HzDqMA26XmIOQ7xpO652GIKGh2Ed4vJKDbPK4IovXy74ZhQ6/5O2scRGk
         cmcIYSVIQaOa8mDSQXZ3yEIERa9nCKr7jMmTgUVbTtCwMmSU3UIaCjhoxlwdrwabNm6/
         GBuCR3ekZrleqRrWAjAHHFPfzN8pnPtZkKL/oyKjBd7t+MNYR4XZkgu/iCRyxGkZZW8K
         99Ww==
X-Gm-Message-State: AOAM533ic9GVP0NoQJLLGVbX5zvUVKiXKMpxWdVUwsSBsdXKYE36dXv6
        Ot8agKedfT3w5Pt+ssFNOFo=
X-Google-Smtp-Source: ABdhPJwBI7BK0ChIG/wUeYZ0oG2CRgsxTGXOpDn/MkrLgK6Fnmxc96IDhVOc8H4OFy8hIVLfT6UfDA==
X-Received: by 2002:a05:620a:13a5:: with SMTP id m5mr5572207qki.498.1617837512617;
        Wed, 07 Apr 2021 16:18:32 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:28c0:2d5a:bc28:37fa? ([2600:1700:65a0:78e0:28c0:2d5a:bc28:37fa])
        by smtp.gmail.com with ESMTPSA id b10sm19481655qkg.50.2021.04.07.16.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 16:18:32 -0700 (PDT)
Subject: Re: [PATCH stable/5.4..5.8] nvme-mpath: replace direct_make_request
 with generic_make_request
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org
References: <20210402200841.347696-1-sagi@grimberg.me>
 <YGgG2TAA9TNqM9S6@kroah.com>
 <00e36c71-9f2c-5b38-96fd-3d471382f6ac@grimberg.me>
 <20210407052806.GA18573@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a1674400-b265-6506-71cb-fd893d3f52c4@grimberg.me>
Date:   Wed, 7 Apr 2021 16:18:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210407052806.GA18573@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


>>>> Hence, we need to fix all the kernels that were before submit_bio_noacct was
>>>> introduced.
>>>
>>> Why can we not just add submit_bio_noacct to the 5.4 kernel to correct
>>> this?  What commit id is that?
>>
>> Hey Greg,
>>
>> submit_bio_noacct was applied as part of a rework by Christoph that I
>> didn't feel was suitable as a stable candidate. The commit-id is:
>> ed00aabd5eb9fb44d6aff1173234a2e911b9fead
> 
> submit_bio_noacct really is just a new name for generic_make_request,
> as the old one was horribly misleading.  So this does use
> submit_bio_noacct, just with its old name.

commit ed00aabd5eb9fb44d6aff1173234a2e911b9fead does not apply
cleanly on any of these kernels, so I think it's better to take this
small one-liner instead of trying to fit a commit that changes the
name treewide.

Greg, what is your preference? backporting
ed00aabd5eb9fb44d6aff1173234a2e911b9fead to the various kernels
or to take this isolated one?
