Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3759545E6A
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 10:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347384AbiFJIRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 04:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347393AbiFJIRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 04:17:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E40226557;
        Fri, 10 Jun 2022 01:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B68AB83080;
        Fri, 10 Jun 2022 08:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48450C3411B;
        Fri, 10 Jun 2022 08:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654849023;
        bh=IyeUl084OKLUA3ct/9HrNTTAqajQrjHZwP2dAxU/Z/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kAuOpgXOymuZ6MpR8gpXyN5R+sRLj7kzoSs6Tk+e7j4RGG9QTecv8U/pkwbrxB3Yw
         t+z8QnLOrI9U1WSiP//O5zDTH+Eb6QpAI86RLoCEn2ThvanCsBa+HrYPZcceRiOpiR
         DAD1KU1I0xniSugVMM4UlGyhF3sAUENpH1c3p3XvymhVeecxNCU03/F2I3GXu8GLHd
         Xj0Mh+zBwTHn1sFnTb86WmtbaQQsY4ERc+rz5QhKxWid+BfTtNlrt4ePyBpOyvqIde
         SxGvKh2NMUTuuJ+spzZRvcnvdENNc74ORA+Ib/yZGmD+lyGN9MMhjFbdM4o1rqLqKB
         oBeZrmTWvrDAQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nzZpC-0007NZ-Pc; Fri, 10 Jun 2022 10:16:58 +0200
Date:   Fri, 10 Jun 2022 10:16:58 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jared Kangas <kangas.jd@gmail.com>, elder@kernel.org,
        greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-staging@lists.linux.dev
Subject: Re: [greybus-dev] Re: [PATCH v2] staging: greybus: audio: fix loop
 cursor use after iteration
Message-ID: <YqL9+sx15/rqLlSZ@hovoldconsulting.com>
References: <20220609214517.85661-1-kangas.jd@gmail.com>
 <YqL6A3pVC8LOqE4d@hovoldconsulting.com>
 <20220610080627.GA2146@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610080627.GA2146@kadam>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 11:06:27AM +0300, Dan Carpenter wrote:
> On Fri, Jun 10, 2022 at 10:00:03AM +0200, Johan Hovold wrote:
> > > Fixes: 510e340efe0c ("staging: greybus: audio: Add helper APIs for dynamic audio modules")
> > > Cc: stable@vger.kernel.org
> > > Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > Reviewed-by: Johan Hovold <johan@kernel.org>
> > > Signed-off-by: Jared Kangas <kangas.jd@gmail.com>
> > > ---
> > > 
> > > Changes since v1:
> > >  * Removed safe list iteration as suggested by Johan Hovold <johan@kernel.org>
> > >  * Updated patch changelog to explain the list iteration change
> > >  * Added tags to changelog based on feedback (Cc:, Fixes:, Reviewed-by:)
> > 
> > Apparently Greg applied this to staging-next before we had a change to
> > look at it. You should have received a notification from Greg when he
> > did so.
> > 
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-next&id=80c968a04a381dc0e690960c60ffd6b6aee7e157
> > 
> > It seems unlikely that this would cause any issues in real life, but
> > there's still a chance it will be picked up by the stable team despite
> > the lack of a CC stable tag.
> 
> If you want you can always email the stable team to pick up the patch.

Yes, of course. But it will be months before this fix hits mainline and
I probably won't remember to do so then.

I'm pretty sure Sasha's autosel tool will pick it up anyway, though.

Johan
