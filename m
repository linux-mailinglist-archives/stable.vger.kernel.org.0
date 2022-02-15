Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2284B68CD
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 11:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbiBOKGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 05:06:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbiBOKGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 05:06:40 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167DD6E4D7;
        Tue, 15 Feb 2022 02:06:28 -0800 (PST)
Received: from [10.10.2.52] (unknown [10.10.2.52])
        by mail.ispras.ru (Postfix) with ESMTPSA id 46CBB4076B21;
        Tue, 15 Feb 2022 10:06:26 +0000 (UTC)
Subject: Re: [PATCH 5.10 073/116] net: dsa: lantiq_gswip: dont use devres for
 mdiobus
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
References: <20220214092458.668376521@linuxfoundation.org>
 <20220214092501.284425363@linuxfoundation.org>
 <1e75b66a-295b-02bc-b4c5-421aec2cae96@ispras.ru>
 <20220215094549.7no3e2repjvpunyk@skbuf>
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
Autocrypt: addr=khoroshilov@ispras.ru; prefer-encrypt=mutual; keydata=
 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
 kK2E04Fb+Zk1eJvHYRc=
Message-ID: <3e589a89-2c5d-61e4-c81e-94a8bf728f7e@ispras.ru>
Date:   Tue, 15 Feb 2022 13:06:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220215094549.7no3e2repjvpunyk@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: ru-RU
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.02.2022 12:45, Vladimir Oltean wrote:
> On Tue, Feb 15, 2022 at 12:35:44PM +0300, Alexey Khoroshilov wrote:
>>>  	if (priv->ds->slave_mii_bus) {
>>>  		mdiobus_unregister(priv->ds->slave_mii_bus);
>>> +		mdiobus_free(priv->ds->slave_mii_bus);
>>>  		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
>>>  	}
>>
>>
>> Should
>>   of_node_put(priv->ds->slave_mii_bus->dev.of_node);
>> be here before
>>   mdiobus_free(priv->ds->slave_mii_bus);
>> ?
> 
> Thanks for noticing. Yes, this would avoid a use-after-free.
> Do you mind sending a patch to correct this?
> 

Surely, I will do.

--
Alexey
