Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4206891BB
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 09:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjBCIOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 03:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjBCIOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 03:14:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A10953F8
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 00:13:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D30861E1A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 08:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6ACC433EF;
        Fri,  3 Feb 2023 08:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675412010;
        bh=lyEgaAZcuMDBI3cHVybswPt2FGb8WZAwiVFKregNfL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z9Ph75IYunkyQ5ulLruPCr8P297OWudzTl5RtobvD0TfnaGbMJgk/hgCN2t+K1OJz
         iGp5EE3tGKaHy2wi2Tyxn9L6a7TeAoMIj4Ya9nUz6bz9f0clQZ51O855vJWbcTENjv
         DkzjlmOmz7TGneQ235bb2cintxTLJJMYARaxjyuQ=
Date:   Fri, 3 Feb 2023 09:13:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Cc:     stable@vger.kernel.org, Soenke Huster <soenke.huster@eknoes.de>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: Re: [PATCH 5.4/5.10/5.15] Bluetooth: fix null ptr deref on
 hci_sync_conn_complete_evt
Message-ID: <Y9zCJtmGgrjTVZK8@kroah.com>
References: <20230201102456.1385087-1-ovidiu.panait@eng.windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201102456.1385087-1-ovidiu.panait@eng.windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 12:24:56PM +0200, Ovidiu Panait wrote:
> From: Soenke Huster <soenke.huster@eknoes.de>
> 
> commit 3afee2118132e93e5f6fa636dfde86201a860ab3 upstream.
> 
> This event is just specified for SCO and eSCO link types.
> On the reception of a HCI_Synchronous_Connection_Complete for a BDADDR
> of an existing LE connection, LE link type and a status that triggers the
> second case of the packet processing a NULL pointer dereference happens,
> as conn->link is NULL.
> 
> Signed-off-by: Soenke Huster <soenke.huster@eknoes.de>
> Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@eng.windriver.com>
> ---
> This fixes "BUG: KASAN: use-after-free in sco_chan_del()" issue detected while
> fuzzing with syzkaller.

Now queued up, thanks.

greg k-h
