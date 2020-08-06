Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1772A23E458
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 01:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725272AbgHFXYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 19:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgHFXYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 19:24:45 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6052C061575
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 16:24:44 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id j21so9051903pgi.9
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 16:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lK7x+vwxMeuJFEw2ruixPitn0YTbrsLBJ6zzrFpBnqk=;
        b=qRsKkp7qNam1R5lzmtSdTptoAf4IX1JfxfPmN03ggD5qvlkRWmgea59yd05XIBb8nT
         aqwODd6vNsJxMTo8Wdzh3hShdKW5xOM95u8qInN4Smr3S2BOHm1OZ2NdsKx3iHBvx5xZ
         OutjneOleDB6SQIx9XlS4Ol6C/4/tzfM/bZRKjap4Bg9f/7G8SVP1TMPr2Yn8J0Zmf+9
         Vl6mV3o7DkHEnqxl3zK5RsXKbAE/dm0geirH6MZwfheg/fUMHG3w97mBXUhWisVn4tQw
         v5rupIqu2wdc0aS6TVgyZk4M7PCMMaSxvkeM498Yzpe9zIt8VhjP/OEQkbu6CyVrH09j
         27Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lK7x+vwxMeuJFEw2ruixPitn0YTbrsLBJ6zzrFpBnqk=;
        b=op6HtI66KF7oPpykZmF/4IJhfjjj51kL7gMAQ3h5pPHifaj4u6fKq05OwKpmdTYm96
         MAoxKCCv5Ra8me4Ga4bZpHCNTlaI0FvhDX0pNgcEu6f1C1Tva3YoWhhyuPd1sAz8fhKu
         yycuQ29DN5nvLr7yYwKwO89BIawKHGU6/+2rcAlzPH8XExJSd61ynjeTBglwm8DoPx3S
         I8sYFDYmYvhRI1h/FxtG/mtO3nOF7DtUGoA6DCPzFwUTfyShI6pEJSPCtlmPUgQRgNax
         fkaijqOkDR2DemtJMhbV+TmOz9DyBttiRNcGJPlg9t1teKaB/9v20dYeJeQrmi0NAqM2
         uV1g==
X-Gm-Message-State: AOAM532V64SNEXMJxnjTjjWmDl1F08JafDIDAcyyZ5uDKaMRzvlyfyeJ
        et74/pzpzX6RlL/tXQnG0x4cW+OqNnI=
X-Google-Smtp-Source: ABdhPJyZF73gOuhGjuaZJ69at5KH1ohOhOCoAdVuYkRquHBcGbm23TGYZ/laNVplOIbLjLWNzttAIQ==
X-Received: by 2002:a63:df10:: with SMTP id u16mr9578007pgg.437.1596756283803;
        Thu, 06 Aug 2020 16:24:43 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f27sm9486241pfk.217.2020.08.06.16.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 16:24:43 -0700 (PDT)
Subject: Re: [PATCH] block: fix get_max_io_size()
To:     Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org
Cc:     Eric Deal <eric.deal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org
References: <20200806215837.3968445-1-kbusch@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b9c7c3ff-a8c8-75fc-4abd-38a67dc41f35@kernel.dk>
Date:   Thu, 6 Aug 2020 17:24:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806215837.3968445-1-kbusch@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/6/20 3:58 PM, Keith Busch wrote:
> A previous commit aligning splits to physical block sizes inadvertently
> modified one return case such that that it now returns 0 length splits
> when the number of sectors doesn't exceed the physical offset. This
> later hits a BUG in bio_split(). Restore the previous working behavior.

Yikes! I wonder how that lived so long... Applied.

-- 
Jens Axboe

