Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD3C5EE081
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 17:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbiI1PcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 11:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbiI1Pbx (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 28 Sep 2022 11:31:53 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 68912D1E89
        for <Stable@vger.kernel.org>; Wed, 28 Sep 2022 08:30:29 -0700 (PDT)
Received: (qmail 490088 invoked by uid 1000); 28 Sep 2022 11:30:05 -0400
Date:   Wed, 28 Sep 2022 11:30:05 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eddie Hung <eddie.hung@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        Stable@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: mtu3: fix ep0's stall of out data stage
Message-ID: <YzRofTAx+3pPCbrL@rowland.harvard.edu>
References: <20220928091721.26112-1-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928091721.26112-1-chunfeng.yun@mediatek.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 28, 2022 at 05:17:20PM +0800, Chunfeng Yun wrote:
> It happens when enable uvc function, the flow as below:
> the controller switch to data stage, then call
>     -> foward_to_driver() -> composite_setup() -> uvc_function_setup(),
> it send out an event to user layer to notify it call
>     -> ioctl() -> uvc_send_response() -> usb_ep_queue(),
> but before the user call ioctl to queue ep0's buffer, the host already send
> out data, but the controller find that no buffer is queued to receive data,
> it send out STALL handshake.
> 
> To fix the issue, don't send out ACK of setup stage to switch to out data
> stage until the buffer is available.

You might find it is better to use the delayed_status routines already 
present in the Gadget core.  Instead of delaying the response to the 
Setup packet of the second control transfer, delay the status response 
to the first control transfer.

This approach has the advantage of working even when the second transfer 
is not control but something else, such as bulk.

Also it agrees better with the way the USB spec intends control 
transfers to work.  The UDC is not supposed to complete the status stage 
of a control transfer until the gadget has fully processed the 
transfer's information and is ready to go forward.

Alan Stern
