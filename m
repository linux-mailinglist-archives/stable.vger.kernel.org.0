Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A3D23BB07
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 15:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgHDNUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 09:20:35 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39010 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbgHDNUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 09:20:01 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 074DJuGW081139;
        Tue, 4 Aug 2020 08:19:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596547196;
        bh=jUNY6jTL/9ubZMKmxFGaYcTEXbPw/6WdqYgsSJaAX7k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=czIepNklkq/wGjw2MUbN9VHtYt4AM9tKwDXKtjqZEVzyyaZ/PAaYdlX3ajx8wAzN1
         8q/vaL2rzS0s2N2tLtKMhlCTnaRmPXDKqP4reHMLXBXGJ7uTVkrO1k8jANIBeH4MkP
         K4uY9eoGdB66s7ngGxPpo07kQIkvWJrx3WuNcEZw=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 074DJuCd033039
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Aug 2020 08:19:56 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 4 Aug
 2020 08:19:56 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 4 Aug 2020 08:19:56 -0500
Received: from [192.168.2.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 074DJtKL070869;
        Tue, 4 Aug 2020 08:19:55 -0500
Subject: Re: [PATCH] omapfb: dss: Fix max fclk divider for omap36xx
To:     Adam Ford <aford173@gmail.com>, stable <stable@vger.kernel.org>
CC:     Adam Ford-BE <aford@beaconembedded.com>
References: <20200709121232.9827-1-aford173@gmail.com>
 <CAHCN7x+crwfE4pfufad_WEUhiJQXccSZHot+YNDZzZKvqhrmWA@mail.gmail.com>
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <86992356-b902-d7da-ffd7-e8b98f9252fd@ti.com>
Date:   Tue, 4 Aug 2020 16:19:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHCN7x+crwfE4pfufad_WEUhiJQXccSZHot+YNDZzZKvqhrmWA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/08/2020 16:13, Adam Ford wrote:
> 
> 
> On Thu, Jul 9, 2020 at 7:12 AM Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>> wrote:
> 
>     There appears to be a timing issue where using a divider of 32 breaks
>     the DSS for OMAP36xx despite the TRM stating 32 is a valid
>     number.  Through experimentation, it appears that 31 works.
> 
>     This same fix was issued for kernels 4.5+.  However, between
>     kernels 4.4 and 4.5, the directory structure was changed when the
>     dss directory was moved inside the omapfb directory. That broke the
>     patch on kernels older than 4.5, because it didn't permit the patch
>     to apply cleanly for 4.4 and older.
> 
>     A similar patch was applied to the 3.16 kernel already, but not to 4.4.
>     Commit 4b911101a5cd ("drm/omap: fix max fclk divider for omap36xx") is
>     on the 3.16 stable branch with notes from Ben about the path change.
> 
>     Since this was applied for 3.16 already, this patch is for kernels
>     3.17 through 4.4 only.
> 
>     Fixes: f7018c213502 ("video: move fbdev to drivers/video/fbdev")
> 
>     Cc: <stable@vger.kernel.org <mailto:stable@vger.kernel.org>> #3.17 - 4.4
>     CC: <tomi.valkeinen@ti.com <mailto:tomi.valkeinen@ti.com>>
>     Signed-off-by: Adam Ford <aford173@gmail.com <mailto:aford173@gmail.com>>
> 
> 
> Tomi,
> 
> Can you comment on this?  The 4.4 is still waiting for this fix.  The other branches are fixed.

Looks good to me.

Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
