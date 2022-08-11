Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF6C58FA9A
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 12:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiHKKU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 06:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiHKKU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 06:20:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C602E2BF5
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 03:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45080B81F7D
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 10:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8104EC433C1;
        Thu, 11 Aug 2022 10:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660213250;
        bh=wfV7iUks0sh9F4mYp5R38PdJ90vrkjc7c7L1e9GJj8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MxE3dO5oKIVufZNyNBgmMIup7Yq2rZgn3vwYkzKzK6USjvppUH2CFqiKs3zJrItcL
         3dVb3261MAOHG2n79zyRXC+kd9SqxMijsxjUkUNGQiltOV8AFERa1FUOf7JCgX2O/S
         fznNoKhyZK6ZtlafXV2h99f3jK9F0up12yCmJyek=
Date:   Thu, 11 Aug 2022 12:20:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/1] selinux: drop super_block backpointer from
 superblock_security_struct
Message-ID: <YvTX/2vvCmt/2Y9+@kroah.com>
References: <20220808115922.331003-1-theflamefire89@gmail.com>
 <YvEPfSBGdBV0ZohA@kroah.com>
 <7769a909-9054-3215-dd3e-00bfb822d003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7769a909-9054-3215-dd3e-00bfb822d003@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 11:46:09AM +0200, Alexander Grund wrote:
> On 08.08.22 15:28, Greg KH wrote:
> > But, we only take patches that actually do something.  This one doesn't
> > do anything at all, and has no measurable performance or bugfix that I
> > can determine at all.
> 
> Isn't "doing less" also worth the patch?

Not if it doesn't actually fix something that a user sees.

> I mean this patch removes a superflous pointer of the superblock struct
> making the kernel use less memory.
> It also saves a code line and operation during init and removes the
> (somewhat hidden in syntax) superflous indirect access (and hence memory read)
> of a pointer already available (likely even in a register) during get/set_mnt_opts.
> 
> Of course the effect here is small but I think cleanups are always good to avoid
> a "death by a thousand cuts" scenario, i.e. that even small things help.

We do not take "cleanup patches" in stable trees without it being a
requirement for a real fix.  Please read the stable kernel rules
document again for what is actually allowed.

thanks,

greg k-h
