Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4610762E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 18:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKVRFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 12:05:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51592 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVRFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 12:05:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KLTSCBo9GrmIxlML9NXjcKsTYOt38qaSPc5RYyNYTYc=; b=PWztAYWaNbzXORsPKRgBq4QlE
        4TgQmDJM1ReeJUdFtb3/bZVCVfM3Y7u1EPllMHxvYPlj15uNy4CsrWGTauI5AGatcgsKKZNpXfG8N
        iAadYJ86yptwYD+K1utQD3x1qgmZBxWesKOON4nYpS+5VJ35TJl4PDtBR0ATF8UwtDxB7xV3re4Iz
        9gfdK1WuwwQF0umMcYrksozzGN9W8JqOl9Wo8EDF305QWZ8/bPd3JNjoxrL+GKyA6DxjVVBLYO1Bj
        IlrN5zgxjbHE0kgFfmA02phF0XdI0gzsz4PCxztld7lenv+k7pEwLmeHJoU6NBzNLfZKoFBH1pmXK
        PNRgunFMg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iYCNC-0005Gu-U8; Fri, 22 Nov 2019 17:05:34 +0000
Date:   Fri, 22 Nov 2019 09:05:34 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/220] 4.19.86-stable review
Message-ID: <20191122170534.GV20752@bombadil.infradead.org>
References: <20191122100912.732983531@linuxfoundation.org>
 <ae3d804f-594b-80f9-048b-7da45806278c@roeck-us.net>
 <20191122151631.GA2083451@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122151631.GA2083451@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 04:16:31PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Nov 22, 2019 at 06:47:05AM -0800, Guenter Roeck wrote:
> > On 11/22/19 2:26 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.86 release.
> > > There are 220 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > I see the following warning (at least for arm64, ppc64, and x86_64).
> > This seems to be caused by "idr: Fix idr_get_next race with idr_remove".
> > v4.14.y is also affected. Mainline and v5.3.y are not affected.

That makes sense; the code in question is different after 4.19.
Thanks for the report; it's very clear.

> Willy, this looks like something from your patch, is it to be expected?

It's harmless; the problem is that we can't check whether the dereference
is safe.  The caller isn't holding the RCU lock, and the IDR code doesn't
know what lock is being held to make this dereference safe.  Do you want
a changelog for this oneliner which disables the checking?

diff --git a/lib/idr.c b/lib/idr.c
index 49e7918603c7..6ff3b1c36e0a 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -237,7 +237,7 @@ void *idr_get_next(struct idr *idr, int *nextid)
 
 	id = (id < base) ? 0 : id - base;
 	radix_tree_for_each_slot(slot, &idr->idr_rt, &iter, id) {
-		entry = radix_tree_deref_slot(slot);
+		entry = rcu_dereference_raw(*slot);
 		if (!entry)
 			continue;
 		if (!radix_tree_deref_retry(entry))
