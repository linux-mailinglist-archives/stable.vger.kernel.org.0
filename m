Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68325275A3
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 07:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfEWFl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 01:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfEWFl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 01:41:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F7F821019;
        Thu, 23 May 2019 05:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558590088;
        bh=rTm2QtayXzOcfjOZGDcaeMQ6Xk5vWjYR34rnIomr6hQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2C2YpKVT+7vclYNs9eGQ+yTBkPooawhkUsGQ9g8TxIwc43XcRJX1idnfMXNvD3im3
         jLg6fzuA5eQ0OpYvfWbUWXdUxaiDJYDTLg2iXURniZA+ZuPUoZjmpKw7T42RJSNQ/k
         dipRY2xmKM43FAG7LusZe2RuZXIzvm5cfsl3q6u8=
Date:   Thu, 23 May 2019 07:41:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Justin Forbes <jmforbes@linuxtx.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 5.0 119/123] s390/mm: convert to the generic
 get_user_pages_fast code
Message-ID: <20190523054125.GB16130@kroah.com>
References: <20190520115245.439864225@linuxfoundation.org>
 <20190520115253.074303494@linuxfoundation.org>
 <CAFxkdArho59CHxZi9K6oOm2NTDp0DL2XNv1TERfbJKqkXAiNVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFxkdArho59CHxZi9K6oOm2NTDp0DL2XNv1TERfbJKqkXAiNVA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 04:46:16PM -0500, Justin Forbes wrote:
> On Mon, May 20, 2019 at 7:30 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> >
> > commit 1a42010cdc26bb7e5912984f3c91b8c6d55f089a upstream.
> >
> > Define the gup_fast_permitted to check against the asce_limit of the
> > mm attached to the current task, then replace the s390 specific gup
> > code with the generic implementation in mm/gup.c.
> >
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> While this code seems to work fine upstream, when backported to 5.0 it
> fails to build:
> 
> BUILDSTDERR: In file included from ./include/linux/mm.h:98,
> BUILDSTDERR:                  from mm/gup.c:6:
> BUILDSTDERR: mm/gup.c: In function '__get_user_pages_fast':
> BUILDSTDERR: ./arch/s390/include/asm/pgtable.h:1277:28: error: too
> many arguments to function 'gup_fast_permitted'
> BUILDSTDERR:  #define gup_fast_permitted gup_fast_permitted
> BUILDSTDERR:                             ^~~~~~~~~~~~~~~~~~
> BUILDSTDERR: mm/gup.c:1856:6: note: in expansion of macro 'gup_fast_permitted'
> BUILDSTDERR:   if (gup_fast_permitted(start, nr_pages, write)) {
> 
> It is missing upstream commit ad8cfb9c42ef83ecf4079bc7d77e6557648e952b
> mm/gup: Remove the 'write' parameter from gup_fast_permitted()

Oops, thanks for catching this.  I'll go queue this patch up now.

greg k-h
