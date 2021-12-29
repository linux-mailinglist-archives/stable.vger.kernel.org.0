Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB756480EA9
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 02:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbhL2BmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 20:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbhL2BmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 20:42:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6D1C061574;
        Tue, 28 Dec 2021 17:42:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D893B817E7;
        Wed, 29 Dec 2021 01:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A928C36AE7;
        Wed, 29 Dec 2021 01:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640742141;
        bh=Su1O4IV89rCzzKK53zNAgwO4p6ni95FZuEw/AqDVdqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VDJrVudFCLECWqXfUxQJga/US/idK52AS9gPuw2dT7H69Hr6/kyC9YbAak522JYM/
         iu8nU23jyeWmt8y2o9SYI+Mzj+TVVmBuq5Iso+Ja62wz0EXoAt0J+lde+h1sItTdaH
         JBafK0dRbdHwwFm2AaSe8DN8FMWrB8BqZWnWK0e79PEk37bwFjFNRNfUi9i8wiQXN5
         6iRafIGL6olCIro+qi+HW12cBN4cmF6ys+p4KJGl14+7x/7KVGNu1+VC++7eojt/mQ
         2UOpRlhbk8O6SpNWerrK4K4j789gwDKkMggq8oOKEdEW494bjjL5gzNohi9+YlKzHj
         1zZSen+LJTfXQ==
Date:   Wed, 29 Dec 2021 03:42:18 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tadeusz Struk <tstruk@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tpm: Fix error handling in async work
Message-ID: <Ycu8+gKE6dA9Jv1e@iki.fi>
References: <20211220211700.5772-1-tstruk@gmail.com>
 <YcuiIdorMLEjhJn6@iki.fi>
 <3c835b05-b476-4ea9-929f-0131fa7a3446@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c835b05-b476-4ea9-929f-0131fa7a3446@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 28, 2021 at 04:08:42PM -0800, Tadeusz Struk wrote:
> On 12/28/21 15:47, Jarkko Sakkinen wrote:
> > > When an invalid (non existing) handle is used in a tpm command,
> > > that uses the resource manager interface (/dev/tpmrm0) the resource
> > > manager tries to load it from its internal cache, but fails and
> > > returns an -EINVAL error to the caller. The existing async handler
> > > doesn't handle these error cases currently and the condition in the
> > > poll handler never returns mask with EPOLLIN set causing the userspace
> > > code to get stack. Make sure that error conditions also contribute
> > > to the poll mask so that a correct error code could passed back
> > > to the caller.
> > Can you instead describe a failure scenario? This is very cryptic.
> 
> The problem is that the poll call blocks and the application gets stuck
> until the tpm_timeout_work() wakes it up after 120 sec (jiffies + (120 * HZ)).
> I will update the description, fix all the typos, and resend it.
> 
> Thanks,
> Tadeusz

OK, great, thank you.

BR,
Jarkko
