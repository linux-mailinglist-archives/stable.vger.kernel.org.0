Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD4F6C3555
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 16:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjCUPQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 11:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjCUPQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 11:16:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE864FCCE;
        Tue, 21 Mar 2023 08:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=Tt9e/rVg0zLabvjEbl2PNjNW+ESw7w+aYCtqlm2Ha/E=; b=M3CRH5gGLBwy1tMYdjI5tKljqW
        p8EJvLkvBrJOo1rvnckm4jx9SJxsFfMYiig5phqZO0P/KUweNGeYCGOjsZH2v+CuYiaa6ug/MlNLX
        tvti+vhtaYWlE2pxVKzm8LUbMHGIghFtLKbjOgACcebap409vBbEztp4krv+Vxsm9JSiUtsKmCE9X
        /mcXDv6heoEipRfhj9D9rkJUWB1EMpuV5aEHqWEiS1NFUeBSVtGZKICxSIaSgxV3RIAamm2yOA2sE
        rB6eg2bgdl/EC13ZOe1J5fjR9y07Ca0URQdxMSwkMxLhw6eoN+Gpp3f8zZ2qpmtifHM6f+cIsTFTH
        nhUNyHtQ==;
Received: from [2601:1c2:980:9ec0::21b4]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pedj5-00Ct7k-2K;
        Tue, 21 Mar 2023 15:16:39 +0000
Message-ID: <02f8dade-e8ed-49b2-a2cf-aba4bcec0869@infradead.org>
Date:   Tue, 21 Mar 2023 08:16:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6/7 v5] sh: fix Kconfig entry for NUMA => SMP
Content-Language: en-US
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-kernel@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
References: <20230320231310.28841-1-rdunlap@infradead.org>
 <CAMuHMdXnbRvCjtgpbMnUVoRbHSk407t7Sr4XPpoiaE7M1h+4Ng@mail.gmail.com>
 <ad2234ad155d51c142e59adcf2981bce23d69aa4.camel@physik.fu-berlin.de>
 <CAMuHMdW-oxpoHubUJUpsjG9aXtQ3MMwAopN-hS+Mf0gN1udhig@mail.gmail.com>
 <fa8b4f3ca8f3d9dc0487399962bcc6ef75ebd6b0.camel@physik.fu-berlin.de>
 <CAMuHMdV-hAcf+uaWvLdXef6jOUHWV04u0FS2dGHxtJArG6c_Wg@mail.gmail.com>
 <3a00d2b54f990e2fa18db722a81bea78402668c9.camel@physik.fu-berlin.de>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <3a00d2b54f990e2fa18db722a81bea78402668c9.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/21/23 08:15, John Paul Adrian Glaubitz wrote:
> Hi Geert!
> 
> On Tue, 2023-03-21 at 09:47 +0100, Geert Uytterhoeven wrote:
>>> Yeah, this explains it then. Your new patch is definitely the better approach
>>> and I would prefer it over Randy's suggested change. Let's see what the mm
>>> maintainers have to say.
>>
>> I'm sure the missed condition was just an oversight, so I expect no
>> objections.
> 
> And you were right, of course. We can drop Randy's patch then, but I'll pick up
> all the other patches tomorrow when I prepare my for-next tree for 6.4.

Right, drop it.

Thanks, everyone.

-- 
~Randy
