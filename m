Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D875AE73D
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbiIFMIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239513AbiIFMHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638007963B
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 05:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A140614E1
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 12:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BF8C433D6;
        Tue,  6 Sep 2022 12:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662466059;
        bh=ZHPw8Lxedogcq5zOGm4w2yzRi0/BQV/4J9kwMtrO2u0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y9ZoXwWDfJUsSiNBhvvhd7IkeNbKpZeFPUpkreDyPxmMQHPX3fiImox4+1LfH77DR
         uAigTacwIFpwPRYj2HFnQEnTkTt2UsXgfmGX8s07W2l6plIF6vgmTSMWfPa0CQMkXc
         ArhqYMFr6Z91oAy/QD/rat75CRsUQAuAx7wWqWTE=
Date:   Tue, 6 Sep 2022 14:07:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     peterz@infradead.org, stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing" failed
 to apply to 5.10-stable tree
Message-ID: <Yxc4CeyDS2tWLXfo@kroah.com>
References: <166176181110563@kroah.com>
 <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
 <YxB+xgcz9QD5BK77@kroah.com>
 <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 04:26:57PM +0200, Ben Hutchings wrote:
> On Thu, 2022-09-01 at 11:43 +0200, Greg KH wrote:
> > On Mon, Aug 29, 2022 at 04:04:58PM +0200, Ben Hutchings wrote:
> > > On Mon, 2022-08-29 at 10:30 +0200, gregkh@linuxfoundation.org wrote:
> > > > The patch below does not apply to the 5.10-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > > 
> > > 
> > > You need commit 4e3aa9238277 "x86/nospec: Unwreck the RSB stuffing"
> > > before this one.  I've attached the backport of that for 5.10.  I
> > > haven't checked the older branches.
> > 
> > Great, thanks, this worked.  But the backport did not apply to 4.19, so
> > I will need that in order to take this one as well.
> 
> I've had a look at 5.4, and it's sufficiently different from upstream
> that I don't see how to move forward.
> 
> However, I also found that the PBRSB mitigation seems broken, as commit
> fc02735b14ff "KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS"
> was not backported (and would be hard to add).
> 
> So, perhaps it would be best to revert the backports of:
> 
> 2b1299322016 x86/speculation: Add RSB VM Exit protections
> ba6e31af2be9 x86/speculation: Add LFENCE to RSB fill sequence
> 
> in stable branches older than 5.10.

Why?  Is it because they do not work at all there, or are they causing
problems?

thanks,

greg k-h
