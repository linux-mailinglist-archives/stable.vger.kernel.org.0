Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8148E4F44B2
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245013AbiDEM2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381268AbiDELnj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 07:43:39 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BA6114FC3;
        Tue,  5 Apr 2022 04:09:06 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 65CC922247;
        Tue,  5 Apr 2022 13:09:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649156944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HhCRNMxeN/GjO55RvomQG0xoJmMvvbdrMDnAktj+ZOw=;
        b=cNqMfgmXtFPvgEEwbWq+VnwdvMuscRpK20137u0iJSnBDLVHoJFUu5w4qyLSMk8UBd8eum
        0HMbGVUDIyLdMdlDNStBDi+KY7vBSzta24pjZddLL/yJGIlyoEPC3VL3TgfKTOY12IUtu8
        hkJrB7ZhYGB9P1u1D5xx4Y+a7XRIo5o=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 05 Apr 2022 13:09:04 +0200
From:   Michael Walle <michael@walle.cc>
To:     Codrin.Ciubotariu@microchip.com
Cc:     Nicolas.Ferre@microchip.com, alexandre.belloni@bootlin.com,
        Claudiu.Beznea@microchip.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
In-Reply-To: <360914ee-594c-86bc-2436-aa863a67953a@microchip.com>
References: <20220303161724.3324948-1-michael@walle.cc>
 <46e1be55-9377-75b7-634d-9eadbebc98d7@microchip.com>
 <bc32f1107786ebcbfb4952e1a6142304@walle.cc>
 <360914ee-594c-86bc-2436-aa863a67953a@microchip.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <27f124c9adaf8a4fbdfb7a38456c4a2e@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2022-04-05 12:02, schrieb Codrin.Ciubotariu@microchip.com:
> On 05.04.2022 12:38, Michael Walle wrote:
>> Am 2022-04-05 11:23, schrieb Codrin.Ciubotariu@microchip.com:
>>>> +       if (dev->use_dma) {
>>>> +               dma_buf = i2c_get_dma_safe_msg_buf(m_start, 1);
>>> 
>>> If you want, you could just dev->buf = i2c_get_dma_safe...
>> 
>> But where is the error handling in that case? dev->buf will
>> be NULL, which is eventually passed to dma_map_single().
>> 
>> Also, I need the dma_buf for the i2c_put_dma_safe_msg_buf()
>> call anyway, because dev->buf will be modified during
>> processing.
> 
> You still:
> 	if (!dev->buf) {
> 		ret = -ENOMEM;
> 		goto out;
> 	}
> 
> So, at91_do_twi_transfer()/dma_map_single() will not be called.

Ahh, I misunderstood you. Yes, but as I said, I need the dma_buf
temporary variable anyway, because dev->buf is modified, eg. see
at91_twi_read_data_dma_callback().

-michael
