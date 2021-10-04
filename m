Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDD8421877
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 22:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhJDUhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 16:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbhJDUhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 16:37:18 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544C9C061745;
        Mon,  4 Oct 2021 13:35:29 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q201so5054540pgq.12;
        Mon, 04 Oct 2021 13:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Hr6SCmds0mN+qXhMqbY4UbDKnbBp1o2hGZuZONg7Ow=;
        b=iwCWzjN6Rrj0p4xHdSg97uzMnH46Z+QA4yQjQdu/+SiZ69Qgr5Rd1o50sIMyAHlfVM
         1KjIDB1LQt2Otik8uuAYP6X61pL4fRgADM9QpnHNHK69ykwz4BT6lT7Z0Ja7YwWzVdM7
         v0VQSrySyAI3eQbjpPv6MmQl3NrggoYLP7m4SklieCDlY+YwVbuOpFB0KlQ9uw48ivB6
         +qtYWv6QvVwmzuwOPLPDG0qaMQnGAkdlStH7W3EtEVnW7t0gr4Q3S4/S69hqWOl9BQ5G
         aeiMgbvWBxN/O8+cuByQryEMgXb8ufkS3fccYRip+rz74Wq+u5xFfBVz/Crfk4YYjJmp
         LkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Hr6SCmds0mN+qXhMqbY4UbDKnbBp1o2hGZuZONg7Ow=;
        b=aTe8vmtAeDZgCWnXMkqYLwpwxWfdsysOoFC4TX56eOzxE5t3Rbg1XwrlzpZLLa4yuR
         HWtHWsXuyZKVVVaFIfJqatVVPn8mJ6w7OJ7pEQ6FjuyGwz8U+/f9lkqkX4XMai87N9XS
         +YVwvGbVHIIjSGShPMvQAdhHfJ+EqRKf+epiHwbJeL8eGCEguirHxFIM5yT6Yl439dfI
         6NJmhcT2maxB6aswN5pzrL7ujjMb906nhlMjbUSfTkdtj5ClG/AHITaoHvlteB4RUsNz
         wAnl34LzH7cFragGtb2LK5EtHlBtRO7Sy8BDcBp1bvZZXyAMgLt7Trcg7KM/tl0ieuH9
         /Sgg==
X-Gm-Message-State: AOAM532Iebn8ZizX4gDa7QBUZbQE8GskFzO+qGRgrITCRmg/WaKXngmd
        nuqL2MjZWppz5nyZLk2MLF7yI7IOeyc=
X-Google-Smtp-Source: ABdhPJyyJnog1nyYuq/O31bj4sgAxM8vLeGPefb2g1/S/YCJwm0ij2xu/sWx4EGaBAo5JkSjBYQmUQ==
X-Received: by 2002:a05:6a00:1a4c:b0:44b:1fa6:532c with SMTP id h12-20020a056a001a4c00b0044b1fa6532cmr28168934pfv.64.1633379728842;
        Mon, 04 Oct 2021 13:35:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b10sm8964572pfl.200.2021.10.04.13.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 13:35:28 -0700 (PDT)
Subject: Re: [PATCH 4.9 57/57] net: mdiobus: Fix memory leak in
 __mdiobus_register
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
References: <20211004125028.940212411@linuxfoundation.org>
 <20211004125030.751799483@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <672dcc29-0650-222b-41fc-90a1939ac561@gmail.com>
Date:   Mon, 4 Oct 2021 13:35:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211004125030.751799483@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 5:52 AM, Greg Kroah-Hartman wrote:
> From: Yanfei Xu <yanfei.xu@windriver.com>
> 
> commit ab609f25d19858513919369ff3d9a63c02cd9e2e upstream.
> 
> Once device_register() failed, we should call put_device() to
> decrement reference count for cleanup. Or it will cause memory
> leak.

This changed has since been reverted upstream, please drop this change:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=10eff1f5788b6ffac212c254e2f3666219576889
-- 
Florian
