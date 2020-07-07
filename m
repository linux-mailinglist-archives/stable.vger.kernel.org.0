Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6631021686C
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 10:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgGGIfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 04:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgGGIfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 04:35:19 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383BEC08C5DF
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 01:35:19 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h22so41757626lji.9
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 01:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VSt2gNx7u5TrD0wymr8ZWYE3yS5oRsktvc3jsQJqJl0=;
        b=MaVN0XDpN+6YXgXhI+/d1XIwktyVJq2MXzZmQphSJQiPKOhqpTZnASup4ownD/YivG
         0Wowib0FRUT5Wi7NYvSbFiCLeRfSPRu2yaXncXj7GDvA+bHhz3kXWn4UOeps5lqYW6u+
         7XVUihn894JZD3TC09c3XR3v7f5icLOgjcfSmnEMy/WMTzIAbTWpDB3ZgWuaaWbYVzp6
         HjNb5Rv19G39IONz2dp7wYJxfdKf6txXu7aLF/hrJJYXmPWcznshP9N9/chaZfeEmrdj
         81TWlSuoJrAMVyiehInhNEKw6xi6rX5yYfHCsVP191LzBSqCs+MKboOs351cGw7xNfdN
         PnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VSt2gNx7u5TrD0wymr8ZWYE3yS5oRsktvc3jsQJqJl0=;
        b=IjAD9oWEtmSt/YAjW/X4J+H6g2I47V7vYNadAFJtgRBtGuJE6UpCBvML5hJcQi3Io7
         TFIy/hRiR/n6AsRr/GZGNLITyYRyRa53fqZp+x8zp2y4Gg/Jg/god4epoFlu/InPNqV0
         yO9HjEcRikb065VGc0G9jHjg13ujA14A0ldTjECnFFnQCXfB3fVo5swTOb3xoWOB0VUT
         pYerUt2SqF1VlQQZwqfOUpt5e3kMCHUZEynHUsd2OcXJsHENilmZEWOBOQeRlIM/kvt6
         CCsi94q8us6egIUykG47uxPbtBaGpshFfKYJD0X7u5sEW2VHOqVSfEgYGl1+Y3fcb/vQ
         IYLQ==
X-Gm-Message-State: AOAM532lkGNvl5MyiBmHdOiDUvvHEi0ehWfUPkxAsCdN1dA5oN/8BIlY
        z8q6fOCfbS65uRmiCY+brqs2sFgPRZnpIg==
X-Google-Smtp-Source: ABdhPJyL8zCRmUmt9EUAMx/qZ2oMUFwZLKzoSi2UGulxyukwEAxXwTu09QNmVeVfBnsbIwB+vB638Q==
X-Received: by 2002:a2e:4b12:: with SMTP id y18mr26715115lja.117.1594110917491;
        Tue, 07 Jul 2020 01:35:17 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4609:f5ea:9102:8276:8e24:1626? ([2a00:1fa0:4609:f5ea:9102:8276:8e24:1626])
        by smtp.gmail.com with ESMTPSA id i2sm9381ljn.109.2020.07.07.01.35.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 01:35:16 -0700 (PDT)
Subject: Re: [PATCH v3] usb: gadget: function: fix missing spinlock in
 f_uac1_legacy
To:     qiang.zhang@windriver.com, balbi@kernel.org
Cc:     colin.king@canonical.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20200705124027.30011-1-qiang.zhang@windriver.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <09b2225a-d9c8-c40f-1e73-e18ece80e3bb@cogentembedded.com>
Date:   Tue, 7 Jul 2020 11:35:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705124027.30011-1-qiang.zhang@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.07.2020 15:40, qiang.zhang@windriver.com wrote:

> From: Zhang Qiang <qiang.zhang@windriver.com>
> 
> Add a missing spinlock protection for play_queue, because
> the play_queue may be destroyed when the "playback_work"
> work func and "f_audio_out_ep_complete" callback func
> operate this paly_queue at the same time.

    It's play_queue. :-)

> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
[...]

MBR, Sergei
