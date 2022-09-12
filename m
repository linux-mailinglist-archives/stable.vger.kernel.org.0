Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3810B5B58B8
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiILKvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiILKvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:51:06 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F7E303EF;
        Mon, 12 Sep 2022 03:51:05 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 7720A6601FDD;
        Mon, 12 Sep 2022 11:51:03 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1662979864;
        bh=eZVd2qScKUD7WKyYFGW8QDa1tdf6w4+feyVXfFW/Kzs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BxUFu1cVBvCLQ4Mf/CdKdrnrk9hcqvlW7VwC1A7gO3J6QJymI1ksMkDm637fPWjXw
         FcTHR5qam11QfCG1Fxe0vKcnuIIuHBIKSrlGUgVLgheZkCigXlIKE7seT/jmXvl6tr
         AT5yv/rAz4sGZS1eR7xTQENRWqIgbjDTDJWxmOw1oz48sOm/Eh+wCGkDJ9a3L/nSb+
         hVOpJkujSNk2z6C5+e5LPj8k9qtZm3P53Js93J3Oa+Xte3siUsIpSwEKZncpFH7Wb+
         Jckwb/0Px1xKp1Yigy97qjbElqg1RZYK6mrYPDQJ29i9KlYSIFqUfEe+guZgTMrW0i
         cTUV7+RoVZ8/g==
Message-ID: <1d0a84f3-d5d9-5792-d79b-36f5f8cbd149@collabora.com>
Date:   Mon, 12 Sep 2022 12:51:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2] wifi: mt76: mt7921e: fix random fw download fail
Content-Language: en-US
To:     Deren Wu <Deren.Wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Soul Huang <Soul.Huang@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        Leon Yen <Leon.Yen@mediatek.com>,
        Eric-SY Chang <Eric-SY.Chang@mediatek.com>,
        KM Lin <km.lin@mediatek.com>,
        Robin Chiu <robin.chiu@mediatek.com>,
        CH Yeh <ch.yeh@mediatek.com>, Posh Sun <posh.sun@mediatek.com>,
        Stella Chang <Stella.Chang@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-mediatek <linux-mediatek@lists.infradead.org>,
        stable@vger.kernel.org
References: <1190a401463547e555912ef9417138df4ab2c363.1662972106.git.deren.wu@mediatek.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <1190a401463547e555912ef9417138df4ab2c363.1662972106.git.deren.wu@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il 12/09/22 10:45, Deren Wu ha scritto:
> From: Deren Wu <deren.wu@mediatek.com>
> 
> In case of PCIe interoperability problem shows up, the firmware
> payload may be corrupted in download stage. Turn off L0s to keep
> fw download process accurately.
> 
> [ 1093.528363] mt7921e 0000:3b:00.0: Message 00000007 (seq 7) timeout
> [ 1093.528414] mt7921e 0000:3b:00.0: Failed to start patch
> [ 1096.600156] mt7921e 0000:3b:00.0: Message 00000010 (seq 8) timeout
> [ 1096.600207] mt7921e 0000:3b:00.0: Failed to release patch semaphore
> [ 1097.699031] mt7921e 0000:3b:00.0: Timeout for driver own
> [ 1098.758427] mt7921e 0000:3b:00.0: Timeout for driver own
> [ 1099.834408] mt7921e 0000:3b:00.0: Timeout for driver own
> [ 1100.915264] mt7921e 0000:3b:00.0: Timeout for driver own
> [ 1101.990625] mt7921e 0000:3b:00.0: Timeout for driver own
> [ 1103.077587] mt7921e 0000:3b:00.0: Timeout for driver own
> [ 1104.173258] mt7921e 0000:3b:00.0: Timeout for driver own
> [ 1105.248466] mt7921e 0000:3b:00.0: Timeout for driver own
> [ 1106.336969] mt7921e 0000:3b:00.0: Timeout for driver own
> [ 1106.397542] mt7921e 0000:3b:00.0: hardware init failed
> 
> Cc: stable@vger.kernel.org
> Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
> Signed-off-by: Deren Wu <deren.wu@mediatek.com>

[For MT8195 Acer Tomato Chromebook]
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


