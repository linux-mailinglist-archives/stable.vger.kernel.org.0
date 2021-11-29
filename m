Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6877462545
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhK2Wh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbhK2Wgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:36:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91351C06FD53
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:16:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 553B9B815E0
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 20:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DD1C53FC7
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 20:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638217007;
        bh=0mE1uLuLHnYedsu5rbKg72/vOChysMSVEbbNMXGpN1c=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=YkGuuWUz6FY90OxQhVrW2ytxviARtvtjX1v2fpySZvV2O0N5GN/3QU+FTEc8xh4P5
         DTpGdT2vN1hRE4JMrGTU5BaRa4gH/ec4Q9E1cY1LRFNyQuRkwm5JcBHOBWwmgsxs4N
         CF2WJuGwvcKU5uWsPJWtslgR5zz9S7EHZUURZh9po75Ge0cTeqZYHNCjnlhqlssfCb
         zHI4XLC5KhW5VCT/GzWFXWci+1R8cZ1sEpFLjtB3uncQVGtCzHkm0CIf3yZ9E1hV6N
         o9foyG4TtL88KzvCSGOeZUnrXH7wrKtq2ZPUxOtB7nXyruQrWtPZKeoS9UE5VxdEqs
         EU43SqCJu4Fdg==
Received: by mail-oi1-f181.google.com with SMTP id u74so36799309oie.8
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:16:47 -0800 (PST)
X-Gm-Message-State: AOAM5330Pid8HAmvgUBnisc8ojxL2cff1RJHDFd26viv94lvcJMSzo8c
        s8qUe7zA8Ls958zrfRDYqeh6Zu004vL2DJV5K2Q=
X-Google-Smtp-Source: ABdhPJxtT4o0LwQgnAD8YuKYhl/UQSH0iKu9kNIGORhJuGk+VmX/+G2ue1roSwAYwkUQsExxN/Tql+up2xbPNCvbcMs=
X-Received: by 2002:a05:6808:a8f:: with SMTP id q15mr238844oij.65.1638217006293;
 Mon, 29 Nov 2021 12:16:46 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:428a:0:0:0:0:0 with HTTP; Mon, 29 Nov 2021 12:16:45
 -0800 (PST)
In-Reply-To: <YaTDrOHHUfcqq1NX@kroah.com>
References: <20211128130403.10297-1-linkinjeon@kernel.org> <YaTDrOHHUfcqq1NX@kroah.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 30 Nov 2021 05:16:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_6HK1TWnkckk+Qsb-70Uzea7-HJw124Pvivq9vFZQn9A@mail.gmail.com>
Message-ID: <CAKYAXd_6HK1TWnkckk+Qsb-70Uzea7-HJw124Pvivq9vFZQn9A@mail.gmail.com>
Subject: Re: [PATCH v2 BACKPORT for 5.15 stable] ksmbd: Fix an error handling
 path in 'smb2_sess_setup()'
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        stfrench@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2021-11-29 21:12 GMT+09:00, Greg KH <gregkh@linuxfoundation.org>:
> On Sun, Nov 28, 2021 at 10:04:03PM +0900, Namjae Jeon wrote:
>> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>
>> All the error handling paths of 'smb2_sess_setup()' end to 'out_err'.
>>
>> All but the new error handling path added by the commit given in the
>> Fixes
>> tag below.
>>
>> Fix this error handling path and branch to 'out_err' as well.
>>
>> Fixes: 0d994cd482ee ("ksmbd: add buffer validation in session setup")
>> Cc: stable@vger.kernel.org # v5.15
>> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> Signed-off-by: Steve French <stfrench@microsoft.com>
>> ---
>>  v2:
>>    - add missing Steve's signoff tag.
Hi Greg,
>
> What is the git id of this in Linus's tree?
Sorry for that, My mistake, This patch in Linus's tree doesn't apply
to linux-5.15.
I found out later that I hadn't copied while re-creating it.
>
> And why no signed-off-by: from you?  Please add that when doing
> backports and you have to change things.
Ah, I didn't know my signoff-by should add it. and I will do that next time :)

Thanks for your mail!
>
> thanks,
>
> greg k-h
>
