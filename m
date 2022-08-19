Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5126D599325
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 04:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343806AbiHSCqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 22:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242618AbiHSCqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 22:46:42 -0400
Received: from yamato.tf-network.de (yamato.tf-network.de [93.186.202.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB11CCD52
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 19:46:40 -0700 (PDT)
Received: from amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
        by yamato.tf-network.de (Postfix) with ESMTP id 4M85k51lMSz4RgC;
        Fri, 19 Aug 2022 04:46:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at amavis3.tf-network.de
Received: from smtp.tf-network.de ([93.186.202.221])
        by amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221]) (amavisd-new, port 10024)
        with LMTP id aCKhr1TY8UhC; Fri, 19 Aug 2022 04:46:36 +0200 (CEST)
Received: from [10.1.0.10] (xdsl-78-34-186-118.nc.de [78.34.186.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.tf-network.de (Postfix) with ESMTPSA id 4M85k44hTtz442N;
        Fri, 19 Aug 2022 04:46:36 +0200 (CEST)
Message-ID: <0192a465-d75d-c09a-732a-eb2215bf3479@whissi.de>
Date:   Fri, 19 Aug 2022 04:46:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
From:   Thomas Deutschmann <whissi@whissi.de>
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
To:     Song Liu <song@kernel.org>, Vishal Verma <vverma@digitalocean.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Jens Axboe <axboe@kernel.dk>
References: <000401d8a746$3eaca200$bc05e600$@whissi.de>
 <000001d8ad7e$c340ad70$49c20850$@whissi.de>
 <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
 <0FBCAB10-545E-45E2-A0C8-D7620817651D@digitalocean.com>
 <CAPhsuW5f9QD+gzJ9eBhn5irsHvrsvkWjSnA4MPaHsQjjLMypXg@mail.gmail.com>
 <43e678ca-3fc3-6c08-f035-2c31a34dd889@whissi.de>
 <701f3fc0-2f0c-a32c-0d41-b489a9a59b99@whissi.de>
Content-Language: en-US
In-Reply-To: <701f3fc0-2f0c-a32c-0d41-b489a9a59b99@whissi.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-08-17 20:29, Thomas Deutschmann wrote:
> I will do another round with 2b7196a219bf (good) <-> 5.18 (bad).

...and this one also ended up in

> first bad commit: [fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf] Linux 5.16-rc1 

Now I built vanilla 5.18.18 and fsfreeze will hang after FIFREEZE ioctl 
system call after running my reproducer which generated I/O load.

=> So looks like bug is still present, right?

When I now just edit Makefile and set KV <5.16-rc1, i.e.

> diff --git a/Makefile b/Makefile
> index 23162e2bdf14..0f344944d828 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  VERSION = 5
> -PATCHLEVEL = 18
> -SUBLEVEL = 18
> +PATCHLEVEL = 15
> +SUBLEVEL = 0
>  EXTRAVERSION =
>  NAME = Superb Owl
> 

then I can no longer reproduce the problem.

Of course,

> diff --git a/Makefile b/Makefile
> index 23162e2bdf14..0f344944d828 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  VERSION = 5
> -PATCHLEVEL = 18
> -SUBLEVEL = 18
> +PATCHLEVEL = 15
> +SUBLEVEL = 99
>  EXTRAVERSION =
>  NAME = Superb Owl
> 

will freeze again.

For me it looks like kernel is taking a different code path depending on 
KV but I don't know how to proceed. Any idea how to continue debugging this?


-- 
Regards,
Thomas
