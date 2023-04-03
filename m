Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790E46D45BD
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbjDCN0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjDCN0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:26:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52C62BEF7
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3828B81A5E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 13:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE87C433D2;
        Mon,  3 Apr 2023 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680528348;
        bh=L138vPHR75kmkUWpEtwhWFWzdRizjIzyKpOaEuCTQIo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=quvGq6mJ/24wT7Dsjx9RSc5q5GR9JT3j8FuHMIm3E9+TUav/qsaKv0a4nXALGWYvu
         T2KKv1E9xGT52Qu8LD5hA4dhdN5pmyYF9XvJ/q1VuRsardGA+2UryUbiZ0Wf1QFWpF
         jhSxHFJCwpniNnfEsEs1xp/M/noTE8d+FYMBKKiA=
Date:   Mon, 3 Apr 2023 15:25:46 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "hdegoede@redhat.com" <hdegoede@redhat.com>,
        "heikki.krogerus@linux.intel.com" <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCH] usb: ucsi: Fix ucsi->connector race
Message-ID: <2023040323-secluding-unicycle-cf5e@gregkh>
References: <16800048817970@kroah.com>
 <20230329080358.29193-1-joakim.tjernlund@infinera.com>
 <9e01760d96a5e235631f9e6d73a4dcb21aaeaf41.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e01760d96a5e235631f9e6d73a4dcb21aaeaf41.camel@infinera.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 04:28:56PM +0000, Joakim Tjernlund wrote:
> On Wed, 2023-03-29 at 10:03 +0200, Joakim Tjernlund wrote:
> > From: Hans de Goede <hdegoede@redhat.com>
> > 
> > ucsi_init() which runs from a workqueue sets ucsi->connector and
> > on an error will clear it again.
> > 
> > ucsi->connector gets dereferenced by ucsi_resume(), this checks for
> > ucsi->connector being NULL in case ucsi_init() has not finished yet;
> > or in case ucsi_init() has failed.
> > 
> > ucsi_init() setting ucsi->connector and then clearing it again on
> > an error creates a race where the check in ucsi_resume() may pass,
> > only to have ucsi->connector free-ed underneath it when ucsi_init()
> > hits an error.
> > 
> > Fix this race by making ucsi_init() store the connector array in
> > a local variable and only assign it to ucsi->connector on success.
> > 
> > Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> > Link: https://lore.kernel.org/r/20230308154244.722337-3-hdegoede@redhat.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > (cherry picked from commit 0482c34ec6f8557e06cd0f8e2d0e20e8ede6a22c)
> > Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> > ---
> > 
> >  - This is a dry port to 6.1.x, will be some time before it will be tested.
> 
> Tested OK now on 6.1.22

Thanks, now queued up for 6.2.y and 6.1.y.  Still need backports for
older kernels if you want to do that...

thanks,

greg k-h
