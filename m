Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7938360BC27
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiJXV3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiJXV3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:29:24 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095A725E09E
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 12:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666640055;
        bh=aQXL6HsBM0PBhw4P2ZBfupcRtHh2BCUCWB6pB0nA23A=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:Reply-To:From:
         In-Reply-To;
        b=DZTJ1LVaXC2/3OvjyQ9PZ/0+REQaXcKhG/vdCYEWLKpNFAfCsNzpIlkUF0qsdJb95
         9tq+yc5CiokbjHUh2UPaUTgnK7jAX0BHOKM5F9vJs7sqWV8B9jqaO9yMw88DIgZqzp
         /CaFME9p5/H+Yy1//Xs7F6e1G2DZLZReRuFAxZpw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.0.179] ([91.141.38.147]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MtwUm-1p5Vz70NpM-00uMMC; Mon, 24
 Oct 2022 18:53:17 +0200
Message-ID: <d6afe54b-f8d7-beb2-3609-186e566cbfac@gmx.net>
Date:   Mon, 24 Oct 2022 18:53:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Sasha Levin <sashal@kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Javier Martinez Canillas <javierm@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
 <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
 <Y1Z2sq9RyEnIdixD@kroah.com> <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
Content-Language: de-AT
Reply-To: andreas.thalhammer@linux.com
From:   Andreas Thalhammer <andreas.thalhammer-linux@gmx.net>
In-Reply-To: <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:oXxMU3rv9x3UT4ue7ukIwZ6SdCPVZxqtw7T7v5iUBbb/swy8ZGW
 OEh7ZMfxoCabHFhNrQ+9g5tniFWizkiG8musEV22cHvnKWGv6TqOLtXFcVLdn05V4SAtO9B
 gSiuLrNIOEtwt0Kc1CQhB9OxWwfzXaRZjtbm1eVQ020qS/samJk8Ej2vDsEAn0XgA0Dij29
 MhQ/XUcxtLn9bZYYdsoOQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eORuphl9w54=:idlBEMkjXXuO5UvzJTc4Th
 L+j7mrayHOF/uXSil/NNKFO881YaCmHWD/DWF5YAM+pCzlEXQYJhOf671upjPv0/4vxK3MSuL
 r3wnT/f0WUM1TR8I9dnq+2a++JallMufNw0jmdvai6OUw8Cuh7w1xP9+MKnuU6OC7CABe/pg1
 NkpVxVZpFUk65EDBywLODhu4YHbGquujIKg7chqoB0M/BGWjME3wOZ/djtYUmwrhuXvBbURsG
 KJJUXHwZ49fybMfcXzDuALHEHQIXW8eZCPrFLt+FjU/40DbDBE3nZleGD9j6bOF77BfWrVeci
 Bd9zrlg1ivx+DXvFwkQz/bTpumJzy8rKhlax90tK+iuUMHBwhM9KDvSwtko0avZ7G2evVRqG1
 9vvXpQrrzVXGXnD0u+GvoDfhDkaa9b5FTpIyh773HCXjpu7VBOPj9R714F5lsqOfTq/o7jrdo
 UDS2YC8rAo0rTzXpGdc78gcGheH34MC5SoLCpo3PbvyN/mxQASbO8U6s1tNMKclYJXq+itmvW
 I1DGUmbP2L/kH87emMRfVW4/WzvbiPpfo5ppAjBlrIfJpbjxHNgcv4eT09SRAAlyvxBEFMoQ3
 evmjXIqptuG+BEfkorJd4PhyG/iIG1hTyOOTmtlHRt8m6RjgGrewqAuCAId/4SwReOeRMmRmz
 x/U/g5TESpE74bpUmYwdLJTDyx8yuaTx/ww7cZ/sx+n2oJcmrPijWeyZKr48LHNr0DKaCnrnV
 1wsqaYWv2qYW4aJs/h1MjPBN8DQtcU0LgUd8BriRqoNst84ZJIqK+DF2aHJCkhuZ4rY8kPfT/
 GG/GOCeCrWiE/tu4rGD/8hrySO1WCzJsBMPBc/AHGsgocnDOiT7UqsbFdCuCI4m/OeBxijFye
 RdBB6jVKPihjaKRxM6VcFT56uGjGiD//kv19CvQsuU7ruu5yWr0c/x85jwrHjkdI+s4ZDgpUM
 XB3l67OvNqgzMPHHRDZwJcDPHJTBDXnPJi+xWkgei869BNoWEGSHyI8lFKVrZi4SXt2J0+sLy
 ScsiGtFuss1G7Go1R0yyRnnR16DQXv01xnnh9pY1Uk2gEGtDsPnzi5Jv/fOfrBewBeh/IJncy
 FM5arja0QAufTObd0QXPNuAopP90JpNQVKGbmPvJGuTHwv2pB/3QIua1Ksywbv/PtODNUm4kK
 l8onjruxgUtR6MeuVaXFHXyQWWSN8wt68MgY+TRaf6mzCMENW3TLgC3IicXc6HLF+IpKVuoj+
 YEAsbOgipBQ/BUSsCYSzwTM4pxW9FShfQ99EFMSYCrXA8C/1leiz9N7+SUkQsNEg1Lo4W9m/V
 QFIB9BsrWkGU0uNNGmg9c+jXNejUpYqT8ZAh6WqQMi1T9a+0xWlUh7aAPvKGfe0t6QxrkzntE
 ZC86xGgdQQKs/+otUSYOI4KdAZfSeG5bDakYN/EJVDdvkwR8Sv4jcfp2gdh1weKcwHU+nZGAr
 qOXqZf7IgAInGsVsQRRFWkwdS9eKhTyB8UW/0rUNARv5m9Iqbf3B6Ledj6LLz5SUmML0mXghY
 NaKbrSCcn/YII9+cVruDdX76zslEDSIJPBiB49a4oD7Bae/ARcQb8dEyemD7DwM7lxg==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just tested with 6.1-rc2 (tarball from kernel.org), which works.
