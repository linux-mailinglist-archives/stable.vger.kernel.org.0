Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D335579B5
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiFWMCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 08:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiFWMCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 08:02:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881DB4ECC8;
        Thu, 23 Jun 2022 05:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF380B8204D;
        Thu, 23 Jun 2022 12:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CADC3411B;
        Thu, 23 Jun 2022 12:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655985621;
        bh=ArSOh3sXDik/3uQIsYcRTOicf6ioF0mn94WmvclKRx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HUtCKhSR5dJOEQabNBIy9YqpVCT7onPc3LN2njCaXiH9Few9vMSNZjfBIhovRw0Co
         aRwEmj5r4NMKLUgWR0SOBXHI/g99MknjPpbxdKcTLrH+4PmpEolKInBH6Hwbod8nSo
         ajzYp3c/lwoZgWxRWgUOsfrsCY0JPxkR5DF0+8SlA9O5pipj/Mo/FlmjW9OPZc83xZ
         3LWhGQoSByuVBUR/UNsVf4KZgcWew7+I9rC1U75vWT82xSNvMvzHwxKnRAuURh+xEI
         KRgewzZlyduOSMJu3DyXVnEeq4G8iocQ/Tf7EyvE+XxnqCBPPJMxeW0zOWCNzpnTzN
         aa4eDojZNF7rQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1o4LVM-0002S1-KV; Thu, 23 Jun 2022 14:00:13 +0200
Date:   Thu, 23 Jun 2022 14:00:12 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, stable@vger.kernel.org,
        Ballon Shi <ballon.shi@quectel.com>
Subject: Re: [PATCH v2] USB: serial: option: add Quectel RM500K module support
Message-ID: <YrRVzHktW3oelFaA@hovoldconsulting.com>
References: <20220623035214.20124-1-macpaul.lin@mediatek.com>
 <20220623085644.13105-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623085644.13105-1-macpaul.lin@mediatek.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 04:56:44PM +0800, Macpaul Lin wrote:
> Add usb product id of the Quectel RM500K module.
> 
> RM500K provides 2 mandatory interfaces to Linux host after enumeration.
>  - /dev/ttyUSB5: this is a serial interface for control path. User needs
>    to write AT commands to this device node to query status, set APN,
>    set PIN code, and enable/disable the data connection to 5G network.
>  - ethX: this is the data path provided as a RNDIS devices. After the
>    data connection has been established, Linux host can access 5G data
>    network via this interface.
> 
> "RNDIS": RNDIS + ADB + AT (/dev/ttyUSB5) + MODEM COMs
> 
> usb-devices output for 0x7001:

> Co-developed-by: Ballon Shi <ballon.shi@quectel.com>
> Signed-off-by: Ballon Shi <ballon.shi@quectel.com>
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Cc: stable@vger.kernel.org
> ---
> Change for v2:
>  - Update USB interfaces descriptions in the commit message.
>  - Fix typo, format and contributers in the commit message.
>  - Update PID definition in numeric order.

Thanks for the update. Now applied.

Johan
