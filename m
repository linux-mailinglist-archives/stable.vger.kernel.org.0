Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504C14E59AF
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 21:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344589AbiCWUP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 16:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344579AbiCWUPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 16:15:55 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3F78C7CE;
        Wed, 23 Mar 2022 13:14:23 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id yy13so5133807ejb.2;
        Wed, 23 Mar 2022 13:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vUP+cDU6A63BiCB5No7G9vTRFHC0WfO/ACql60JcDZ4=;
        b=Uymv0AnoffsesJkU/vB9EPFV7fHYvGysg0Ebp/hmGaGcs6n+SDrkBCEUVrNzstO3p0
         UgO0DcN9wZbez+Hd3bwRws4pny+z1IFrCXCn2K5+9JLzjH41IKgErmKFEfsgguuDcf47
         sXzlTEEDDaq6O1vNaBDHlNz5JVPzPXw/XIQLM4ujqjpLh1f7yM6fy+lroM4mvovC3tkM
         Cv/w/9imHIyQzEcJbZbvzReuVDIKceP3f3dPhsRbGtAAlfTYTRbbWT/uVSA1gD6CHXe+
         aCfcEMXG4SSzTBlZzjCSgKZrTlZPXBsmAziS3rbtUWTG46kmU1j109pWCxG5vn/mhokm
         wMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vUP+cDU6A63BiCB5No7G9vTRFHC0WfO/ACql60JcDZ4=;
        b=dFl2nH9MPt5cWvTo2+AFRHkPuW/Mu2Ndm+nw3rtqtV7JHlVj8X1gUgFm75zP79KyhX
         y/lWu4hGCO/rVGeuMgXZAO5RWE2DDlWUdFKd+1kr93JLDSJZO7wIiGzid034zWqRgVK8
         XudYWnwrxRNA0Lojj/qOHFqUObro0U9lTXePo3WvTdldaIBOZQrw37LqQfRcraXiufaP
         /g8zLmOHiaGatI0xDheY6lF45Hfnlk+2aeT1MrYvmqVEU5QxagfikTxztFYaza9DQanG
         ZN1WEKka9pQwmtzuplFLWFT5rRbzFKlCdnXsIZ1bZVgyfY6iqskvbI60HWxtZYlQjV1f
         ua+w==
X-Gm-Message-State: AOAM531cWeTKUjLnDAVWcW7/kK4ZtfJWuG8+Ti+peZZVzvwm2JNa3Mqg
        Th9qTG1ifder6NULanJT5Gg=
X-Google-Smtp-Source: ABdhPJy8/R1UwCohZhHy/oCfb9hBRA6tKwPHZexu/TtgXp3lESESoLy43PqmzjFrzUyKiXKNI239zA==
X-Received: by 2002:a17:906:30d1:b0:6cf:c116:c9d3 with SMTP id b17-20020a17090630d100b006cfc116c9d3mr1850615ejb.245.1648066461644;
        Wed, 23 Mar 2022 13:14:21 -0700 (PDT)
Received: from [192.168.1.114] ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id x12-20020a50d9cc000000b0040f70fe78f3sm424439edj.36.2022.03.23.13.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 13:14:21 -0700 (PDT)
Message-ID: <64197456-87f2-e780-186d-272e06ae223b@gmail.com>
Date:   Wed, 23 Mar 2022 20:13:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL
 correctly
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com, stable@vger.kernel.org
References: <20220323153947.142692-1-axboe@kernel.dk>
 <20220323153947.142692-2-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220323153947.142692-2-axboe@kernel.dk>
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

On 3/23/22 15:39, Jens Axboe wrote:
> We currently don't attempt to get the full asked for length even if
> MSG_WAITALL is set, if we get a partial receive. If we do see a partial
> receive, then just note how many bytes we did and return -EAGAIN to
> get it retried.
> 
> The iov is advanced appropriately for the vector based case, and we
> manually bump the buffer and remainder for the non-vector case.

How datagrams work with MSG_WAITALL? I highly doubt it coalesces 2+
packets to satisfy the length requirement (e.g. because it may move
the address back into the userspace). I'm mainly afraid about
breaking io_uring users who are using the flag just to fail links
when there is not enough data in a packet.

-- 
Pavel Begunkov
