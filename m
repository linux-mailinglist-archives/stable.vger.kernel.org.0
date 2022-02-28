Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8264C6A3B
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 12:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiB1LYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 06:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiB1LYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 06:24:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0624131B
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 03:24:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4B1F60FAB
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 11:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB06C340E7;
        Mon, 28 Feb 2022 11:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646047439;
        bh=FyoYaDzH1Bu2WavsLr6ua0mq9UBX5wxKYPzYYURqRak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AAI1c6qJWnuDWHhuE3/ztc7UHtF3tpwEeD0RRD4EbsHbvhdsEmGNl91r30JLLDVSN
         UP4AobDDLNwCv6lugwPghv+WDuF7TvstoIjQzsMf2ygFj2u4qu9OnTeDItXY15pyor
         b8TLnjQAWz9hKZOvmP2ivgo2bmbSk50s3ofWKFIA=
Date:   Mon, 28 Feb 2022 12:23:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 1/2] ice: Fix race conditions between virtchnl handling
 and VF ndo ops
Message-ID: <Yhywy/LYW38Aavxt@kroah.com>
References: <20220225202101.4077712-1-jacob.e.keller@intel.com>
 <YhytnJGxStO0Gai9@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhytnJGxStO0Gai9@kroah.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 12:10:20PM +0100, Greg KH wrote:
> On Fri, Feb 25, 2022 at 12:21:00PM -0800, Jacob Keller wrote:
> > From: Brett Creeley <brett.creeley@intel.com>
> > 
> > commit e6ba5273d4ede03d075d7a116b8edad1f6115f4d upstream.
> > 
> > [I had to fix the cherry-pick manually as the patch added a line around
> > some context that was missing.]
> 
> What stable tree(s) is this for?$

Looks like it applied only to 5.15.y.  Can you also provide backports
for the other older kernels that these are needed for?

thanks,

greg k-h
