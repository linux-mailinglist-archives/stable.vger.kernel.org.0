Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2CA4A2E64
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 12:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbiA2Lwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 06:52:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35072 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiA2Lwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 06:52:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67E5B60B90
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 11:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A8FC340E5;
        Sat, 29 Jan 2022 11:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643457164;
        bh=44o7VmfM2ePTS9zv4aeSY7V7JZpor7g4E8hLY1N6alM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=am4V4eHuzLMfxwoU4xMZD7yZC0jT45vOblnFdmogB7ogSpFV9xfDeS3/MEpEHS6/K
         Os5MrZ3GjW34p5TiM0J9LVscw28Dfdncx/e/a6fK/VHhHQHCW6jNiqEdZMCsxqSmOd
         qbGPIsYcGMzyZ9CLJyt/Nou7ta0b8V0GcnyYnvfE=
Date:   Sat, 29 Jan 2022 12:52:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Bertholon <guillaume.bertholon@ens.fr>
Cc:     stable@vger.kernel.org
Subject: Re: Misplaced patch application? (stable/linux-4.4.y)
Message-ID: <YfUqikHXokp75E00@kroah.com>
References: <10ff8d1e-60d8-2f93-98d1-d1671dd412f8@ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10ff8d1e-60d8-2f93-98d1-d1671dd412f8@ens.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 05:09:46PM +0100, Guillaume Bertholon wrote:
> I'm working on a tool for (reliably) transferring diffs across
> versions of a given C code. To evaluate my tool, I have been comparing
> the output of my tool against the manual backports in the stable
> branch.
> 
> In the process, I have found some oddities in some backported patches
> which, I believe, are incorrect. In all cases, the root cause seems to
> be that `patch` was able to apply a backported diff after some fuzzy
> matching but did so at a wrong location (IMHO). Below is an example. I
> can report the others if there is indeed a problem.
> 
> 
> On the branch stable/linux-4.4.y, the upstream patch
> 
>    b560a208cda0297fef6ff85bbfd58a8f0a52a543
>    Bluetooth: MGMT: Fix not checking if BT_HS is enabled
> 
> is backported as commit
> 
>    5abe9f99f5129bee5492072ff76b91ec4fad485b.
> 
> 
> If we look at both commits we have:
> 
> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
> Upstream
>   b560a208cda0297fef6ff85bbfd58a8f0a52a543
> %%%%%%%%%
> 
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 0b711ad..12d7b36 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> [...]
> @@ -1817,6 +1818,10 @@ static int set_hs(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
>  
>         bt_dev_dbg(hdev, "sock %p", sk);
>  
> +       if (!IS_ENABLED(CONFIG_BT_HS))
> +               return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
> +                                      MGMT_STATUS_NOT_SUPPORTED);
> +
>         status = mgmt_bredr_support(hdev);
>         if (status)
>                 return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS, status);
> 
> %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
> Backported
>   5abe9f99f5129bee5492072ff76b91ec4fad485b
> %%%%%%%%%
> 
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index ecc3da6..ee761fb 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> [...]
> @@ -2281,6 +2282,10 @@ static int set_link_security(struct sock *sk, struct hci_dev *hdev, void *data,
>  
>         BT_DBG("request for %s", hdev->name);
>  
> +       if (!IS_ENABLED(CONFIG_BT_HS))
> +               return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
> +                                      MGMT_STATUS_NOT_SUPPORTED);
> +
>         status = mgmt_bredr_support(hdev);
>         if (status)
>                 return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_LINK_SECURITY,
> 
> 
> I suspect that this does *not* reflect the intent of the orignal patch
> (which was addressing an issue in `set_hs`) whereas, here, the
> backported patch is somewhat arbitrarily modifying `set_link_security`
> while `set_hs` remains as-is.
> 
> Is this indeed an issue? Should I report on the other cases as well?

Yes, this looks like an incorrect backport, nice catch!

Can you send a fixup patch for this so that I can apply it and give you
the correct credit for finding and fixing it?

Also, yes, if you have other reports of this, it would be great to let
us know.

thanks

greg k-h
