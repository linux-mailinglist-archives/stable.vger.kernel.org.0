Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEBA654B1B
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 03:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLWCb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 21:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiLWCbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 21:31:25 -0500
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Dec 2022 18:31:24 PST
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBB715814
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 18:31:24 -0800 (PST)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id 76D0660110
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 11:12:38 +0900 (JST)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        by gw.atmark-techno.com (Postfix) with ESMTPS id CEAAE6010E
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 11:12:37 +0900 (JST)
Received: by mail-pl1-f197.google.com with SMTP id f8-20020a170902ce8800b00190c6518e21so2514846plg.1
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 18:12:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93cLn+LRIp8cfyEt0hoEq4b5MzTpiSYxIJZ4bO6Vpug=;
        b=tNChOflLP1A/sTCREYOLvauEmGlXFsLVXL2GOf2WOWDW3ncIt2P2rl4CLegnlL58de
         AuAwbEyNSyW23S0yx7CDvJf0n4wcbAbRZGxWnmhcGFbv0mMJ0WYhCv5J1S2FC6JYCN5T
         7vcKLe1Vp0kr4qVFOoJjSdaGnz88zgAB/JGqiHES930gXF034G7TrtI264vokO2bIdIH
         klP9VFkT9QS9Qgq3ukQ9yNLXmD3ySi4c3YVHSZ/b2Vcy5u4KoGYbkKY274jEeisRFDJL
         nUW9apGpjBAbu8mqvNrojousoNo6AXdkFUtttXdsq7G25DdgDpDSxow/7IMoYejgnnfW
         epXw==
X-Gm-Message-State: AFqh2kpeBA6ugH68nHCYwEf5CmpL9dX02HqQatsKkxu7M20FsjG2sd7u
        WAQ6RR+x36UA+Di6/+A1+TqaDxl2gB3LfvjgutmAiiCKlsna9NZfSVSFj9LSeyAY0FqIAj0Da7x
        iRAmxCazTvJCKy8bf+NDq
X-Received: by 2002:aa7:921a:0:b0:576:de1:cd32 with SMTP id 26-20020aa7921a000000b005760de1cd32mr8819370pfo.0.1671761556919;
        Thu, 22 Dec 2022 18:12:36 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv5NY5kv2b2FMEzQtFveGRj3mudS9rZ8bcNHH4p882FhazY117d677Z8wksF8JVTkfXujOgdA==
X-Received: by 2002:aa7:921a:0:b0:576:de1:cd32 with SMTP id 26-20020aa7921a000000b005760de1cd32mr8819357pfo.0.1671761556648;
        Thu, 22 Dec 2022 18:12:36 -0800 (PST)
Received: from pc-zest.atmarktech (76.125.194.35.bc.googleusercontent.com. [35.194.125.76])
        by smtp.gmail.com with ESMTPSA id y18-20020aa79432000000b00577617c05ecsm1320774pfo.130.2022.12.22.18.12.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Dec 2022 18:12:36 -0800 (PST)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1p8XY2-00GpKT-2P;
        Fri, 23 Dec 2022 11:12:34 +0900
Date:   Fri, 23 Dec 2022 11:12:24 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Lukas Wunner <lukas@wunner.de>,
        Daisuke Mizobuchi <mizo@atmark-techno.com>,
        Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
        linux-serial@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.15.y v2] serial: fixup backport of "serial: Deassert
 Transmit Enable on probe in driver-specific way"
Message-ID: <Y6UOiAt+o7425bRa@atmark-techno.com>
References: <20221220102316.1280393-1-linux@rasmusvillemoes.dk>
 <20221222114414.1886632-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221222114414.1886632-1-linux@rasmusvillemoes.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rasmus Villemoes wrote on Thu, Dec 22, 2022 at 12:44:14PM +0100:
> When 7c7f9bc986e6 ("serial: Deassert Transmit Enable on probe in
> driver-specific way") got backported to 5.15.y, there known as
> b079d3775237, some hunks were accidentally left out.
> 
> In fsl_lpuart.c, this amounts to uart_remove_one_port() being called
> in an error path despite uart_add_one_port() not having been called.
> 
> In serial_core.c, it is possible that the omission in
> uart_suspend_port() is harmless, but the backport did have the
> corresponding hunk in uart_resume_port(), it runs counter to the
> original commit's intention of
> 
>   Skip any invocation of ->set_mctrl() if RS485 is enabled.
> 
> and it's certainly better to be aligned with upstream.
> 
> Fixes: b079d3775237 ("serial: Deassert Transmit Enable on probe in driver-specific way")
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Thank you!
I've confirmed both hunks are part of the original patch; I'm not quite
sure why we missed them...

Reviewed-by: Dominique MARTINET <dominique.martinet@atmark-techno.com>


This doesn't apply cleanly to 5.10 because 5.10 did not get
401fb66a3 ("fsl_lpuart: Don't enable interrupts too early") backported,
I think it makes sense to take as well so I'll send a backport of these
two patches for 5.10

-- 
Dominique


