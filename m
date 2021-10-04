Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BC842187F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 22:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbhJDUis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 16:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbhJDUir (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 16:38:47 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E41C061745;
        Mon,  4 Oct 2021 13:36:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id u7so15487495pfg.13;
        Mon, 04 Oct 2021 13:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2aakct6Tiywj1dmyOSpVp2RVb9X8CxstYhPbiUxOe0E=;
        b=Y9AUoHkqDDcdKo4UlYgxMiTEEbRWWGhI0EG5y+0V28GqBCBNbPhed+bqU2ZwRwbsd4
         I0XEv/dt3LWwucZnpR48Gkc4U5oLoi5bPlcMC+9f1g2WnjSraSQR0IApMsIM+ik0/dxR
         g1T9n5aljAgHc1AMzNQJQS4TK0l43q85603TEYwnUqB53Gy4eQEbu2ZnP3RgltzLUHWB
         5ZfTFZfVmb76blUxVwIZzLH1VVTNUVPDF6b7aZ8a9oQW7vUJfgI9xGSVWbysyacPzMWJ
         B6jUEHOFbWwbXImro0sj7Wxdolb8LSSKF/y2QeuoXfA3odTF1BJu162aKdAhtyWamdoZ
         FsZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2aakct6Tiywj1dmyOSpVp2RVb9X8CxstYhPbiUxOe0E=;
        b=hTiY1eTLL8BjkJXX57G7pQzAdynGmq2hCYsdUv9CxuJVS6Hw/RCE6CwnXu/thA06gs
         Ku97fQzWCmPxH5d5nuXuzHZ8DFLDYwB5KfZfVESCC2P6Vo5lOr9DCcMcIhmBk/bK/vof
         OsgafaDxyGN24bKp8YapfdVr0scLrjuZp+aEmPcMlM0BlB4Atimaklc9SP4KOUOhaSjG
         122X8QFz3pO4al4oUmvvZtIJTYkpEm4rqy84jcMDWo9h4WcA8bBTyASzlIJKoqHRqGaY
         hB2NVU8mwSQz3ee4N8me9dIQr+arkni0IpJF5iwy2TkPDvEnyOa/gn6pIy1ZFdavCrA6
         1zRw==
X-Gm-Message-State: AOAM533rZnTMr9OrZqCMuMiogqxZTpAfVpIMoHIWWjY7g1ZsxIcGnXqW
        oDS59eaUJAB1M3NEkJWUZvo=
X-Google-Smtp-Source: ABdhPJzex1KqOfmBjXdizb0YilGQcHtVTCtn9Sb61q4WRY41LJK1Z8/4a6JEFY99j8g5s/Ph3sRhew==
X-Received: by 2002:a62:445:0:b0:44c:3b5b:f680 with SMTP id 66-20020a620445000000b0044c3b5bf680mr14071267pfe.30.1633379818159;
        Mon, 04 Oct 2021 13:36:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p2sm15908309pgd.84.2021.10.04.13.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 13:36:57 -0700 (PDT)
Subject: Re: [PATCH 5.4 56/56] net: mdiobus: Fix memory leak in
 __mdiobus_register
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
References: <20211004125030.002116402@linuxfoundation.org>
 <20211004125031.778001541@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b66df5f7-e309-8826-a114-b45a3f2f7c17@gmail.com>
Date:   Mon, 4 Oct 2021 13:36:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211004125031.778001541@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 5:53 AM, Greg Kroah-Hartman wrote:
> From: Yanfei Xu <yanfei.xu@windriver.com>
> 
> commit ab609f25d19858513919369ff3d9a63c02cd9e2e upstream.
> 
> Once device_register() failed, we should call put_device() to
> decrement reference count for cleanup. Or it will cause memory
> leak.

Please also revert this change which has since been reverted upstream:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=10eff1f5788b6ffac212c254e2f3666219576889
-- 
Florian
