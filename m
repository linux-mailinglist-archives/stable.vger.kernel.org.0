Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B1610ED0F
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfLBQXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbfLBQXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 11:23:03 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5347020722;
        Mon,  2 Dec 2019 16:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575303783;
        bh=1W62lKAHoX5DFVxI9rx8bmsU7wU6WRiSLV5A7U3IC5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nqNFbnCmu5370+RZw0nARYvEnKSc1g4bIs190QpCKRLz71StfxfHy0IEbjarkQYN9
         AaHn45/ZdBvgEiHWG3bY7gPr6oGqP9J2qhNuNHbFDH9CApMFKTotxuyQ5IHvEGqM5N
         W8pSmyOzV58AkwfgtUL0ENFojjTT5bpkhs9edaJw=
Date:   Tue, 3 Dec 2019 01:22:56 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-nvme@lists.infradead.org,
        Ingo Brunberg <ingo_brunberg@web.de>,
        Sagi Grimberg <sagi@grimberg.me>, stable@vger.kernel.org
Subject: Re: [PATCH] nvme: Namepace identification descriptor list is optional
Message-ID: <20191202162256.GA21631@redsun51.ssa.fujisawa.hgst.com>
References: <20191202155611.21549-1-kbusch@kernel.org>
 <20191202161545.GA7434@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202161545.GA7434@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 05:15:45PM +0100, Christoph Hellwig wrote:
> On Tue, Dec 03, 2019 at 12:56:11AM +0900, Keith Busch wrote:
> > Despite NVM Express specification 1.3 requires a controller claiming to
> > be 1.3 or higher implement Identify CNS 03h (Namespace Identification
> > Descriptor list), the driver doesn't really need this identification in
> > order to use a namespace. The code had already documented in comments
> > that we're not to consider an error to this command.
> > 
> > Return success if the controller provided any response to an
> > namespace identification descriptors command.
> > 
> > Fixes: 538af88ea7d9de24 ("nvme: make nvme_report_ns_ids propagate error back")
> > Reported-by: Ingo Brunberg <ingo_brunberg@web.de>
> 
> Why would we ignore the error?  Do you have a buggy controller messing
> this up?

I don't have such a controller, but many apparently do. The regression
was reported here:

http://lists.infradead.org/pipermail/linux-nvme/2019-December/028223.html

And of course it's the SMI controller ...
