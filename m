Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD9C6C9D9A
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 10:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbjC0IXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 04:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbjC0IXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 04:23:44 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC8DB5;
        Mon, 27 Mar 2023 01:23:43 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 06C9B6602087;
        Mon, 27 Mar 2023 09:23:41 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1679905422;
        bh=oMn8QjU8/8qTC6gWtoCH/9yMmplAzpyb0h0XKNTrk2M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=K5rfnodqvGxAWMjY8/S9KVsuWfTQAHGs0WoqV63XOC8E/2QNVMAjJ4HsHfyaYBd4K
         NKM2Xx2ObslQWygUvE3BLWJd30UvgTJxNEbZFuXdDpXqCAd8qFXlVuwbglZlrksm07
         9+7WYqd7QSu70VQOgHEPP6SnXIU2EiU1dDYZYWS6Dx/PoKDJsvSTYKcoCE8ZF1SooG
         djKOXCAd+t4coqU5dwMtmxzLPTENlBE9Twc2G5zHLUVxaX4+TuhW4yzpLAzkOVC3EZ
         R9r2AwlBGpPEzcRc7vT7jcy92j4Wr31u6uHoDydgtE7DbHU9XkN2iR25rowkP8fZ/X
         sqbZDbtqKlyZQ==
Message-ID: <8b07ead5-f105-da86-e7da-ee49616f7c1d@collabora.com>
Date:   Mon, 27 Mar 2023 10:23:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: kernel error at led trigger "phy0tpt"
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Tobias Dahms <dahms.tobias@web.de>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     stable@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-leds@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Linux regressions mailing list <regressions@lists.linux.dev>
References: <91feceb2-0df4-19b9-5ffa-d37e3d344fdf@web.de>
 <3fcc707b-f757-e74b-2800-3b6314217868@leemhuis.info>
 <fcecf6fc-bf18-73a0-9fc1-6850e183323a@web.de>
 <d14fb08c-70e3-4cc7-caf9-87e73eab9194@gmail.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <d14fb08c-70e3-4cc7-caf9-87e73eab9194@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il 26/03/23 15:23, Bagas Sanjaya ha scritto:
> On 3/26/23 02:20, Tobias Dahms wrote:
>> Hello,
>>
>> the bisection gives following result:
>> --------------------------------------------------------------------
>> 18c7deca2b812537aa4d928900e208710f1300aa is the first bad commit
>> commit 18c7deca2b812537aa4d928900e208710f1300aa
>> Author: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
>> Date:   Tue May 17 12:47:08 2022 +0200
>>
>>      soc: mediatek: pwrap: Use readx_poll_timeout() instead of custom
>> function
>>
>>      Function pwrap_wait_for_state() is a function that polls an address
>>      through a helper function, but this is the very same operation that
>>      the readx_poll_timeout macro means to do.
>>      Convert all instances of calling pwrap_wait_for_state() to instead
>>      use the read_poll_timeout macro.
>>
>>      Signed-off-by: AngeloGioacchino Del Regno
>> <angelogioacchino.delregno@collabora.com>
>>      Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
>>      Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
>>      Link:
>> https://lore.kernel.org/r/20220517104712.24579-2-angelogioacchino.delregno@collabora.com
>>      Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>>
>>   drivers/soc/mediatek/mtk-pmic-wrap.c | 60
>> ++++++++++++++++++++----------------
>>   1 file changed, 33 insertions(+), 27 deletions(-)
>> --------------------------------------------------------------------
>>
> 
> OK, I'm updating the regression status:
> 
> #regzbot introduced: 18c7deca2b8125
> 
> And for replying, don't top-post, but rather reply inline with
> appropriate context instead; hence I cut the replied context.
> 

There are two possible solutions to that, specifically, either:
  1. Change readx_poll_timeout() to readx_poll_timeout_atomic(); or
  2. Fix the mt6323-led driver so that this operation gets done
     out of atomic context, which is IMO the option to prefer.

Ideas?

Regards,
Angelo
