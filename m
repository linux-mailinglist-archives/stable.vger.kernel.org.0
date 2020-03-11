Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35261181518
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 10:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgCKJhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 05:37:24 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46472 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKJhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 05:37:23 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02B9atgq028018;
        Wed, 11 Mar 2020 04:36:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583919415;
        bh=0JRFgr4NmiP0aLkGZCbyApBsu2XHe2TVda8KoTp5/WU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=UHB1vbWOzaCZa45+8bo+Bp4jT9i7a8JJnbmPnkHUJPxMp7mtvHGEk3w2MuKiwDNF7
         zR+8TIpzcharR8xCm/vC9+SsjIm8Q91GETZ5dDibWydoKRWgwi9wytOGWx1Z9ja5hC
         Kjon5U3bGtbpVmo+1ERcW4GOOC4cL/w+VgeDoPKA=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02B9atoF062705
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Mar 2020 04:36:55 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 11
 Mar 2020 04:36:55 -0500
Received: from localhost.localdomain (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 11 Mar 2020 04:36:54 -0500
Received: from [10.24.69.157] (ileax41-snat.itg.ti.com [10.172.224.153])
        by localhost.localdomain (8.15.2/8.15.2) with ESMTP id 02B9an1h047577;
        Wed, 11 Mar 2020 04:36:50 -0500
Subject: Re: [PATCH 3/4] mmc: sdhci-omap: Fix busy detection by enabling
 MMC_CAP_NEED_RSP_BUSY
To:     Ulf Hansson <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>
CC:     Adrian Hunter <adrian.hunter@intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        <mirq-linux@rere.qmqm.pl>, Bitan Biswas <bbiswas@nvidia.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Jon Hunter <jonathanh@nvidia.com>, <stable@vger.kernel.org>
References: <20200310153340.5593-1-ulf.hansson@linaro.org>
 <20200310153340.5593-4-ulf.hansson@linaro.org>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <caa76ea5-0f4e-6aac-5a3f-e2c9cd14a66f@ti.com>
Date:   Wed, 11 Mar 2020 15:08:37 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310153340.5593-4-ulf.hansson@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Uffe,

On 10/03/20 9:03 pm, Ulf Hansson wrote:
> It has turned out that the sdhci-omap controller requires the R1B response,
> for commands that has this response associated with them. So, converting
> from an R1B to an R1 response for a CMD6 for example, leads to problems
> with the HW busy detection support.
> 
> Fix this by informing the mmc core about the requirement, via setting the
> host cap, MMC_CAP_NEED_RSP_BUSY.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Reported-by: Anders Roxell <anders.roxell@linaro.org>
> Reported-by: Faiz Abbas <faiz_abbas@ti.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Thanks for sending this fix. I will more look into the underlying
behaviour once I'm back in office next week.

Tested-by: Faiz Abbas <faiz_abbas@ti.com>

Regards,
Faiz
