Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF973EDDE6
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 21:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhHPTbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 15:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhHPTbE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 15:31:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E5860E76;
        Mon, 16 Aug 2021 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629142233;
        bh=DxEqcZW45zJUiMURvvvNQVHFj6LuwzgYwo1VSNLXGhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hvtr5MIkxxgr5073QkCcZFdDYqpdP/RHj8iXn8/QKtmkDC7594BkCEmCWN+hbf3DD
         h7/UH4Uv0mcnoYFaJFoCJqly8+OaS+kse4KYpsZ5W7nfQwJXR70SumjdSxfUxvcGXo
         h/zdWaPcJKkeQA7YAI1m4Jzl+HOapR0D+hK+xwKQ=
Date:   Mon, 16 Aug 2021 21:30:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Chen <david.chen@nutanix.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "neeraju@codeaurora.org" <neeraju@codeaurora.org>
Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Message-ID: <YRq81jcZIH5+/ZpB@kroah.com>
References: <CO1PR02MB8489A10983A22C72447EEB5C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CO1PR02MB8489A10983A22C72447EEB5C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 07:19:34PM +0000, David Chen wrote:
> Hi Greg,
> 
> We recently hit a hung task timeout issue in synchronize_rcu_expedited on 4.14 branch.
> The issue seems to be identical to the one described in `fd6bc19d7676 rcu: Fix missed wakeup of exp_wq waiters`
> Can we backport it to 4.14 and 4.19 branch?
> The patch doesn't apply cleanly, but it should be trivial to resolve, just do this
> 
> -		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp->expedited_sequence) & 0x3]);
> +		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
> 
> I don't know if we should do it for 4.9, because the handling of sequence number is a bit different.

Please provide a working backport, me hand-editing patches does not
scale, and this way you get the proper credit for backporting it (after
testing it).

You have tested, this, right?

thanks,

greg k-h
