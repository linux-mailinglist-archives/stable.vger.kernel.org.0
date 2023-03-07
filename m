Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A576ADBE3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 11:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjCGK2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 05:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjCGK1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 05:27:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F7F52926
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 02:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678184781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LJ3a4OKd2xsWg0ZM/2W4mQQK3PnmS/QZqFHDCgSJxCI=;
        b=PBZohkIYgD4Ceyr8CMprrWIu3fztFxWGIjcW/VqVaE77jAQtNC0y0fqz4/HK3KJ+hJxGNL
        gcdR7X1Qs/bqhwT0uQN046WwR8qSrHvxJEZJtZsxTLoBX84LTVrzEOZEKST7uR82KD6VDC
        0UusFwuSpu4tx/Teezi6ajb5gqD0oN4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-9_E1hM_jOS6VHM-Yy7nTTw-1; Tue, 07 Mar 2023 05:26:20 -0500
X-MC-Unique: 9_E1hM_jOS6VHM-Yy7nTTw-1
Received: by mail-ed1-f69.google.com with SMTP id k12-20020a50c8cc000000b004accf30f6d3so18274052edh.14
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 02:26:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678184779;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LJ3a4OKd2xsWg0ZM/2W4mQQK3PnmS/QZqFHDCgSJxCI=;
        b=AtLErkCGRQCBTEAtNSTi0JSHwC58tkrOt0jDGdbNnk4wYdwVksRyUr/+xLd6UWWCwP
         WXSQjrqIt9g4LAeoTNgkSn8C0yqCKhH3s8n7aeOqrbdN392ib0851lLus5REu/yvzBLm
         kBb+5hcUi7vJH1PEa8xsJhDSjLcekFxbtHl0glks3omnWul8IZ4DPDfmLCGadSOnSIpu
         6KbkUnA3bKgd3p1Dk4XR2XyPQrLkntPAnY6SWxTIitLoeqOaaHAwYQewHnPbvgcpAeXi
         opDcheQHVBMEqyL5rARCpoRH+Xv78gYJu9KmDbbfawHveqmP6bqZr4j8OpSnANA80Ezo
         INiQ==
X-Gm-Message-State: AO0yUKVP3H3jW17E9UVVDRs/VEUWY+Pxo/tvKflYoyndPEPuMJBFG4rF
        VA3MYQ7Qi9APr5BMHcp6z/ne6Py0kYxctUsVtKs2Pm6KTLIh2iJQkq1r3OL0aaz9uupiU9LiYPt
        D3sdPiVIe8F462jaI
X-Received: by 2002:a17:906:3f5d:b0:871:178d:fc1e with SMTP id f29-20020a1709063f5d00b00871178dfc1emr12925485ejj.77.1678184779299;
        Tue, 07 Mar 2023 02:26:19 -0800 (PST)
X-Google-Smtp-Source: AK7set/KN4FcVBjwnLlfJUlXjaVjCuuB4IYPkMvYuB1ZbjJt89ZJWQB50LDzIKdonI2nx9CIUPAkeg==
X-Received: by 2002:a17:906:3f5d:b0:871:178d:fc1e with SMTP id f29-20020a1709063f5d00b00871178dfc1emr12925476ejj.77.1678184779072;
        Tue, 07 Mar 2023 02:26:19 -0800 (PST)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id g8-20020a17090613c800b008e45d7055f8sm5815373ejc.198.2023.03.07.02.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 02:26:18 -0800 (PST)
Message-ID: <3a17dd23-c396-7cfb-3cfa-19cdec39f2ff@redhat.com>
Date:   Tue, 7 Mar 2023 11:26:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] staging: rtl8723bs: Fix key-store index handling
Content-Language: en-US, nl
To:     Bastien Nocera <hadess@hadess.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     linux-staging@lists.linux.dev, stable@vger.kernel.org
References: <20230306153512.162104-1-hdegoede@redhat.com>
 <f23d6700b79500e2da9875964aee356c60a60529.camel@hadess.net>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <f23d6700b79500e2da9875964aee356c60a60529.camel@hadess.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 3/6/23 16:40, Bastien Nocera wrote:
> On Mon, 2023-03-06 at 16:35 +0100, Hans de Goede wrote:
>> There are 2 issues with the key-store index handling
>>
>> 1. The non WEP key stores can store keys with indexes 0 -
>> BIP_MAX_KEYID,
>>    this means that they should be an array with BIP_MAX_KEYID + 1
>>    entries. But some of the arrays where just BIP_MAX_KEYID entries
>>    big. While one other array was hardcoded to a size of 6 entries,
>>    instead of using the BIP_MAX_KEYID define.
>>
>> 2. The rtw_cfg80211_set_encryption() and wpa_set_encryption()
>> functions
>>    index check where checking that the passed in key-index would fit
>>    inside both the WEP key store (which only has 4 entries) as well
>> as
>>    in the non WEP key stores. This breaks any attempts to set non WEP
>>    keys with index 4 or 5.
>>
>> Issue 2. specifically breaks wifi connection with some access points
>> which advertise PMF support. Without this fix connecting to these
>> access points fails with the following wpa_supplicant messages:
>>
>>  nl80211: kernel reports: key addition failed
>>  wlan0: WPA: Failed to configure IGTK to the driver
>>  wlan0: RSN: Failed to configure IGTK
>>  wlan0: CTRL-EVENT-DISCONNECTED bssid=... reason=1
>> locally_generated=1
>>
>> Fix 1. by using the right size for the key-stores. After this 2. can
>> safely be fixed by checking the right max-index value depending on
>> the
>> used algorithm, fixing wifi not working with some PMF capable APs.
> 
> Good job on both those patches.
> 
> Can you please also CC: the maintainer of r8188eu which looks like it
> has similar code?

Done (added to the To: of this reply).

Note I have heard that the r8188eu is now (starting with 6.2 ?) supported
by one of the non staging realtek wifi drivers. So I think that maybe it
can just be removed from staging altogether ?

Regards,

Hans




