Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B5614E78F
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 04:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbgAaDZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 22:25:19 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:17845 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727824AbgAaDZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 22:25:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580441119; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=WAfvMiZMUEfhKLTfw1eNZwP5qhJuiGUZbkD7wChQu+c=; b=VSy4XYv66gEU0KyfE9w8tRvw7gfwrc+zOd6mbmnd4vYkhhS8sK1Kb5mV1QXQZnRKjNRsEwBO
 sKxvuqJ80I9K2g/5bDR8Hw+VFcUyc1L7qk9Jnww7zReutkbllFdN0+DfSxfmKPEgj938OiXb
 IhtPjtNCFlM53H304u59xdUK1fw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e339e16.7fb6c37f5dc0-smtp-out-n03;
 Fri, 31 Jan 2020 03:25:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 75017C4479C; Fri, 31 Jan 2020 03:25:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from jackp-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jackp)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7079CC433CB;
        Fri, 31 Jan 2020 03:25:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7079CC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=jackp@codeaurora.org
Date:   Thu, 30 Jan 2020 19:25:01 -0800
From:   Jack Pham <jackp@codeaurora.org>
To:     Tejas Joglekar <Tejas.Joglekar@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        John Youn <John.Youn@synopsys.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: Fix logical condition
Message-ID: <20200131032501.GA10078@jackp-linux.qualcomm.com>
References: <cedf287bd185a5cbe31095d74e75b392f6c5263d.1573624581.git.joglekar@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cedf287bd185a5cbe31095d74e75b392f6c5263d.1573624581.git.joglekar@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tejas & Felipe,

On Wed, Nov 13, 2019 at 11:45:16AM +0530, Tejas Joglekar wrote:
> This patch corrects the condition to kick the transfer without
> giving back the requests when either request has remaining data
> or when there are pending SGs. The && check was introduced during
> spliting up the dwc3_gadget_ep_cleanup_completed_requests() function.
> 
> Fixes: f38e35dd84e2 ("usb: dwc3: gadget: split dwc3_gadget_ep_cleanup_completed_requests()")
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Tejas Joglekar <joglekar@synopsys.com>
> ---
>  drivers/usb/dwc3/gadget.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 86dc1db788a9..e07159e06f9a 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2485,7 +2485,7 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
>  
>  	req->request.actual = req->request.length - req->remaining;
>  
> -	if (!dwc3_gadget_ep_request_completed(req) &&
> +	if (!dwc3_gadget_ep_request_completed(req) ||
>  			req->num_pending_sgs) {
>  		__dwc3_gadget_kick_transfer(dep);
>  		goto out;

Been staring at this for a while--I think I see a potential issue but
not sure if it is or not.

If this condition is true and causes an early return, the 'ret' value
could be 0 which could allow the caller in cleanup_completed_requests()
to continue looping over the started_list and calling
cleanup_completed_request() again on the next req. But we just issued
another START or UPDATE transfer command on the previous incomplete req
and now the loop continued to try to reclaim the next TRB (and increment
the dequeue pointer and whatnot) when it might actually be in progress.

According to the code before f38e35dd84e2,

	list_for_each_entry_safe(req, tmp, &dep->started_list, list) {

	...
		if (!dwc3_gadget_ep_request_completed(req) ||
				req->num_pending_sgs) {
			__dwc3_gadget_kick_transfer(dep);
			break;
		}

The 'goto out' used to be a 'break', which terminates the list loop. But
with the refactored code, the loop can only terminate if 'ret' is
non-zero.

I haven't seen any real issue with the code as-is yet, but was just
wondering if the 'goto out' should be replaced with a return 1?

Jack
-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
