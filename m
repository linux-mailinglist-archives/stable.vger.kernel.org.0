Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D876E8C63
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 17:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390165AbfJ2QGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 12:06:37 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39818 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390135AbfJ2QGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 12:06:37 -0400
Received: by mail-io1-f68.google.com with SMTP id 18so8393378ion.6
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 09:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+utE3snHjXOyPjrpOKP0pRsXJnsUoGdnws0dyhZI7Bg=;
        b=tsaFlvuYOiErGpdimgffBwEkX/NogEExK2XUltwdHuRN+WKOhYVRAUJswAiM9TJdTk
         NjHyT7GLNzehciW/K39qjQhk206JwvZe0brs72bIvTa3l1MRtrZi8kpHdr+pDDC4PKst
         EVWcw+/sXy9JUL8ir4kNGinQhBZIUioEkL/HpONfId0psnTHHNRqgGEtFMy5BK2gc0cC
         txjVPiHwDXR1do1U4AfsUDtYmBU5uzSl1uCYpin6NNvZvqyOeamZux35ZPzWUpFEuCCv
         B+OAJIb2LjFd8by+EyTWyB8itIEE/ExR4xr4zxXeZAELIhUNFit2Q19JT/zbiudiA3dV
         W+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+utE3snHjXOyPjrpOKP0pRsXJnsUoGdnws0dyhZI7Bg=;
        b=sVSgawWjO+JxZJDRxRRu6BvtABhsB+KyjajQ3AS/DWglB8WEwMXC7aSuJQRdpwb9df
         T87WjpgGS/66Dn1M2oy2T5o21VG9vVEexpjuZrM8xxx5f0fYpJzl0LH8Hw/3pxCwccuh
         DDwgPDismSuPn2f3aJp24yAyyGmAvqDBp2ITh9tyQaVYPyZ9/ghNtm0ylM7jZ5v4hXR+
         3vsKHcg3nHBVqG1IOvxaBlp3KZwL2uj+ghUajDUI9ZPRJgd6HaQhHD8/PN2WQVxIchxU
         j+xYKNwsqS4F0dFEV3obz33onj5IVBWcl+hON15Z3lX8prBbIxHsoP5MyqZLxKROATzb
         v/Ag==
X-Gm-Message-State: APjAAAUS0iuc67enNEagkAvzuhb7duuCxOjwl8eS6wukIZhRKECTJRWn
        eDzVGqvIxCGjQeAFnnJCjK4B2l5BWcc0Vg==
X-Google-Smtp-Source: APXvYqz7VI797G+c4O/NejxfIo0ojnsG23gfPrsA93QxVEFq06d72OD6/cf42FH4xgAAyraA75tzJQ==
X-Received: by 2002:a6b:e015:: with SMTP id z21mr4473959iog.51.1572365194793;
        Tue, 29 Oct 2019 09:06:34 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g79sm2035797ilf.14.2019.10.29.09.06.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 09:06:33 -0700 (PDT)
Subject: Re: [PATCH v2] um: Entrust re-queue to the upper layers
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        linux-um@lists.infradead.org
Cc:     richard@nod.at, rrs@researchut.com, hch@lst.de,
        stable@vger.kernel.org
References: <20191029091334.3095-1-anton.ivanov@cambridgegreys.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <71002768-3887-5af1-5dd3-7e691aa3f656@kernel.dk>
Date:   Tue, 29 Oct 2019 10:06:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029091334.3095-1-anton.ivanov@cambridgegreys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/29/19 3:13 AM, Anton Ivanov wrote:
> Fixes crashes due to ubd requeue logic conflicting with the block-mq
> logic. Crash is reproducible in 5.0 - 5.3.
> 
> Fixes: 53766defb8c860a47e2a965f5b4b05ed2848e2d0
> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

I can pick this one up, I'll fix up the Fixes and stable stuff too.

-- 
Jens Axboe

