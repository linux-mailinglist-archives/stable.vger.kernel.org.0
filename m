Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9739C5EEDE8
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 08:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiI2Gaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 02:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiI2Gay (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 02:30:54 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CF6ECCC9;
        Wed, 28 Sep 2022 23:30:52 -0700 (PDT)
X-UUID: 8919806823b145e6b5b1a48f52bed778-20220929
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=6kRxtmHTsdu+ZgQ5hqeQQZoJ5CfeIzgNxRzM6lCvc2I=;
        b=oW907LWcPNEBpq4DeYfhe61SEQKBfIkZxYrueh9Diw/uKu5gXvXZ8QKRu5ReYPJA5WQdcgau2cAQrr9L6aAA6OS42sHI1siwmuIp0CDnbROaoJgzVORTIf319k6eAsEx802ZXPoyV7Ndboug5qfKyx/8p7Y204DHTXIrJRPmbhQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:ba016c60-ec2d-41f7-9e04-5fa4f433474f,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:45
X-CID-INFO: VERSION:1.1.11,REQID:ba016c60-ec2d-41f7-9e04-5fa4f433474f,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:45
X-CID-META: VersionHash:39a5ff1,CLOUDID:6c8b76a3-dc04-435c-b19b-71e131a5fc35,B
        ulkID:220928214318FAL666HN,BulkQuantity:208,Recheck:0,SF:28|17|19|48|823|8
        24|102,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:ni
        l,COL:0
X-UUID: 8919806823b145e6b5b1a48f52bed778-20220929
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2096322386; Thu, 29 Sep 2022 14:30:47 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 29 Sep 2022 14:30:46 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Sep 2022 14:30:45 +0800
Message-ID: <cfd35493a293cf6f7ddd68fe3cc665989ea36015.camel@mediatek.com>
Subject: Re: [PATCH 1/2] usb: mtu3: fix ep0's stall of out data stage
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Alan Stern <stern@rowland.harvard.edu>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        <Stable@vger.kernel.org>
Date:   Thu, 29 Sep 2022 14:30:45 +0800
In-Reply-To: <YzRofTAx+3pPCbrL@rowland.harvard.edu>
References: <20220928091721.26112-1-chunfeng.yun@mediatek.com>
         <YzRofTAx+3pPCbrL@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY,URIBL_CSS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-09-28 at 11:30 -0400, Alan Stern wrote:
> On Wed, Sep 28, 2022 at 05:17:20PM +0800, Chunfeng Yun wrote:
> > It happens when enable uvc function, the flow as below:
> > the controller switch to data stage, then call
> >     -> foward_to_driver() -> composite_setup() ->
> > uvc_function_setup(),
> > it send out an event to user layer to notify it call
> >     -> ioctl() -> uvc_send_response() -> usb_ep_queue(),
> > but before the user call ioctl to queue ep0's buffer, the host
> > already send
> > out data, but the controller find that no buffer is queued to
> > receive data,
> > it send out STALL handshake.
> > 
> > To fix the issue, don't send out ACK of setup stage to switch to
> > out data
> > stage until the buffer is available.
> 
> You might find it is better to use the delayed_status routines
> already 
> present in the Gadget core.  Instead of delaying the response to the 
> Setup packet of the second control transfer, delay the status
> response 
> to the first control transfer.
Ok, I'll try to use delayed_status to handle this issue.

Thanks a lot.

> 
> This approach has the advantage of working even when the second
> transfer 
> is not control but something else, such as bulk.
> 
> Also it agrees better with the way the USB spec intends control 
> transfers to work.  The UDC is not supposed to complete the status
> stage 
> of a control transfer until the gadget has fully processed the 
> transfer's information and is ready to go forward.
> 
> Alan Stern

