Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE74A6D5F24
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbjDDLhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbjDDLhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:37:01 -0400
X-Greylist: delayed 123 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Apr 2023 04:36:51 PDT
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2997A2D42
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 04:36:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680607925; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=HCRvfx/e7AyhCDrMyXqZRbRQIeyD+oEo8JD2HGF8IZiKEH7TGuo6xuONvo0gmVb/mFmfPsuepkRH5D8yMxnwbJQsN8jbztk/nchOYf41AWXuKmChNbQT8ps/cJUABMQsWAdQHBJEYminLnvOWsbT6reD0J0rggoyf1sF22rrHnA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680607925; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=SurNIkRcrzZn0jveewPZbpUke3jSI9WnfglfUnB1T0o=; 
        b=ZnGYc8rl6QRdB+YF5UodLZw5i7iLglvi5vdRwgWqa4EzV01YEjercnLHAjADoEPFj/dOjLSaFyKKWNjP6uX8NoVVqLRtXYqLPEqGvN4i0v/HswgCtfyns+g5zuykhAblHOo8F9Nyw8rxU6T6aMior2+Dwbw/pT1mINofG/wOOhA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680607925;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=SurNIkRcrzZn0jveewPZbpUke3jSI9WnfglfUnB1T0o=;
        b=fPEDP5477B2TyC06gwdsAeoE3J/8Z4gFwOD69oBobxp5ab70X+28gM/dBY/g49Ua
        +IsjRujzxn7aMljAZmOcReaeoc6VCsy2jFiD9GLkwJLbUpjsKMKzmfy4k4wL0JkOuPg
        vnuHB/PCXIvUQhoY5pLAs4TSV9lS+n1NaBSiCp9c=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680607919598744.2155252450362; Tue, 4 Apr 2023 04:31:59 -0700 (PDT)
Message-ID: <f08afb70-2278-b6aa-7f48-e407b9af447c@arinc9.com>
Date:   Tue, 4 Apr 2023 14:31:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.10 051/173] net: dsa: mt7530: move setting ssc_delta to
 PHY_INTERFACE_MODE_TRGMII case
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.096716862@linuxfoundation.org> <ZCwJhAfrTIPorVTw@duo.ucw.cz>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZCwJhAfrTIPorVTw@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4.04.2023 14:27, Pavel Machek wrote:
> Hi!
> 
>> [ Upstream commit 407b508bdd70b6848993843d96ed49ac4108fb52 ]
>>
>> Move setting the ssc_delta variable to under the PHY_INTERFACE_MODE_TRGMII
>> case as it's only needed when trgmii is used.
> 
> This one is very wrong for 5.10. ssc_delta is unconditionally used
> below, and it will not use uninitialized variable.
> 
> (In mainline, that code is protected by if (trgint), so it does not
> have this problem).

This patch is not stable material in the first place. As a newbie I 
incorrectly sent it to net tree instead of net-next. This patch can just 
be ignored for 5.10, if that takes the least amount of effort for you folks.

Sorry about that and thanks for pointing this out Pavel.

Arınç
