Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F391E6E99D2
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 18:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjDTQpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 12:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjDTQpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 12:45:50 -0400
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F6E35B5
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 09:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=b5kcCTYB3xWmqfX++7dBuiTmOPd0bSp1WV/38bxkqE4=; b=ZY3ALqg32CEncgrK2yAZHjjH+T
        a+CsSIU8/wzt/T82kIdy93XPQYBAdL3B1Mfecduvsk64zM2gGSM0JPRvl/Q11ibHS+qXU/st0nHUv
        LZTkJ9WQRobenG/m/ATfiF4zDxKoR8Lc8llAd9tlyENipnfSHBFTZwWpWEl/+qeYTyD5CvuOr8OjF
        +Gl97Ru83vGHpawyQeR2U+nf1kw8JHglNUILCz+IJiizB52ZgF/RYAQQHK3DmeH7Fv3TEoRtrCQQK
        WHjJ6Hk2Tez8GuQzuEBEbz9IDOGbJFR19jQchtR6WUJRrdsZJDdeMeYBIhBalgVFpajSnS8y+ssG3
        P/PM30OQ==;
Received: from 201-92-79-199.dsl.telesp.net.br ([201.92.79.199] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1ppXPj-0076s7-OB; Thu, 20 Apr 2023 18:45:44 +0200
Message-ID: <2bd00709-02b3-c63c-3970-10d8906b5b1a@igalia.com>
Date:   Thu, 20 Apr 2023 13:45:36 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
Content-Language: en-US
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "Zhu, James" <James.Zhu@amd.com>, "Liu, Leo" <Leo.Liu@amd.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>
References: <20230418221522.1287942-1-gpiccoli@igalia.com>
 <BL1PR12MB514405B37FC8691CB24F9DADF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <be4babae-4791-11f3-1f0f-a46480ce3db2@igalia.com>
 <BL1PR12MB51443694A5FEFA899704B3EBF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <9b9a28f5-a71f-bb17-8783-314b1d30c51f@igalia.com>
 <ZEEzNSEq-15PxS8r@kroah.com>
 <94b63d19-4151-c294-50eb-c325ea9c699f@igalia.com>
 <ZEFUGSlqQu3v8ryf@kroah.com>
 <caf5bfc9-89d2-1320-4386-2c026ec3afcc@igalia.com>
 <ZEFgn4iY_swFKnc0@kroah.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <ZEFgn4iY_swFKnc0@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20/04/2023 12:56, gregkh@linuxfoundation.org wrote:
> [...]
> That's 3000+ emails ago for me :)

/head_exploding

this is > 1000 emails per day, wow...my sympathies to you heh

> [...]
>> tl;dr: the offender is present on 6.1.y, but this fix is not, hence I'm
>> hereby requesting the merge. Some backport/context adjustment was
>> necessary and it was properly tested in the Steam Deck.
> 
> Ok, we'll queue it up soon, thanks.
> 
> greg k-h

Thanks =)
