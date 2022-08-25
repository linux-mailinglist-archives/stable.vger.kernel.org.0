Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B48A5A0FBA
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 13:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiHYL7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 07:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241021AbiHYL7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:59:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF4FA98E0;
        Thu, 25 Aug 2022 04:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2905A61B1C;
        Thu, 25 Aug 2022 11:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3782EC433D7;
        Thu, 25 Aug 2022 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661428748;
        bh=GLfsjUlNp9WLL2wELbBVeoTLtJbmnVEiPK7O3n+1NV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mghw3e3sHIr/tw03YSnhgwGtdVUsIfgD4OMxiU0g3yfZzBx6Gt4jvslnRHd3iJebx
         YY6j1jIqlllKpY3SSU5bnBrasc7WpFTXDKpAFxKLj/psqV/RWOGvcE5smvPCSCrh9h
         ZgdU8wZLOwJOXSgp94Ad2OxfmDiN6+Na3E6A6uYs=
Date:   Thu, 25 Aug 2022 13:59:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     sean.wang@mediatek.com
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 5.19] mt76: mt7921: fix command timeout in AP stop period
Message-ID: <YwdkCRXdOZCTdPQl@kroah.com>
References: <94065c608ee60d8a96a3d91913cb1e28d0a302e1.1661397440.git.objelf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94065c608ee60d8a96a3d91913cb1e28d0a302e1.1661397440.git.objelf@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 25, 2022 at 11:27:22AM +0800, sean.wang@mediatek.com wrote:
> From: Deren Wu <deren.wu@mediatek.com>
> 
> commit 9d958b60ebc2434f2b7eae83d77849e22d1059eb upstream.
> 
> Due to AP stop improperly, mt7921 driver would face random command timeout
> by chip fw problem. Migrate AP start/stop process to .start_ap/.stop_ap and
> congiure BSS network settings in both hooks.
> 
> The new flow is shown below.
> * AP start
>     .start_ap()
>       configure BSS network resource
>       set BSS to connected state
>     .bss_info_changed()
>       enable fw beacon offload
> 
> * AP stop
>     .bss_info_changed()
>       disable fw beacon offload (skip this command)
>     .stop_ap()
>       set BSS to disconnected state (beacon offload disabled automatically)
>       destroy BSS network resource
> 
> Fixes: 116c69603b01 ("mt76: mt7921: Add AP mode support")
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> Signed-off-by: Deren Wu <deren.wu@mediatek.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  .../wireless/mediatek/mt76/mt76_connac_mcu.c  |  2 +
>  .../net/wireless/mediatek/mt76/mt7921/main.c  | 47 +++++++++++++++----
>  .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  5 +-
>  .../wireless/mediatek/mt76/mt7921/mt7921.h    |  2 +
>  4 files changed, 43 insertions(+), 13 deletions(-)

Now queued up, thanks,

greg k-h
