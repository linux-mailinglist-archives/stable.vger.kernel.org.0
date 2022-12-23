Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B710D65515E
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 15:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiLWOZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 09:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbiLWOZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 09:25:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDDD4083B
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 06:25:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33A8BB820E0
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 14:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C29C433D2;
        Fri, 23 Dec 2022 14:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671805510;
        bh=bSqJ7HcxpsttK/hyQGKkiIamfM+v5bCaZMyEdaGuXDw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0RdYyRIXYQPqy5f0h7kUevWHWLzJd7pII+PjQFdMrDlFUIKONxDUPP6Of2g5tmRX
         +VJEXVpwGORHDof8ZVE9ma4NbJh7evc01U8EcKh1SRxrCoyiO8rVknzEBqQb1wYHtf
         cwxOs3PHkzRQGh8+G8fTSyN2xKc4QIh3CryR5/Xo=
Date:   Fri, 23 Dec 2022 15:25:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sergio Callegari <sergio.callegari@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Possible regression with kernel 6.1.0 freezing (6.0.14 is fine)
 on haswell laptop
Message-ID: <Y6W6Qxwq94y9QGFl@kroah.com>
References: <cb697d4e-406b-169b-c595-6521f8481304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb697d4e-406b-169b-c595-6521f8481304@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 23, 2022 at 03:13:57PM +0100, Sergio Callegari wrote:
> Hi,
> 
> just a short note to report regular freezes with kernel 6.1.0 on a haswell
> laptop quad core Intel Core i7-4750HQ (-MT MCP-) with integrated graphics.
> 
> - system only freezes when launching the desktop environment (working on a
> text console while having the sddm login screen up, without logging in, does
> not seem to cause the issue);
> 
> - freezes happens a few seconds to a few minutes after getting to the
> desktop environment (that uses opengl and composition). Freeze happens both
> on X11 or Wayland.
> 
> - freeze seems to cause data loss (system not able to complete writes when
> the freeze occurs, data structures on disk get corrupted, e.g. system
> complained on broken btrfs snapshots made by timeshift-like app).
> 
> - system on freeze ceases responding to ping from the outside;
> 
> - upon reboot I cannot find any trace of any issue in the journal;
> 
> - on the same system booting kernels up to 6.0.14 is OK.

Can you use 'git bisect' to find the offending commit?

thanks,

greg k-h
