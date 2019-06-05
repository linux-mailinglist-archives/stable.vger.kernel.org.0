Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC3636141
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 18:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfFEQ2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 12:28:47 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40965 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfFEQ2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 12:28:47 -0400
Received: by mail-ed1-f65.google.com with SMTP id p15so3328064eds.8
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 09:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=texzsntjPS9Je7YpaNLDNEXRJq4Tev+pqkzAMfzQDk8=;
        b=cZGMQhQAIx5eeweZgrBddrhncB0a+1Elu/g6H08kjDp56mvgiWWirw/qxrIW82cVA/
         4hMWAQUeU6P+E0eR4JYWDYz4UvdQhnMRoT6OpLmWwtJIOJ/yfycLQige5CQGusKQL1bj
         QhuPbPF7xvztv9fP3TNKrvpj3KxuMetyHh6JRDfN8brX5Yai0onBL9O5sHibRZUol8ZV
         2gOgeHAQ6wYyoeKMz9eeIEuBVDdcr0aC/KhVFL8L7dNoP5Yt1CKuZiVt1VJs/Ak34UZR
         WsoriThpzi3Gkb890ixP5sUGFQbax2XD4TOOPkpZOSlU3ZQ8tE6etGU7UJ1s6E/cQWPo
         QXow==
X-Gm-Message-State: APjAAAVARg41n7MvKIsE7MhJNKBgYmOkBi557vSmOj9Vq7/FtyIITHCh
        2VvktPPNaytZOsqvGPHaozy8hwUYa1U=
X-Google-Smtp-Source: APXvYqwNWYkv9AscaU9vSqP5ICOzHT3WGsx1ZaVgmSxe1NnF9O1OaJjhQVtIZJ3s7VgRkv5Ckxs7Tg==
X-Received: by 2002:a05:6402:1851:: with SMTP id v17mr28574191edy.3.1559752125561;
        Wed, 05 Jun 2019 09:28:45 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id b1sm34003ejo.9.2019.06.05.09.28.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 09:28:44 -0700 (PDT)
Subject: Re: [PATCH 2/2] drm/i915/dsi: Use a fuzzy check for burst mode clock
 check
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20190524174028.21659-1-hdegoede@redhat.com>
 <20190524174028.21659-2-hdegoede@redhat.com>
 <20190604172936.GH5942@intel.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <5961343b-f5ed-d55c-689d-0ebc2ee9c661@redhat.com>
Date:   Wed, 5 Jun 2019 18:28:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190604172936.GH5942@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thank you for the reviews.

On 04-06-19 19:29, Ville Syrjälä wrote:
> On Fri, May 24, 2019 at 07:40:28PM +0200, Hans de Goede wrote:
>> Prior to this commit we fail to init the DSI panel on the GPD MicroPC:
>> https://www.indiegogo.com/projects/gpd-micropc-6-inch-handheld-industry-laptop#/
>>
>> The problem is intel_dsi_vbt_init() failing with the following error:
>> *ERROR* Burst mode freq is less than computed
>>
>> The pclk in the VBT panel modeline is 70000, together with 24 bpp and
>> 4 lines this results in a bitrate value of 70000 * 24 / 4 = 420000.
>> But the target_burst_mode_freq in the VBT is 418000.
>>
>> This commit works around this problem by adding an intel_fuzzy_clock_check
>> when target_burst_mode_freq < bitrate and setting target_burst_mode_freq to
>> bitrate when that checks succeeds, fixing the panel not working.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>   drivers/gpu/drm/i915/intel_dsi_vbt.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/i915/intel_dsi_vbt.c b/drivers/gpu/drm/i915/intel_dsi_vbt.c
>> index 022bf59418df..a2a9b9d0eeaa 100644
>> --- a/drivers/gpu/drm/i915/intel_dsi_vbt.c
>> +++ b/drivers/gpu/drm/i915/intel_dsi_vbt.c
>> @@ -895,6 +895,17 @@ bool intel_dsi_vbt_init(struct intel_dsi *intel_dsi, u16 panel_id)
>>   		if (mipi_config->target_burst_mode_freq) {
>>   			u32 bitrate = intel_dsi_bitrate(intel_dsi);
>>   
>> +			/*
>> +			 * Sometimes the VBT contains a slightly lower clock,
>> +			 * then the bitrate we have calculated, in this case
>> +			 * just replace it with the calculated bitrate.
>> +			 */
>> +			if (mipi_config->target_burst_mode_freq < bitrate &&
>> +			    intel_fuzzy_clock_check(
>> +					mipi_config->target_burst_mode_freq,
>> +					bitrate))
>> +				mipi_config->target_burst_mode_freq = bitrate;
> 
> Maybe should squash these patches together to make the stable
> backport less painful?

Good idea, done.

> Anyways, seems OK to me.
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

And pushed with your Reviewed-by.

Regards,

Hans
