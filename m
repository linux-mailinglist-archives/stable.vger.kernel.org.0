Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7BB60903D
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 00:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJVWKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 18:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJVWKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 18:10:53 -0400
X-Greylist: delayed 173 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 22 Oct 2022 15:10:51 PDT
Received: from 005.lax.mailroute.net (005.lax.mailroute.net [199.89.1.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF7951A02
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 15:10:50 -0700 (PDT)
Received: from 014.lax.mailroute.net (014.lax.mailroute.net [199.89.1.17])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by 005.lax.mailroute.net (Postfix) with ESMTPS id 4MvwSb28p7z1T5Cg
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 22:07:59 +0000 (UTC)
Received: from localhost (014.lax.mailroute.net [127.0.0.1])
        by 014.lax.mailroute.net (Postfix) with ESMTP id 4MvwSY3zJKz3G089
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 22:07:57 +0000 (UTC)
X-Virus-Scanned: by MailRoute
Received: from 014.lax.mailroute.net ([199.89.1.17])
        by localhost (014.lax [127.0.0.1]) (mroute_mailscanner, port 10026)
        with LMTP id MmR9ZiqFQ45r for <stable@vger.kernel.org>;
        Sat, 22 Oct 2022 22:07:56 +0000 (UTC)
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by 014.lax.mailroute.net (Postfix) with ESMTPS id 4MvwSX396Xz3FyvD
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 22:07:56 +0000 (UTC)
Received: by mail-pf1-f200.google.com with SMTP id y143-20020a626495000000b0056bae530d80so210013pfb.9
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 15:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bKOc1pnOZSy/A6AqcGy95JxvjU+o1yN6NNR2BOFs1Zo=;
        b=Ddn4gtaMO0m1ZwWqhlz0Rtd5LhZKlNPW54fuiAwB/497j4X9LlG1DaCePl87Y5yecB
         oyHdgXacYbHvrpub6hLpwyVkpLGb6HJ0o9s4zAEjhP27Tq81vwLcjW2Pq/utPQnIoi4k
         ehp75CRydk+XTKFDqXdjw5WcUYDSdMlWD0z5Gc2ezMC8u2/dcOCmtYt32hioHcKEovKD
         eHOCT9o2gIgAoWJBvqo1SIIGXSfQjYbCyhHl+Ni6e1Rf0Pp1vlcvyCov7JelZCV6zAVh
         yI9KfpDJmVS4oilzEAFNEhL5yrv13kKGgH6vGg8IUqGACA5ywOF4DAxauwXVN1sRmfCm
         W86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bKOc1pnOZSy/A6AqcGy95JxvjU+o1yN6NNR2BOFs1Zo=;
        b=yz9wEWbasPDaYnOH38eSn7IfH/zpbiF9p8uPSc+2wuXsq6HUiH07wchfckKiunUnhL
         YmMYXqH0Uhb3Lf7kuUJ61J2pbrI3GjY1k6buTw3IbtPxil0FGVEQW4TfuK7AKd4M0qIO
         2gMQwyXzFJuVhJep33ZWUltYbWUpDHrq+ZRXsonJGCGCIH88ytPcgahGd4XVLMtEhvls
         bf7Klrkzal/5nJpmbyCE3IlPNpIsfbpe78Z6MBfNbVdT3PYPy7kErDhD0WZ7vwpa19w9
         OEipXs/BxD/2TEvlLnOr0YFWnscWcpq0e54eTSq/StDEM2lfOlriUMjkFUjgGPRmSc6u
         03Pg==
X-Gm-Message-State: ACrzQf2AmuYBa3PlvGCSC/mrl1uj9w7FId9npRSTmAnf8tx9YfpHGVGA
        0GcBfEE09RnNt0hIBMZbCGVfrvoAsYEvNYfW0AQqB+g04oiN1G+jzy6jX7+nYTHPbDA3RYoHLPx
        9F+puZa9fBDD7kDPrsMM9qBv+9CeX1EweIeRscGGmj73NhR0=
X-Received: by 2002:a63:df03:0:b0:462:cfa2:2871 with SMTP id u3-20020a63df03000000b00462cfa22871mr21741836pgg.225.1666476475624;
        Sat, 22 Oct 2022 15:07:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6GgtRePVqD5kO9HgjG7bDQl1h0aZN+6HYi4tc4P4UpH0evs+zPFDxS8vFNhXekMvhc21jfPRN5IREv/rjV8/s=
X-Received: by 2002:a63:df03:0:b0:462:cfa2:2871 with SMTP id
 u3-20020a63df03000000b00462cfa22871mr21741813pgg.225.1666476475357; Sat, 22
 Oct 2022 15:07:55 -0700 (PDT)
MIME-Version: 1.0
References: <20221022072415.034382448@linuxfoundation.org>
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Sat, 22 Oct 2022 18:07:44 -0400
Message-ID: <CA+pv=HPGuq_OyXLtwHPznw5pMMXGTu=SxDtyFE2+4vXfJ=-HUw@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 22, 2022 at 3:35 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.17 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Note, this will be the LAST 5.19.y kernel to be released.  Please move
> to the 6.0.y kernel branch at this point in time, as after this is
> released, this branch will be end-of-life.
>
> Responses should be made by Mon, 24 Oct 2022 07:19:57 +0000.
> Anything received after that time might be too late.

5.19.17-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,

-srw
