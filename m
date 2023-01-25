Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF44467B75C
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 17:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbjAYQvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 11:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjAYQvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 11:51:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7DC10D7
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 08:51:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 891E96155E
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 16:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCA1C433EF;
        Wed, 25 Jan 2023 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674665506;
        bh=+r0kU6pjXK5//2Fm9fH5yKeNCigRPZdjicUREH7YWq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sSxTdjlCTw6cNJDoe+aE30bRp2AhiJh5NcYwqS7ksbEx0Lvwb/8/CJOhDCVykXdDP
         gO0fVMoAjfsIKIITr+JM/hTJx6zfmI5XSsp1E8/cNX7sRGps2FumkQryI/uwhG0SNM
         9FvJ0Etj+830RaR42Z6HblGlJ3GTwpuQJPBB2W2E=
Date:   Wed, 25 Jan 2023 17:51:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ian Abbott <abbotti@mev.co.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.14] comedi: adv_pci1760: Fix PWM instruction handling
Message-ID: <Y9FeH6iOxyDsEdw2@kroah.com>
References: <20230123103641.9000-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123103641.9000-1-abbotti@mev.co.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 10:36:41AM +0000, Ian Abbott wrote:
> commit 2efb6edd52dc50273f5e68ad863dd1b1fb2f2d1c upstream.
> 
> (Actually, this is fixing the "Read the Current Status" command sent to
> the device's outgoing mailbox, but it is only currently used for the PWM
> instructions.)
> 
> The PCI-1760 is operated mostly by sending commands to a set of Outgoing
> Mailbox registers, waiting for the command to complete, and reading the
> result from the Incoming Mailbox registers.  One of these commands is
> the "Read the Current Status" command.  The number of this command is
> 0x07 (see the User's Manual for the PCI-1760 at
> <https://advdownload.advantech.com/productfile/Downloadfile2/1-11P6653/PCI-1760.pdf>.
> The `PCI1760_CMD_GET_STATUS` macro defined in the driver should expand
> to this command number 0x07, but unfortunately it currently expands to
> 0x03.  (Command number 0x03 is not defined in the User's Manual.)
> Correct the definition of the `PCI1760_CMD_GET_STATUS` macro to fix it.
> 
> This is used by all the PWM subdevice related instructions handled by
> `pci1760_pwm_insn_config()` which are probably all broken.  The effect
> of sending the undefined command number 0x03 is not known.
> 
> Fixes: 14b93bb6bbf0 ("staging: comedi: adv_pci_dio: separate out PCI-1760 support")
> Cc: <stable@vger.kernel.org> # v4.5+
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> Link: https://lore.kernel.org/r/20230103143754.17564-1-abbotti@mev.co.uk
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Should apply OK to v4.5 to v4.18 inclusive. [IA]

Now queued up,t hanks.

greg k-h
