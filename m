Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE403F6F00
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 07:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhHYFwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 01:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232420AbhHYFwN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Aug 2021 01:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 049396120A;
        Wed, 25 Aug 2021 05:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629870688;
        bh=EkE46jl8gJG1dqg3qD9AbJi+AfleBAOlIUcWmS/5YLo=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=tD/CeEVXnGHCUDjGQJjhgBbYJFEiOqqI00YOi1gEFuReyH9Z42oWRm8i4DbQQ8CpK
         nFn97Ljhz2IeWNJ1yTDndwjXnRLm0atAxN2r3u3np/rXh2IGYxhQ4DBD0DC9YKJxY6
         NCcR/yhkNjDW6ggu+3cWIcNr0MqdyrjZMmag/79kE3IpiAQhrD5upiw2tOuG2uEVpm
         Cr4dHxbV9q5Q4kyl/ukTCyujpvBtYY+C73VPnJnZfNuTvYm7eySgbjMNw+Y8Ibnqrg
         12mfKAkqEogMS6s7zug3Q5SPW+m6AQ37ryyXrcNj1fDL/qZyb1F8fnwovuThW3ortb
         6GVfVtIr3Rqtw==
References: <20210825042855.7977-1-wcheng@codeaurora.org>
User-agent: mu4e 1.6.4; emacs 27.2
From:   Felipe Balbi <balbi@kernel.org>
To:     Wesley Cheng <wcheng@codeaurora.org>
Cc:     gregkh@linuxfoundation.org, Thinh.Nguyen@synopsys.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        jackp@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH v5] usb: dwc3: gadget: Stop EP0 transfers during pullup
 disable
Date:   Wed, 25 Aug 2021 08:51:08 +0300
In-reply-to: <20210825042855.7977-1-wcheng@codeaurora.org>
Message-ID: <874kbe6pib.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Wesley Cheng <wcheng@codeaurora.org> writes:

> During a USB cable disconnect, or soft disconnect scenario, a pending
> SETUP transaction may not be completed, leading to the following
> error:
>
>     dwc3 a600000.dwc3: timed out waiting for SETUP phase
>
> If this occurs, then the entire pullup disable routine is skipped and
> proper cleanup and halting of the controller does not complete.
>
> Instead of returning an error (which is ignored from the UDC
> perspective), allow the pullup disable routine to continue, which
> will also handle disabling of EP0/1.  This will end any active
> transfers as well.  Ensure to clear any delayed_status also, as the
> timeout could happen within the STATUS stage.
>
> Cc: <stable@vger.kernel.org>
> Fixes: bb0147364850 ("usb: dwc3: gadget: don't clear RUN/STOP when it's invalid to do so")
> Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>

Acked-by: Felipe Balbi <balbi@kernel.org>

-- 
balbi
