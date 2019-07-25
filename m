Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D08A74F78
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 15:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbfGYN3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 09:29:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52882 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387483AbfGYN3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 09:29:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id s3so45004261wms.2
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 06:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tU8YjTmFbALUAn/qrmdPvLulIsSkzB2d5vOtzmfY2Rs=;
        b=QSmEwdLe+YhZkcsz6o4ys0tAUbny3GwZMtN99XRXmdJW1iCZ+Vf5w/In+CBSdd0gHg
         vibClHZKjsQ5r9p6HBHE/H/GgOJk2X6+elUIbON0QW6rgTxwJvqUGQ9yHbtra0efGoNs
         W83ucOFD+C4dzQ7oUHIVDBhfdDQb4we0p+KDsHMlSnYg72/tUWMX3ZZTFsDnQKSagzp3
         /5fqCWCWSPGPtFoHuE2tk0wdqTt2RTmL6SBUIE6hAPQblRStbcdtARk/9JRhp/aOg+/a
         4Mb5/Tq5DHwFlXZrrC18XGiypTMQhfqfVm5Dbu5ShEOWmhs5SWISOep78td+xziV4xUO
         CVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tU8YjTmFbALUAn/qrmdPvLulIsSkzB2d5vOtzmfY2Rs=;
        b=srpJwCfho4kmqdXYMf+/H/rTSUM0JsMPBhUMzuEEYGqm7KKgd4+dmmGJTPQAM6fhwc
         kD+AnRisMLmAhxSjT1ti38jbrNY5W7V+rceAfmELBvqE4Ygj2imCsYBXF8S2KF/cBkFt
         Jjy4alnbZaGBbBUatJvUtWHWH0QeuLFKK/axURiVvWE4iSsgBMCN6eTQ9hw6pVbxMaxG
         lqgGvYkXvtwFypwysDsX5sxGjZuY8NgFAiaiw+YT8MZvxr5pDDX7AEbgEmMnobjgcl6A
         NTyz7WJLMWN3I0yKxZBShI8KR6UBultnzt+FpoE6tC4iu9LjDdBRhZ3eraV1baZ8MH87
         Gy/g==
X-Gm-Message-State: APjAAAXqnxr3FQLF/fdTwoyGpnJprwdTjs7ohHSwD7KTRaSIMtUsVC5s
        3/DfiCXKjH14P3XXrbXAwGGENWhKKQ0=
X-Google-Smtp-Source: APXvYqxLCUPCepcCny7CzWoDDk1ywAgVa3CW+UD6K7NsIV9sI+XkHhXJ84YGrnyVi4MvfOP3KuSWxQ==
X-Received: by 2002:a05:600c:20c1:: with SMTP id y1mr82394008wmm.10.1564061386852;
        Thu, 25 Jul 2019 06:29:46 -0700 (PDT)
Received: from [192.168.112.17] (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id t13sm61665737wrr.0.2019.07.25.06.29.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 06:29:45 -0700 (PDT)
Subject: Re: [PATCH 2/7] can: rcar_canfd: fix possible IRQ storm on high load
To:     Sasha Levin <sashal@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        linux-stable <stable@vger.kernel.org>
References: <20190724130322.31702-3-mkl@pengutronix.de>
 <20190724210328.D91DF21873@mail.kernel.org>
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Message-ID: <6b23b091-92d1-b05d-b451-d8c78a990ef3@cogentembedded.com>
Date:   Thu, 25 Jul 2019 16:29:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724210328.D91DF21873@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

I don't know.
Maintainer did not respond, nor to original send nor to resend.
