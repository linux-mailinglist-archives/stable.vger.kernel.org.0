Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A481A4837B5
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 20:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbiACTri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 14:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiACTrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 14:47:37 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B078AC061761;
        Mon,  3 Jan 2022 11:47:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o63-20020a17090a0a4500b001b1c2db8145so38528861pjo.5;
        Mon, 03 Jan 2022 11:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8TCSISdRM518O+U/NvM4xqpOI+gxGUGkBzfcHgfHx+w=;
        b=et5XcC+HRUc4Mz8Nvqy8KzmglOg/APdS+2B51WSpbeP1HgH7QneYGiP833ymORiQhM
         qyjISQhobMiuGia/Vaj09q5vBsbkCZN4j75yawMBhjMu/cT09H9hoZmGCDdkKEgvaAYo
         dcL2j9fsN0iirjMbf8QjNxbJs8y7aV1rhNLEw5kNB+qwCrJVWj2ZHQEdnIFukHz/ncjN
         U52LmLTWQrAgJyiNE+13MhUx/EEeWBfhR+o77mM7R1+6Xcd5F2Bu8/8Lsu1qsSZ3ikfj
         9Z6w2OC6xaME5Za8dFjLOKEGPQoECfDz7fAObES3aXW8Q8imi2s1YedtCZyUu6NE9FaP
         gMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8TCSISdRM518O+U/NvM4xqpOI+gxGUGkBzfcHgfHx+w=;
        b=Vb/iCHIm4mfRvxmW6/1CqkFeiKmlkiuhUvEgaHCT4did+TRBt+hUB7mLiSmCAmo1pl
         YxPvHYAMrH0jWesCtL8ipupmN8WrZmuVE9Sp9fBVy2A6XsRXnbkvSzD7ieAFB2FQS8g6
         9DBxE18Ck/JBMUmZp9Vgkfzi+CqX4KE6XYgAjrLVIfAyYdM0vuZT9gSkyQxI01m54unC
         hrYY5z/RCnTCPKUdQnQKpsWJfRGV+wT1iCCA0vUChRECwLRh2QLmLjUQC0DMYBds6lji
         2S7qsJ0Y+4GLGYsUTcsy7XnvRU1s7kaDVsvW1XHbEet8EGv7fkPupkyw5MiRcBPFWQZm
         duXQ==
X-Gm-Message-State: AOAM530yy1ucwvTNOrBpR3ojhYUKQVT4BTfW+d5ud8t+L/TV3cwk1gPZ
        w38VLD1GkLnlSDmQFiVSJhs=
X-Google-Smtp-Source: ABdhPJxaDfxvBexGLdnzvSAYMXR+QBMe3WvFZARyantOYfMhoQSfzbqXqVIOsAN1pPHInwO9OM9GNA==
X-Received: by 2002:a17:902:f68b:b0:148:a923:6d3 with SMTP id l11-20020a170902f68b00b00148a92306d3mr45721201plg.97.1641239257187;
        Mon, 03 Jan 2022 11:47:37 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id v70sm31979117pgd.91.2022.01.03.11.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 11:47:36 -0800 (PST)
Message-ID: <61f06784-722e-cbf3-aab3-009d300e236f@gmail.com>
Date:   Mon, 3 Jan 2022 11:47:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 5.15 28/73] net: phy: fixed_phy: Fix NULL vs IS_ERR()
 checking in __fixed_phy_register
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20220103142056.911344037@linuxfoundation.org>
 <20220103142057.816768294@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220103142057.816768294@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/3/2022 6:23 AM, Greg Kroah-Hartman wrote:
> From: Miaoqian Lin <linmq006@gmail.com>
> 
> [ Upstream commit b45396afa4177f2b1ddfeff7185da733fade1dc3 ]
> 
> The fixed_phy_get_gpiod function() returns NULL, it doesn't return error
> pointers, using NULL checking to fix this.i
> 
> Fixes: 5468e82f7034 ("net: phy: fixed-phy: Drop GPIO from fixed_phy_add()")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Link: https://lore.kernel.org/r/20211224021500.10362-1-linmq006@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Same as 5.4 and 5.10, this patch causes a regression on 5.15 as well and 
should be dropped. Since this is also affecting Linus' master a revert 
of that changes has been submitted to the net/master tree and should 
reach Linus' tree shortly assuming it gets applied:

https://lore.kernel.org/lkml/20220103193453.1214961-1-f.fainelli@gmail.com/

Thank you
-- 
Florian
