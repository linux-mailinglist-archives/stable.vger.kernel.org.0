Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E49354263
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 15:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbhDENlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 09:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhDENlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 09:41:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CD8E61245;
        Mon,  5 Apr 2021 13:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617630056;
        bh=axLSBPXCXMlm/lrh45DQZ6qDQqDq/rySkebWO0hHZDo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KGqWCmCdcxtjCxtkkwI+soJd9gO0pDG5k6/nJ4cRn10Vbb1YX+Djpi/CjzVF8buJn
         WbSWBWSWmxBK3wuME3ZCLqV9je/CbgglMlHO8qmdgAHifZnvx3IvyTNfPwh7MqqUur
         UDRQYtcZrVZ+XAs7VbHT2HFZKkbsIHcI8mRqI7Hc=
Date:   Mon, 5 Apr 2021 15:40:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joe Perches <joe@perches.com>, Miroslav Benes <mbenes@suse.cz>,
        Jessica Yu <jeyu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 03/74] module: merge repetitive strings in
 module_sig_check()
Message-ID: <YGsTZrlUSYufOk9N@kroah.com>
References: <20210405085024.703004126@linuxfoundation.org>
 <20210405085024.812932452@linuxfoundation.org>
 <35560933-d158-76ee-0034-0b5f43d9a3c2@omprussia.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35560933-d158-76ee-0034-0b5f43d9a3c2@omprussia.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 04:35:40PM +0300, Sergey Shtylyov wrote:
> On 4/5/21 11:53 AM, Greg Kroah-Hartman wrote:
> 
> > From: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> > 
> > [ Upstream commit 705e9195187d85249fbb0eaa844b1604a98fbc9a ]
> > 
> > The 'reason' variable in module_sig_check() points to 3 strings across
> > the *switch* statement, all needlessly starting with the same text.
> > Let's put the starting text into the pr_notice() call -- it saves 21
> > bytes of the object code (x86 gcc 10.2.1).
> > 
> > Suggested-by: Joe Perches <joe@perches.com>
> > Reviewed-by: Miroslav Benes <mbenes@suse.cz>
> > Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> > Signed-off-by: Jessica Yu <jeyu@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  kernel/module.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/module.c b/kernel/module.c
> > index ab1f97cfe18d..9fe3e9b85348 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2908,16 +2908,17 @@ static int module_sig_check(struct load_info *info, int flags)
> >  		 * enforcing, certain errors are non-fatal.
> >  		 */
> >  	case -ENODATA:
> > -		reason = "Loading of unsigned module";
> > +		reason = "unsigned module";
> >  		goto decide;
> >  	case -ENOPKG:
> > -		reason = "Loading of module with unsupported crypto";
> > +		reason = "module with unsupported crypto";
> >  		goto decide;
> >  	case -ENOKEY:
> > -		reason = "Loading of module with unavailable key";
> > +		reason = "module with unavailable key";
> >  	decide:
> >  		if (is_module_sig_enforced()) {
> > -			pr_notice("%s is rejected\n", reason);
> > +			pr_notice("%s: loading of %s is rejected\n",
> > +				  info->name, reason);
> 
>    Mhm, in 5.4 there was no printing of 'info->name'...

Is that now a problem?

thanks,

greg k-h
