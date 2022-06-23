Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A37B557EF8
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 17:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiFWPxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 11:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiFWPxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 11:53:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E5920BC4;
        Thu, 23 Jun 2022 08:53:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27FA5B8245A;
        Thu, 23 Jun 2022 15:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB61C3411B;
        Thu, 23 Jun 2022 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655999581;
        bh=e9iS9st1mjPHEkaMJhYHl7sOW2PmxFr0Kcqm4Or7Q7s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SbubtzDL+WgojpHFsKrNHVMbjyZZXbAFsOrlw3ONLcwaqjckf2uYEMSiy0FQtnGo1
         mpRWN+/UUSQpltvf0NFAZumJxTFry7FiAbq7YsCq+CYIqEuX9GAyykAer433H1VKLK
         1HEeijKXENW+mVj+TlBDfIKK8OojyfAZ98mFqMrU=
Date:   Thu, 23 Jun 2022 17:52:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marian Postevca <posteuca@mutex.one>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Maximilian Senftleben <kernel@mail.msdigital.de>,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] usb: gadget: u_ether: fix regression in setting
 fixed MAC address
Message-ID: <YrSMW6A6Ej8EHxq2@kroah.com>
References: <20220622201805.4315-1-posteuca@mutex.one>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622201805.4315-1-posteuca@mutex.one>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 22, 2022 at 11:18:04PM +0300, Marian Postevca wrote:
> commit b337af3a4d6147000b7ca6b3438bf5c820849b37 upstream.
> 
> In systemd systems setting a fixed MAC address through
> the "dev_addr" module argument fails systematically.
> When checking the MAC address after the interface is created
> it always has the same but different MAC address to the one
> supplied as argument.
> 
> This is partially caused by systemd which by default will
> set an internally generated permanent MAC address for interfaces
> that are marked as having a randomly generated address.
> 
> Commit 890d5b40908bfd1a ("usb: gadget: u_ether: fix race in
> setting MAC address in setup phase") didn't take into account
> the fact that the interface must be marked as having a set
> MAC address when it's set as module argument.
> 
> Fixed by marking the interface with NET_ADDR_SET when
> the "dev_addr" module argument is supplied.
> 
> Reported-by: Maximilian Senftleben <kernel@mail.msdigital.de>
> Cc: stable@vger.kernel.org
> Fixes: 890d5b40908bfd1a ("usb: gadget: u_ether: fix race in setting MAC address in setup phase")
> Signed-off-by: Marian Postevca <posteuca@mutex.one>
> ---
>  drivers/usb/gadget/function/u_ether.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

All now queued up, thanks.

greg k-h
