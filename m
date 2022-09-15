Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521915B9532
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 09:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiIOHY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 03:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIOHY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 03:24:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098832A243;
        Thu, 15 Sep 2022 00:24:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A8E962152;
        Thu, 15 Sep 2022 07:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BAEC433D7;
        Thu, 15 Sep 2022 07:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663226694;
        bh=0aoY9jAPeP1iaMtU9S62GisNAxOIxu+F67GJSsoRT7c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TrexW+Fu/l5QwrL7gje6PAlzhjF87HujHmCO4CCBUFvb3MaDb0Tda752b2bs+Vk0x
         +46xVX5Z7mXbVO4ug0uS5T3D6sU33TY49OkmyMS5uUxuFWoWfKlxSuk0RiY5UzEySI
         qUjco3SGK0vW60zFJm+SR9NxjZxO5DMx/riHJZDo=
Date:   Thu, 15 Sep 2022 09:25:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jason Wittlin-Cohen <jwittlincohen@gmail.com>
Cc:     regressions@lists.linux.dev, stable@vger.kernel.org,
        linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        bvanassche@acm.org, Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [REGRESSION] introduced in 5.10.140 causes drives to drop from
 LSI SAS controller (Bisected to 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269)
Message-ID: <YyLTXk4RlTcFgCQY@kroah.com>
References: <CADy0EvLGJmZe-x9wzWSB6+tDKNuLHd8Km3J5MiWWYQRR2ctS3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADy0EvLGJmZe-x9wzWSB6+tDKNuLHd8Km3J5MiWWYQRR2ctS3A@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 14, 2022 at 10:21:04PM -0400, Jason Wittlin-Cohen wrote:
> #regzbot introduced 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269
> 
> Issue: When running a 5.10.140 kernel compiled from kernel.org source, or a
> bisected kernel with commit 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269, 6 of
> the 48 drives attached to my LSI 9207-8e SAS HBA (P20 firmware, IT mode)
> will drop from the controller shortly after the boot process completes.  At
> this point, the drives are not visible to the LSI controller, verified
> using LSI's lsiutil.x86_64 to list all attached devices, nor are the drives
> enumerated in /dev/disk/by-id. Attempts to access the drives result in I/O
> errors reported in syslog. At some point thereafter, the drives reappear
> and are accessible.
> 
> Running a vanilla 5.10.139 kernel or a bisected kernel with commit
> 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269 removed, all 48 drives appear
> correctly, are listed in LSI's lsiutil tool, and appear in /dev/disk/by-id.
> No I/O errors are reported from any drive and none of the drives drop off
> the controller as experienced in 5.10.140.  SMART testing shows normal
> results for all impacted drives.

Does this also have problems in the latest 5.15 and 5.19 release, or is
it somehow limited to 5.10.y?

Also, html emails are rejected by the mailing lists, so you might want
to resend it all in text-only mode so that everyone can see the full
details.

thanks,

greg k-h
