Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8483612AC8
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 14:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiJ3NpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 09:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJ3NpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 09:45:03 -0400
Received: from mx1.heh.ee (heh.ee [213.35.143.160])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBF56401
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 06:44:59 -0700 (PDT)
Received: from [0.0.0.0] (unknown [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mx1.heh.ee (Hehee) with ESMTPSA id F3629170442;
        Sun, 30 Oct 2022 15:44:56 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ristioja.ee; s=mail;
        t=1667137497; bh=Bszs9VEOzXaQlnnBhaKnHWbBOhKOt86RayMEIowsU3w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Wxmu4jGpA8H7TuRpdStKxEBhs+W8OFko2f9/DcbMskEaly85/2qeln65xf3YO95zm
         fd3E4lOxN7r+m8cXuCGLY9ThS5ngMFabD2WNsQ7xBRYBBDGsRjCQEdkIVSF2c7NNsH
         PEm2U1WedjH311KhYenQ8WKf6MdGfzaypvfX/U20=
Message-ID: <ddeed421-cf75-4a44-4f5d-f26cd0359b78@ristioja.ee>
Date:   Sun, 30 Oct 2022 15:44:55 +0200
MIME-Version: 1.0
User-Agent: undefined
Subject: Re: drivers/platform/x86/amd/pmc.c compile error in 6.0.6
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <d166779c-a845-2483-41c6-4cd7e06c22c3@ristioja.ee>
 <Y14mgmo+ZEKTR4/v@kroah.com>
Content-Language: et-EE
From:   Jaak Ristioja <jaak@ristioja.ee>
In-Reply-To: <Y14mgmo+ZEKTR4/v@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30.10.22 09:23, Greg Kroah-Hartman wrote:
> On Sun, Oct 30, 2022 at 01:51:59AM +0300, Jaak Ristioja wrote:
>> Hello,
>>
>> The following error popped up when compiling Linux kernel version 6.0.6:
>>
>> drivers/platform/x86/amd/pmc.c: In function 'amd_pmc_verify_czn_rtc':
>> drivers/platform/x86/amd/pmc.c:640:22: error: implicit declaration of
>> function 'amd_pmc_get_smu_version' [-Werror=implicit-function-declaration]
>>    640 |                 rc = amd_pmc_get_smu_version(pdev);
>>        |                      ^~~~~~~~~~~~~~~~~~~~~~~
>>
>> This function call was introduced backported with commit e9847175b266 with
>> the subject line "platform/x86/amd: pmc: Read SMU version during suspend on
>> Cezanne systems".
>>
>> Please note that amd_pmc_get_smu_version() is defined in an #ifdef
>> CONFIG_DEBUG_FS block, but the new function call is compiled regardless of
>> CONFIG_DEBUG_FS, causing the aforementioned error when building without the
>> Debug Filesystem.
> 
> Ah, good catch.  Is this issue also there in Linus's tree?  If not, any
> hint on what commit fixed it?

It looks like applying commit b37fe34c8309 titled "platform/x86/amd: 
pmc: remove CONFIG_DEBUG_FS checks" fixes the compile error. Hope it 
helps :)

Jaak Ristioja
