Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137755AE71C
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiIFMBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiIFMBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:01:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524BF7820C;
        Tue,  6 Sep 2022 05:01:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 67F83CE172A;
        Tue,  6 Sep 2022 12:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D68C433D7;
        Tue,  6 Sep 2022 12:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465686;
        bh=Yav+h0VTv5tt52gmMWFYcYIwIXPGXHBi+zS+x2j38xk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P/BByVuDjSwwN+9PFwoDlY0gFdX4CTBhVP2Ra7x8US5S1APKsczf82eJ7qdePRuvG
         6ESS89J//u3N684WpKQKPztlJDLU2DSg6LV7RhdaQUSBvlL/bHk/Kow5iTGdW3QddN
         pzA5F4t8Szb1fJkDPeHi8PBdcDWhtvkGLTS/tlTk=
Date:   Tue, 6 Sep 2022 14:01:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH STABLE 5.4] btrfs: harden identification of a stale device
Message-ID: <Yxc2k7m+7DTqYoMR@kroah.com>
References: <73979e98c7edc6690959f1d5e9e8d2bb678a8101.1661473186.git.anand.jain@oracle.com>
 <YxHLiLPd0IfKrpT5@kroah.com>
 <0c060fb0-5b43-c868-940c-221cc48e9889@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c060fb0-5b43-c868-940c-221cc48e9889@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 03, 2022 at 08:25:12PM +0800, Anand Jain wrote:
> On 9/2/22 17:23, Greg KH wrote:
> > On Fri, Sep 02, 2022 at 05:09:38PM +0800, Anand Jain wrote:
> > > commit 770c79fb65506fc7c16459855c3839429f46cb32 upstream
> > > 
> > > Identifying and removing the stale device from the fs_uuids list is done
> > > by btrfs_free_stale_devices().  btrfs_free_stale_devices() in turn
> > > depends on device_path_matched() to check if the device appears in more
> > > than one btrfs_device structure.
> > > 
> > > The matching of the device happens by its path, the device path. However,
> > > when device mapper is in use, the dm device paths are nothing but a link
> > > to the actual block device, which leads to the device_path_matched()
> > > failing to match.
> > > 
> > > Fix this by matching the dev_t as provided by lookup_bdev() instead of
> > > plain string compare of the device paths.
> > > 
> > > CC: stable@vger.kernel.org #5.4
> > > Reported-by: Josef Bacik <josef@toxicpanda.com>
> > > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > > Signed-off-by: David Sterba <dsterba@suse.com>
> > > ---
> > >   fs/btrfs/volumes.c | 44 +++++++++++++++++++++++++++++++++++++-------
> > >   1 file changed, 37 insertions(+), 7 deletions(-)
> > 
> > What about the same change for 5.10.y?
> > 
> 
> Thanks for reminding me.
> I have sent a separate patch for 5.10 as this patch won't apply to 5.10.

Both now queued up, thanks.

greg k-h
