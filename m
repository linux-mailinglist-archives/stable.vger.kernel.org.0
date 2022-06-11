Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56AE5472A5
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 09:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiFKHc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 03:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiFKHc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 03:32:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25D1B0A6C;
        Sat, 11 Jun 2022 00:32:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACBBECE1AFB;
        Sat, 11 Jun 2022 07:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC21AC3411E;
        Sat, 11 Jun 2022 07:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654932772;
        bh=0L+NbLxu5/2Vf8Nu/sGq044kwZeuPfMPeOJvnd7ulEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X1ejGEtzXQNuZ40KpwuykTjm7Xh94aS1JPxEa8XqiAsFNj20GYZ0zhdKSX4sbwvh3
         G46dU1BG5xlQsxQd5VghamPbZf3XT2XlDg0X8hzk3NNcaaOZFovJahGEL0HQXHv1Lp
         X15B/wwyfTXUPJrMiq0yvMdUqh4gqQLWKA2KQS8I=
Date:   Sat, 11 Jun 2022 09:32:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Hewitt <christianshewitt@gmail.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        linux-usb@vger.kernel.org, linux-amlogic@lists.infradead.org,
        stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: Regression in 5.18.3 from "xhci: Set HCD flag to defer primary
 roothub registration"
Message-ID: <YqRFH2i3s/jL28ZG@kroah.com>
References: <743F7369-2794-4189-8891-5DA62E4B62DA@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <743F7369-2794-4189-8891-5DA62E4B62DA@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 11, 2022 at 10:49:23AM +0400, Christian Hewitt wrote:
> Commit 6c64a664e1cff339ec698d803fa8cbb9af5d95ce “xhci: Set HCD flag to defer
> primary roothub registration” added for Linux 5.18.3 caused a regression on
> some Amlogic S912 devices (original user forum report with an Android TV box
> and confirmed with a Khadas VIM2 board). I do not see issues with older S905
> (WeTeK Play2) or newer S922X (Odroid N2+) devices running the same kernel.
> There are no kernel splats or error messages but lsusb shows no output and
> nothing works. Simple revert restores the previous good working behaviour.
> 
> dmesg with commit http://ix.io/3ZTv
> dmesg with revert http://ix.io/3ZTw
> 
> I’m not a coder so will need to be fed instructions to assist with debugging
> the issue further if you don't have access to an Amlogic S912 device. I can
> share devices online for remote poking around if needed.

Does 5.19-rc1 also have this problem?

thanks,

greg k-h
