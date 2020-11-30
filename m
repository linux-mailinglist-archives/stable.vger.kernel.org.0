Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563292C8115
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 10:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgK3JdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 04:33:00 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:44890 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgK3JdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 04:33:00 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AU9VA4X033975;
        Mon, 30 Nov 2020 03:31:10 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1606728670;
        bh=FN32bD3RxP2OJReQ02Kv5gT9peBg8Tvy2u0Ql8xRkG4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=duQZ9M9x8GO6hkSzph+4i3TrB3Rrp/gJDoZoksRHhAZkFR+GnT7kKr3Vs+LrS83V5
         +GcrIVBR2MQDOWvEKKwIIMJT4+Wc81Jvoq7Nccm2R5vSMpAF+8yrwNXGIMDJVbGbUG
         x0pgD9GuA3p/ViCdvhBnSBznkb704J8Qpgx7JAUA=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AU9VAJ3119062
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 03:31:10 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 30
 Nov 2020 03:31:09 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 30 Nov 2020 03:31:09 -0600
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AU9V7Ij024957;
        Mon, 30 Nov 2020 03:31:08 -0600
Subject: Re: [PATCH] drm/omap: sdi: fix bridge enable/disable
To:     Aaro Koskinen <aaro.koskinen@iki.fi>
CC:     <dri-devel@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Nikhil Devshatwar <nikhil.nd@ti.com>,
        <linux-omap@vger.kernel.org>, <stable@vger.kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
References: <20201127085241.848461-1-tomi.valkeinen@ti.com>
 <20201128174528.GD551434@darkstar.musicnaut.iki.fi>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <e8b01da0-96af-7e98-2a62-fb6775cf5a4e@ti.com>
Date:   Mon, 30 Nov 2020 11:31:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201128174528.GD551434@darkstar.musicnaut.iki.fi>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/11/2020 19:45, Aaro Koskinen wrote:
> Hi,
> 
> On Fri, Nov 27, 2020 at 10:52:41AM +0200, Tomi Valkeinen wrote:
>> When the SDI output was converted to DRM bridge, the atomic versions of
>> enable and disable funcs were used. This was not intended, as that would
>> require implementing other atomic funcs too. This leads to:
>>
>> WARNING: CPU: 0 PID: 18 at drivers/gpu/drm/drm_bridge.c:708 drm_atomic_helper_commit_modeset_enables+0x134/0x268
>>
>> and display not working.
>>
>> Fix this by using the legacy enable/disable funcs.
>>
>> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>> Fixes: 8bef8a6d5da81b909a190822b96805a47348146f ("drm/omap: sdi: Register a drm_bridge")
>> Cc: stable@vger.kernel.org # v5.7+
>> Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> 
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Thanks! I pushed this to drm-misc-fixes. Hopefully with this and Sebastian's patch N900 display now
works.

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
