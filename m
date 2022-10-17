Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D58601A8C
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 22:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJQUs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 16:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJQUs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 16:48:27 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 17 Oct 2022 13:48:26 PDT
Received: from thorn.bewilderbeest.net (thorn.bewilderbeest.net [IPv6:2605:2700:0:5::4713:9cab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837C021E3C;
        Mon, 17 Oct 2022 13:48:26 -0700 (PDT)
Received: from hatter.bewilderbeest.net (97-113-250-99.tukw.qwest.net [97.113.250.99])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: zev)
        by thorn.bewilderbeest.net (Postfix) with ESMTPSA id 608DEF7;
        Mon, 17 Oct 2022 13:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bewilderbeest.net;
        s=thorn; t=1666039229;
        bh=PtDkX7PN/aXZdmcB5xQ1pSmiMMClWzn8+l9E46Zb+/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S1+0HT3xKjWKenhMqW7eFJIOAUQWxuFfz7VnDgIjyKHDkAmY/t7tYlnSonOA28j7T
         v/UBcLHfnMuvTAayb0FpaCJBY614VUMbzJSy/LY7Vbuvs36jZ/hjH2y22Xubj/hv2K
         KdqegozbG+83pOBx8Coyo4saSs6HvWuKjy9MWqBc=
Date:   Mon, 17 Oct 2022 13:40:27 -0700
From:   Zev Weiss <zev@bewilderbeest.net>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Jeffery <andrew@aj.id.au>, linux-usb@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Jae Hyun Yoo <quic_jaehyoo@quicinc.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: aspeed: Fix probe regression
Message-ID: <Y029u+ZZZikW4fYl@hatter.bewilderbeest.net>
References: <20221017053006.358520-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221017053006.358520-1-joel@jms.id.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 10:30:06PM PDT, Joel Stanley wrote:
>Since commit fc274c1e9973 ("USB: gadget: Add a new bus for gadgets"),
>the gadget devices are proper driver core devices, which caused each
>device to request pinmux settings:
>
> aspeed_vhub 1e6a0000.usb-vhub: Initialized virtual hub in USB2 mode
> aspeed-g5-pinctrl 1e6e2080.pinctrl: pin A7 already requested by 1e6a0000.usb-vhub; cannot claim for gadget.0
> aspeed-g5-pinctrl 1e6e2080.pinctrl: pin-232 (gadget.0) status -22
> aspeed-g5-pinctrl 1e6e2080.pinctrl: could not request pin 232 (A7) from group USB2AD  on device aspeed-g5-pinctrl
> g_mass_storage gadget.0: Error applying setting, reverse things back
>
>The vhub driver has already claimed the pins, so prevent the gadgets
>from requesting them too by setting the magic of_node_reused flag. This
>causes the driver core to skip the mux request.
>
>Reported-by: Zev Weiss <zev@bewilderbeest.net>
>Reported-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
>Fixes: fc274c1e9973 ("USB: gadget: Add a new bus for gadgets")
>Cc: stable@vger.kernel.org
>Signed-off-by: Joel Stanley <joel@jms.id.au>

Thanks Joel!

Tested-by: Zev Weiss <zev@bewilderbeest.net>

