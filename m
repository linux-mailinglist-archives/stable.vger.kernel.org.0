Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEB221A3A3
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 17:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgGIP0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 11:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgGIP0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 11:26:03 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7C8C08C5CE;
        Thu,  9 Jul 2020 08:26:03 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e18so1121965pgn.7;
        Thu, 09 Jul 2020 08:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zQRlkY3FPDjFKt7Vs2zNz2YlolrLrYOl899D/Bt/IxE=;
        b=k/IGusbxQJs+g7kQEf1jhdWdw64YwOECTmfTVvD1FTetbKaSefM3DEvORkvat56R6o
         rCyn8UOZBPh6ONBwvwfZPBH7j6FNhycdPVFZJSDQJffKBXhKcZvLy6QGk98RDA7qADm2
         BJTTeZmmqNYdIg79OU3ZRtgUEOewjTYW7cYWzQX0kxnx5q+jJN+hxrp4H0Y9JB5kxk/J
         io6uEJ+T1ytJ+PpecrsUAe9pAvkyk6G4/Bfb/IowWRX62sY5orWF5GK7a7yPqeOJjfnl
         XTxF6IbX+BliGVmxasxh5D4qEUDVt/sL2D3pwuhXPDMK1Z0RD08rCyYDWO8N2xOpaFiY
         NUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zQRlkY3FPDjFKt7Vs2zNz2YlolrLrYOl899D/Bt/IxE=;
        b=IV5IrlE/n25vWQKmKGlqpYKzsBwWdeP6y0pAyzmRxilCqetyGj1SQWsyQhCzzXDnzZ
         aCS+g1wItEhm59OsXcvS1MJ2mxiQaFQAYrase9SEMAJ622635IaAI+yMcwB1MGaSAVVI
         ZdUl7RkOG2yMgUuQAOhvT8W8Q+5qK7deCewR6Md3XL+vKmnQp1Bsp9UUzsT2kym0b7Rt
         tP0jU+muFv4Hh0pdJhrcR4O6pgzUVSlJj7CfObf3UAIAY0GDO7SKO0jmz93NWzrLFSSt
         SkGHvdclbYOUZyPciMfLpnijUQMVQ6lLefWMydTenKH/kGPOcURWsevz3gDN4Xn66jqD
         EfvA==
X-Gm-Message-State: AOAM533X/FhgU8OYgaa8ToV7/fdUZvJIoh1QbuMJV9v6M8Gy/eCZ4Koo
        CWfUZLG5eEe7eSaMiSDt0FZ7OndttJs=
X-Google-Smtp-Source: ABdhPJxoGz/Rp1f0xZjoKdFEMZOsmhCZ7zCyd3kuKpuYLSD2iInqa5Y9o8vKWXYlHI1I8Pc3xgBLUg==
X-Received: by 2002:a63:fd44:: with SMTP id m4mr15570901pgj.160.1594308363067;
        Thu, 09 Jul 2020 08:26:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x10sm3257047pfp.144.2020.07.09.08.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 08:26:02 -0700 (PDT)
Subject: Re: [PATCH] block: fix splitting segments on boundary masks
To:     Tony Battersby <tonyb@cybernetics.com>,
        stable <stable@vger.kernel.org>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Chris Mason <clm@fb.com>, Christoph Hellwig <hch@lst.de>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Jens Axboe <axboe@kernel.dk>
References: <94114379-78f6-6465-49de-99aa5b3f4d0d@cybernetics.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <75d5014a-d991-24f8-494c-fdca95205adb@roeck-us.net>
Date:   Thu, 9 Jul 2020 08:26:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <94114379-78f6-6465-49de-99aa5b3f4d0d@cybernetics.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/9/20 7:35 AM, Tony Battersby wrote:
> Although I was not originally involved in the development of these
> patches, I recently came across them while looking over the source:
> 
> upstream commit 429120f3df2d ("block: fix splitting segments on boundary masks")
>     Cc: stable@vger.kernel.org # v5.1+
>     Fixes: dcebd755926b ("block: use bio_for_each_bvec() to compute multi-page bvec count")
> 
> upstream commit 4a2f704eb2d8 ("block: fix get_max_segment_size() overflow on 32bit arch")
>     Fixes: 429120f3df2d ("block: fix splitting segments on boundary masks")
> 
> https://www.spinics.net/lists/linux-block/msg48605.html
> https://www.spinics.net/lists/linux-block/msg48959.html
> 
> 
> The first patch mentions fixing problems with filesystem corruption, so
> it seems important, but it has never been included in any -stable
> kernel.  Is there a specific reason these patches have been excluded
> from -stable, or is it just a mistake?
> 
See here:

https://www.spinics.net/lists/stable/msg355009.html

Looks like it was queued but dropped because of the problem that
was later fixed with the patch below. Maybe it is time to revisit
and apply both patches now.

Thanks,
Guenter

> These patches would be relevant to kernel versions 5.1 - 5.4, with 5.4.y
> being the only active stable kernel series in that range.  The patches
> apply cleanly on top of 5.4.51.
> 
> Tony Battersby
> Cybernetics
> 

