Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C5D647B8
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 16:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfGJOAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 10:00:44 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33131 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbfGJOAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 10:00:44 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so4974531iog.0
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 07:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uLDn6FoYIxeReECmo+TpeGDmidMAcbRcZrkscc5kAsA=;
        b=yBfEFr7yxFpc6DuLLhXX1DAnqM9459BahEd2QCdjUtR5LTkk0OkpSWz/fNDJPqZ4Eg
         2O4/HATSD/igFfddXASCAJVmsldwe8lNWqsG4hIrcHXjj/bwIQNoaI/EbRDHZs/qAIHn
         G1FGuLdmry9IhxGlnOHoqXumoDhViWnwqstnQuBBJ12fpcr88XR5UMkm1KEpBBbAp1JI
         xsZ7c6DcoArYJqldQY38wvwrnxUe9hdruIqxrAEUMgCSXGFcGoOFvcK8KnPAciKrOB0z
         AzPwRKYSRI70y3/eNOrDzmV936ihA+a11hwpyy1kfkjhTJPO/FSBfYuA/jiqpbVNU1gI
         IcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uLDn6FoYIxeReECmo+TpeGDmidMAcbRcZrkscc5kAsA=;
        b=Tv18DZUVfDSVsyYu2++k/VixF3jjK9Q4L1VL5qIWQak6OGW1xH3x3H3BDUIebYM/vx
         +/J90P9JlS/ovQtiXjs3zZILvTCdkA92VUiTY0idzLtdF/jyRTUDnJI84ZUQaAZG4Etb
         wGDV9RQcjN1itQR/s0Vt5CbCYxgZLGMtqbFQZKUUluRrusNdR4L2qtOpPpnjcMq72xoP
         LQnEcIrfKd/AASvS6Ze0NeOqeKRYOdr/gpySXE7quO4RJFN6erJysAdS2uAqb52uqvqm
         I6HUQ8px3mUGCk7Rx3m8U2cMgTDgEKIhBmE7BrPPvzP/FclnNAcVygmlKJ2zJ1sAY4b8
         6o+g==
X-Gm-Message-State: APjAAAXVpGJgx3EWm12qRFPKZ7QOHlYGRfTU0stMZUh7/NDpIrHman/X
        fUfqMYzxx6kdc1CoIIylaYEyITYgtHrcaQ==
X-Google-Smtp-Source: APXvYqy7gIMHIZKeU3ZjEjuVffpS1YJvkAOw7HV+TgJseYlld/VwQmsqw+3UihClAvATVA1ZPifRlw==
X-Received: by 2002:a6b:ed02:: with SMTP id n2mr18863623iog.131.1562767242821;
        Wed, 10 Jul 2019 07:00:42 -0700 (PDT)
Received: from [192.168.1.158] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t133sm3887077iof.21.2019.07.10.07.00.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 07:00:41 -0700 (PDT)
Subject: Re: [PATCH] blk-throttle: fix zero wait time for iops throttled group
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Liu Bo <bo.liu@linux.alibaba.com>, stable@vger.kernel.org
References: <156259979778.2486.6296077059654653057.stgit@buzz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <30caacb5-4d45-016b-a97d-db8b37010218@kernel.dk>
Date:   Wed, 10 Jul 2019 08:00:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <156259979778.2486.6296077059654653057.stgit@buzz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/8/19 9:29 AM, Konstantin Khlebnikov wrote:
> After commit 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops
> limit is enforced") wait time could be zero even if group is throttled and
> cannot issue requests right now. As a result throtl_select_dispatch() turns
> into busy-loop under irq-safe queue spinlock.
> 
> Fix is simple: always round up target time to the next throttle slice.

Applied, thanks. In the future, please break lines at 72 chars in
commit messages, I fixed it up.

-- 
Jens Axboe

