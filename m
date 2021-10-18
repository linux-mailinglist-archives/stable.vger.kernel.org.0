Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CF9431FF5
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhJROkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:40:42 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36273 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S231889AbhJROkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:40:35 -0400
Received: (qmail 1049768 invoked by uid 1000); 18 Oct 2021 10:38:23 -0400
Date:   Mon, 18 Oct 2021 10:38:23 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Andrej Shadura <andrew.shadura@collabora.co.uk>
Cc:     =?utf-8?B?SmnFmcOt?= Kosina <jikos@kernel.org>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v2 1/2] HID: u2fzero: explicitly check for errors
Message-ID: <20211018143823.GB1048431@rowland.harvard.edu>
References: <20211018122144.25131-1-andrew.shadura@collabora.co.uk>
 <20211018141527.GA1048431@rowland.harvard.edu>
 <z-9040e3ff-4fb2-97ba-3830-d32586385bf6@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <z-9040e3ff-4fb2-97ba-3830-d32586385bf6@collabora.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 04:17:57PM +0200, Andrej Shadura wrote:
> On 18/10/2021 16:15, Alan Stern wrote:
> > On Mon, Oct 18, 2021 at 02:21:43PM +0200, Andrej Shadura wrote:
> > > The previous commit fixed handling of incomplete packets but broke error
> > > handling: offsetof returns an unsigned value (size_t), but when compared
> > > against the signed return value, the return value is interpreted as if
> > > it were unsigned, so negative return values are never less than the
> > > offset.
> > > 
> > > Fixes: 22d65765f211 ("HID: u2fzero: ignore incomplete packets without data")
> > > Fixes: 42337b9d4d95 ("HID: add driver for U2F Zero built-in LED and RNG")
> > > Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>
> > > ---
> > >   drivers/hid/hid-u2fzero.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/hid/hid-u2fzero.c b/drivers/hid/hid-u2fzero.c
> > > index d70cd3d7f583..5145d758bea0 100644
> > > --- a/drivers/hid/hid-u2fzero.c
> > > +++ b/drivers/hid/hid-u2fzero.c
> > > @@ -200,7 +200,7 @@ static int u2fzero_rng_read(struct hwrng *rng, void *data,
> > >   	ret = u2fzero_recv(dev, &req, &resp);
> > >   	/* ignore errors or packets without data */
> > > -	if (ret < offsetof(struct u2f_hid_msg, init.data))
> > > +	if (ret < 0 || ret < offsetof(struct u2f_hid_msg, init.data))
> > 
> > Although the patch description does a good job of explaining what's
> > happening, someone merely reading the code will most likely not
> > understand.
> > 
> > One alternative is to add a comment.  Another is simply to force a
> > signed integer comparison:
> > 
> > 	if (ret < (ssize_t) offsetof(...
> 
> I have considered that, but I thought that is actually less readable than
> having two conditions. I’m curious that you say "ignore errors or packets
> without data" is not clear enough — how would you reword that without
> inflating it too much?

You misunderstand.  The existing comment is clear enough.  But the code 
itself is misleading:

	if (ret < 0 || ret < offsetof(...

looks redundant.  Someone reading it for the first time will 
automatically think: "If ret < 0 then certainly it is < the offset of 
some internal field.  So why perform two comparisons when one is 
enough?"

To help such a reader understand what is happening, you could add a 
comment like:

	/*
	 * offsetof returns an unsigned value, so the comparison with
	 * ret uses unsigned arithmetic and won't detect a negative
	 * error value.  We need a separate test for errors.
	 */

If you think a comment like this is preferable to a typecast, fine.

Another alternative is:

	ret -= offsetof(...);
	if (ret < 0)
		return 0;

which may look more complicated but allows you to simplify the max3 
computation in the next line.

Alan Stern
