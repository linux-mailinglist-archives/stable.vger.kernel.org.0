Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8538D25B33C
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 19:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgIBRzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 13:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgIBRzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 13:55:19 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DFFC061245
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 10:55:18 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z25so6732663iol.10
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 10:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lF4pWhsByTOqyLOv5Bpsnjv77SPv18a7OvunkXhgK6g=;
        b=QZwigp9rDr7WwPU/I1qts5FEAk31WkqDNDl8N+DvmtO2nQx96vJeTzuFumkhiOBQkd
         WKdGpg1Q/loZr6Kd20KwOSbKfa09huVjkEz+HjFtFxdkd7vP/XhEY3mAMCT+4hgEaMNU
         fQ05n1cD9A/6dqL5TCY4CIWdCXrKB33hP9ys1eguvw5U4QzsPatrjXO+hRQ+/IKI6wnC
         xbRTWOuga0s9JGaGms7n7S+GRWQKjvWmasMgqRlBSg9iP47FORwWJJKUTdRkvs6hjap7
         jIhKiR2GVHEGY9YvGhgDJ7nNADwhMV1IUdI1oRNMcU1NUTBpL92rqpJIegcI1c91483A
         WzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lF4pWhsByTOqyLOv5Bpsnjv77SPv18a7OvunkXhgK6g=;
        b=gxWCtOz+RNfyOUcT/buUKemUTCN95d+1RyPPXybfAUqhJcHp4rh1T0H+b7+CSgjPVP
         E0UIm94XZx0mpeCnp831Yyqa6wa5/bAJveLojZ+D11zUH33f7dVamOuHKPNg7xjrndbG
         ESefl7Djt2bjXEbpyEmHgqHp0wfl4GEVd+ZNyhbjAOgJClFiY4jv8xcY5eLZIRaevONV
         rdgMOHoR4XH8ppVQxYUcqAbGCNbJiXz4AzmzLfYM0dh9PnvbhV6iAM8/7UfgmXtraJrT
         Rxh6u3fufOtCoMAdZkS5lHk/ts9XmRDzZV6XB+eIR8wqK8NSYyIV/BNyyw5/ks/KFL8b
         quiw==
X-Gm-Message-State: AOAM5317ZvN9Gm/1Fgrtt6HWa8rDASvkiv6GHnllG1wGkqn5acio9dVH
        RLFi3qs+uUxYSqu4QLLx/9dsS8xt+jXRwMUt
X-Google-Smtp-Source: ABdhPJypzj6dCXiSRVbMCqcI0gl9vjF/pJGbjYaoT1JJlIicw1aUuWkEtaw2iUzf3mJ52pOGevMZTA==
X-Received: by 2002:a05:6638:69d:: with SMTP id i29mr4340471jab.138.1599069317884;
        Wed, 02 Sep 2020 10:55:17 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p124sm126225iof.19.2020.09.02.10.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 10:55:17 -0700 (PDT)
Subject: Re: [PATCH V2] block: allow for_each_bvec to support zero len bvec
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org,
        syzbot <syzbot+61acc40a49a3e46e25ea@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org
References: <20200817100055.2495905-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fd90b22f-dd5f-15ef-2a9b-648a3260cea7@kernel.dk>
Date:   Wed, 2 Sep 2020 11:55:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817100055.2495905-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 4:00 AM, Ming Lei wrote:
> Block layer usually doesn't support or allow zero-length bvec. Since
> commit 1bdc76aea115 ("iov_iter: use bvec iterator to implement
> iterate_bvec()"), iterate_bvec() switches to bvec iterator. However,
> Al mentioned that 'Zero-length segments are not disallowed' in iov_iter.
> 
> Fixes for_each_bvec() so that it can move on after seeing one zero
> length bvec.

Applied, thanks.

-- 
Jens Axboe

