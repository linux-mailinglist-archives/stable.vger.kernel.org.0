Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B56A1E0F87
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 15:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390776AbgEYNcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 09:32:11 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:54183 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390754AbgEYNcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 09:32:10 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id 244513C057C;
        Mon, 25 May 2020 15:32:07 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1IwUF-psCmTU; Mon, 25 May 2020 15:32:01 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id E8C5E3C0022;
        Mon, 25 May 2020 15:32:01 +0200 (CEST)
Received: from lxhi-065.adit-jv.com (10.72.94.46) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 25 May
 2020 15:32:01 +0200
Date:   Mon, 25 May 2020 15:31:57 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] media: vsp1: dl: Fix NULL pointer dereference on unbind
Message-ID: <20200525133157.GA19608@lxhi-065.adit-jv.com>
References: <20200523081334.23531-1-erosca@de.adit-jv.com>
 <d4544b1b-a695-bd70-0ccb-e2fb1838f3f8@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d4544b1b-a695-bd70-0ccb-e2fb1838f3f8@ideasonboard.com>
X-Originating-IP: [10.72.94.46]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kieran,

On Mon, May 25, 2020 at 02:19:02PM +0100, Kieran Bingham wrote:
> Hi Eugeniu,
> 
> Yeouch. Looks like I really missed a trick there!

Not a big deal. The good part is that it can be proactively fixed and
shared across the community.

> 
> We should probably update the $SUBJECT to match what is performed in the
> patch, which is perhaps more like:
> 
> "media: vsp1: dl: Store VSP reference when creating cmd pools"

To be honest, I am not a big fan of WHAT summary lines.
Rather, I prefer the WHY summary lines (and I think everyone should).

> 
> On 23/05/2020 09:13, Eugeniu Rosca wrote:
> 
> And then we can explain here:
> 
> In commit f3b98e3c4d2e16 ("media: vsp1: Provide support for extended
> command pools"), the vsp pointer used for referencing the VSP1 device
> structure from a command pool during vsp1_dl_ext_cmd_pool_destroy() was
> not populated.
> 
> Correctly assign the pointer to prevent the following
> null-pointer-dereference when removing the device:

That sounds good and I can push this improved description as v2.

> > Fixes: f3b98e3c4d2e16 ("media: vsp1: Provide support for extended command pools")
> > Cc: stable@vger.kernel.org # v4.19+
> > Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> > 
> > How about adding a new unit test perfoming unbind/rebind to
> > http://git.ideasonboard.com/renesas/vsp-tests.git, to avoid
> > such issues in future? 
> 
> Yes, now I wish I had done so back at 4.19! I hope this wasn't too
> painful to diagnose and fix, and thank you for being so thorough in your
> report!
> 
> 
> > Locally, below command has been used to identify the problem:
> > 
> > for f in $(find /sys/bus/platform/devices/ -name "*vsp*" -o -name "*fdp*"); do \
> >      b=$(basename $f); \
> >      echo $b > $f/driver/unbind; \
> > done
> > 
> 
> I've created a test to add to vsp-tests, which I'll post next, thank you
> for the suggestion.
> 
> Before your patch is applied, I experience the same crash you have seen,
> and after your patch - I can successfully unbind/bind all of the VSP1
> instances.
> 
> So I think you can have this too:
> 
> Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Awesome. Thanks!

-- 
Best regards,
Eugeniu Rosca
