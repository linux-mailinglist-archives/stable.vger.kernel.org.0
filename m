Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB7C4C725F
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbiB1RRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbiB1RRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:17:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934925F77
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 09:16:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A81A6B81262
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 17:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0954C340E7;
        Mon, 28 Feb 2022 17:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646068595;
        bh=O6REpOa3GPR17KaKXPcS7kG0Ku4ZHB5KLBcu/iGD9t0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K3b6bI16gS+O34pYDtCrTUmoHnQLsW+a3hAC+4dffI6G1V4V6MdN7yOSr1ARwzFLq
         6dd1U5RAnZfZ9feVmXF2z5JZIOuu2G30jnxip/zj88wis25bi1rP4AidwvaFzsOOyb
         Ba+KyQ1FUMfsps+CHrMLgaB0EHVivw/FsPNgO1pc=
Date:   Mon, 28 Feb 2022 18:16:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kai =?iso-8859-1?Q?L=FCke?= <kailueke@linux.microsoft.com>
Cc:     stable@vger.kernel.org
Subject: Re: xfrm regression in 5.10.94
Message-ID: <Yh0Db4AJA0QBZ3iN@kroah.com>
References: <e2e9e487-1efb-783f-ca5b-7d0c88f8de7b@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2e9e487-1efb-783f-ca5b-7d0c88f8de7b@linux.microsoft.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 01:22:09PM +0100, Kai Lüke wrote:
> Hi,
> 
> in 5.10.94 these two xfrm changes cause userspace programs like Cilium to
> suddenly fail (https://github.com/cilium/cilium/pull/18789):
> - xfrm: interface with if_id 0 should return error
>   8dce43919566f06e865f7e8949f5c10d8c2493f5
> - xfrm: state and policy should fail if XFRMA_IF_ID 0
>   68ac0f3810e76a853b5f7b90601a05c3048b8b54
> 
> I see that these changes are a reaction to
> - xfrm: fix disable_xfrm sysctl when used on xfrm interfaces
>   9f8550e4bd9d
> but even if the "wrong" usage caused weird behavior I still wonder if it
> was the right decision to do the changes as part of a bugfix update for an
> LTS kernel.
> What do you think about reverting the changes at least for 5.10?

Why is 5.10 special and newer kernels are not?  This change shows up for
them, right?  Either this is a regression for all kernel releases and
needs to be resolved, or it is ok for any kernel release.

Please work with the networking developers to either resolve the
regression of determine what needs to be done here for userspace to work
properly.

thanks,

greg k-h
