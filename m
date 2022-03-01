Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A774C8061
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 02:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiCABeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 20:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiCABeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 20:34:10 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AC8DE9F
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 17:33:30 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id m22so12787823pja.0
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 17:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NaadvPMa25t1RkyJRwMKJt7kQ0gC9B2p2VncdA9zhwA=;
        b=UzfTiaRZqrJE9o6eJQ6gBSpDNGon8tZYggoJT7R6J//ySrv/WoORrDT7895OrnVStl
         TYMTtOuFZJF8qdwzzz40d4lpu6jfewy30Lu0AtZbKWEk/Weq8LG0cSDOIlg2D+q0Njhd
         NgV3mOBzB8HwS2tQ02FbMYjRYlJxgB0HJgtPGFhybZDOIwZNiti2Fube+JVR4G2nv3RB
         xPvRis6U3TZ1j6qUfih95KHsx+xhzuvoMUnLxro58++knyQZHOb287W/uxaN1ahzzeCl
         pApShq911YLD+dB2b/MaPi4NaGNYwoT4XRUYLxu8CjFqbOK0IkzG5/d/qd40FnQTcCkH
         GWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NaadvPMa25t1RkyJRwMKJt7kQ0gC9B2p2VncdA9zhwA=;
        b=rtkAThGorFSiP8QbZ270bu2EzL4v462bWyUQvwQOefo7pZ9XmDPBylNH25QLfM2le+
         YIoutkg+v6ndVZTfNU9bBmGpjgmwVJr3v5BNjEdr0gJp4Zc/yR4vX2evhZystaIcppmR
         sTx6tlAAghHMVyqbXUXFvD7dKppL/W5pBDmCuJYkNoEf69T7rTbAmQmNiSyrQD/YmpYl
         N0T6++lAMaLNaYl0rG6z9BNLf9DxcSfxzuRssqqvdCcouzlsjrPGb0jtnkGgaj10pkSK
         mrIJnhU2INGwyycwKs8VnSfQIP232TqAmpvWJNY3qIIbHOMIrGuDS5Ntc3vAilNUnZj5
         U+Cw==
X-Gm-Message-State: AOAM533Zu0IbLpkGkqDiFHE/rYkGE0oI0XPJmVl5tdSiqQxA0MuUyHhi
        bOYSo3BZGadJoSF19jdgoRCFzCvEEnkuzmId
X-Google-Smtp-Source: ABdhPJxT0I9s3r0MDKpD7H4xDgPclnWUzRA1Rk6EBPXnU0j7exfryR88pBibjteKSAYtOribETVfNw==
X-Received: by 2002:a17:90b:3145:b0:1bc:5855:f94d with SMTP id ip5-20020a17090b314500b001bc5855f94dmr19445418pjb.55.1646098410496;
        Mon, 28 Feb 2022 17:33:30 -0800 (PST)
Received: from [10.11.37.162] ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id t11-20020a056a00138b00b004f1343f915dsm15369699pfg.33.2022.02.28.17.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 17:33:30 -0800 (PST)
Message-ID: <a4cc25a6-c6a7-37d6-d889-ddd80b2d8a44@gmail.com>
Date:   Tue, 1 Mar 2022 09:33:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [stable] usb: gadget: Fix potential use-after-free
Content-Language: en-US
To:     Ben Hutchings <ben@decadent.org.uk>,
        stable <stable@vger.kernel.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>
References: <a4e0a5446a231fd67d1881d68047920918f1be65.camel@decadent.org.uk>
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <a4e0a5446a231fd67d1881d68047920918f1be65.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All right. I will do that.

Thanks.

On 2022/3/1 02:47, Ben Hutchings wrote:
> Please pick these two commits for all stable branches:
> 
> commit 89f3594d0de58e8a57d92d497dea9fee3d4b9cda
> Author: Hangyu Hua <hbh25y@gmail.com>
> Date:   Sat Jan 1 01:21:37 2022 +0800
>   
>      usb: gadget: don't release an existing dev->buf
>   
> commit 501e38a5531efbd77d5c73c0ba838a889bfc1d74
> Author: Hangyu Hua <hbh25y@gmail.com>
> Date:   Sat Jan 1 01:21:38 2022 +0800
>   
>      usb: gadget: clear related members when goto fail
> 
> Ben.
> 
