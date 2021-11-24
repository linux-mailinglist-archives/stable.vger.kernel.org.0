Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013EF45B8AA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 11:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241605AbhKXKxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 05:53:33 -0500
Received: from phobos.denx.de ([85.214.62.61]:34292 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233895AbhKXKxb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 05:53:31 -0500
Received: from mail.denx.de (unknown [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: festevam@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id D1C5682FBE;
        Wed, 24 Nov 2021 11:50:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1637751021;
        bh=LHXoLB8Ri91FEj0eco2+/2CAghLtH6ykmiIIfvpPOQ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n9RY19DN8WllXrSc2lWgBekRdW8w/BLpJwmyvKdJO+Zpee096bKsKZGKgRJoG65uV
         JvKIxKkzkmrhIsbki2JvOCSPMlLy+hVgAXN9oY8F4Um4MdxFA/VDu0PbYIleXS3jIn
         BZ6gi/b5wX4spQNizrc6rwjBJ9xRKLdBFbRj+AIJJVOPWS/LFsSKydVmF5amyadULy
         7eWUkkh/umGvg7xuvI2GxbGBJr4gt4Xyr18f7YAa5adAJoMnzHR61hEiE1vrzjKYkR
         oBMeLP3OycD8wDl1heqzUbr5ZKUB+Dz6OYIzHOdPnhQID6hUoaKdox7oKIDMnPDv3w
         /wMH5AuEUi9UA==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 24 Nov 2021 07:50:20 -0300
From:   Fabio Estevam <festevam@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 187/575] ath10k: high latency fixes for beacon buffer
In-Reply-To: <20211116115912.GA24443@amd>
References: <20211115165343.579890274@linuxfoundation.org>
 <20211115165350.173331894@linuxfoundation.org> <20211116115912.GA24443@amd>
Message-ID: <f9a6598c2d6cf80ad40efddba06dddc5@denx.de>
X-Sender: festevam@denx.de
User-Agent: Roundcube Webmail/1.3.6
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On 16/11/2021 08:59, Pavel Machek wrote:

> There's GFP_KERNEL vs. GFP_ATOMIC confusion here:
> 
>> @@ -5466,10 +5470,17 @@ static int ath10k_add_interface(struct 
>> ieee80211_hw *hw,
>>  	if (vif->type == NL80211_IFTYPE_ADHOC ||
>>  	    vif->type == NL80211_IFTYPE_MESH_POINT ||
>>  	    vif->type == NL80211_IFTYPE_AP) {
>> -		arvif->beacon_buf = dma_alloc_coherent(ar->dev,
>> -						       IEEE80211_MAX_FRAME_LEN,
>> -						       &arvif->beacon_paddr,
>> -						       GFP_ATOMIC);
>> +		if (ar->bus_param.dev_type == ATH10K_DEV_TYPE_HL) {
>> +			arvif->beacon_buf = kmalloc(IEEE80211_MAX_FRAME_LEN,
>> +						    GFP_KERNEL);
>> +			arvif->beacon_paddr = (dma_addr_t)arvif->beacon_buf;
>> +		} else {
>> +			arvif->beacon_buf =
>> +				dma_alloc_coherent(ar->dev,
>> +						   IEEE80211_MAX_FRAME_LEN,
>> +						   &arvif->beacon_paddr,
>> +						   GFP_ATOMIC);
>> +		}
>>  		if (!arvif->beacon_buf) {
>>  			ret = -ENOMEM;
>>  			ath10k_warn(ar, "failed to allocate beacon
>>  	buffer: %d\n",
> 
> I'd expect both allocations to use same GFP_ flags.

Good catch.

Let me prepare a patch, test it and submit it soon.

Thanks,

Fabio Estevam
-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-60 Fax: (+49)-8142-66989-80 Email: 
festevam@denx.de
