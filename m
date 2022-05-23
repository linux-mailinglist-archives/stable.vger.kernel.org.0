Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABCC5314A1
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237732AbiEWPRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 11:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237564AbiEWPRp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 11:17:45 -0400
Received: from mail.jv-coder.de (mail.jv-coder.de [5.9.79.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E0B4704A
        for <stable@vger.kernel.org>; Mon, 23 May 2022 08:17:43 -0700 (PDT)
Received: from [10.40.94.11] (unknown [37.24.96.116])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 88272A010A;
        Mon, 23 May 2022 15:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1653319061; bh=OWKX6VYc5FZyxwfGKNHb6/Mh36c+C2Qi/xmsaparhF0=;
        h=Message-ID:Date:MIME-Version:Subject:To:From;
        b=j0jzAt35W7o5cNWnbYU4eI3DsZPCxlPD/s1MxT9pGuSCbh85TrZSQwheh1DeBfW9A
         8+AhPYhW05GfFD5vWA498HFyEWoFBz9cfHUOLqGh5r7XUtHDS3tWuP329FwCJ6OIqe
         8jjjCB0ONLv6HaYBLaxb61K5YKGh00BtoaI/f62o=
Message-ID: <c3bf809d-57b6-ff15-8184-6e8c0ccbccfe@jv-coder.de>
Date:   Mon, 23 May 2022 17:17:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.10] module: treat exit sections the same as init
 sections when !CONFIG_MODULE_UNLOAD
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Joerg Vehlow <joerg.vehlow@aox.de>
References: <342c6a9f-771f-0714-e02c-08d0c0f4cd6b@jv-coder.de>
 <YoulDn99IXPd6xBM@kroah.com>
From:   Joerg Vehlow <lkml@jv-coder.de>
In-Reply-To: <YoulDn99IXPd6xBM@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Am 5/23/2022 um 5:15 PM schrieb Greg KH:
> On Mon, May 23, 2022 at 06:39:48AM +0200, Joerg Vehlow wrote:
>> Hi,
>>
>> this mainline patch 33121347fb1c359bd6e3e680b9f2c6ced5734a8 should be
>> applied to 5.15 as well.
> 
> You mean 5.10, right?  It's already in 5.13 and newer releases
Yes of course, I even put it correct in the subject...
> 
>> Without loading of some modules fails, if
>>  1. MODULE_UNLOAD=n
>>  2. Architecture is aarch64 (maybe others as well)
>>  3. KASLR is active
>>
>> Without this patch the symbol .exit.text is not relocated and when the
>> linker generated a relative 32 bit relocation(PREL32) and the module is
>> loaded far enough away from the default loading address, it will trigger
>> a relocation overflow like this:
>>
>> module algif_hash: overflow in relocation type 261 val ffff800010051c20
>>
>> This happens to all modules, that use BUG in the exit section or if the
>> compiler generates a jump table in the exit section.
> 
> Now queued up for 5.10.y, thanks.
Thanks

> 
> greg k-h

Joerg
