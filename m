Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8B5431F3B
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhJROR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:17:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34387 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S233452AbhJRORl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:17:41 -0400
Received: (qmail 1048912 invoked by uid 1000); 18 Oct 2021 10:15:27 -0400
Date:   Mon, 18 Oct 2021 10:15:27 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Andrej Shadura <andrew.shadura@collabora.co.uk>
Cc:     =?utf-8?B?SmnFmcOt?= Kosina <jikos@kernel.org>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v2 1/2] HID: u2fzero: explicitly check for errors
Message-ID: <20211018141527.GA1048431@rowland.harvard.edu>
References: <20211018122144.25131-1-andrew.shadura@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018122144.25131-1-andrew.shadura@collabora.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 02:21:43PM +0200, Andrej Shadura wrote:
> The previous commit fixed handling of incomplete packets but broke error
> handling: offsetof returns an unsigned value (size_t), but when compared
> against the signed return value, the return value is interpreted as if
> it were unsigned, so negative return values are never less than the
> offset.
> 
> Fixes: 22d65765f211 ("HID: u2fzero: ignore incomplete packets without data")
> Fixes: 42337b9d4d95 ("HID: add driver for U2F Zero built-in LED and RNG")
> Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
> ---
>  drivers/hid/hid-u2fzero.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
> index d70cd3d7f583..5145d758bea0 100644
> --- a/drivers/hid/hid-u2fzero.c
> +++ b/drivers/hid/hid-u2fzero.c
> @@ -200,7 +200,7 @@ static int u2fzero_rng_read(struct hwrng *rng, void *data,
>  	ret = u2fzero_recv(dev, &req, &resp);
>  
>  	/* ignore errors or packets without data */
> -	if (ret < offsetof(struct u2f_hid_msg, init.data))
> +	if (ret < 0 || ret < offsetof(struct u2f_hid_msg, init.data))

Although the patch description does a good job of explaining what's 
happening, someone merely reading the code will most likely not 
understand.

One alternative is to add a comment.  Another is simply to force a 
signed integer comparison:

	if (ret < (ssize_t) offsetof(...

Alan Stern
