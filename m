Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8157557EDC
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 17:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiFWPsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 11:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiFWPsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 11:48:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406152DAA4
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 08:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3055B82452
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 15:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477D5C3411B;
        Thu, 23 Jun 2022 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655999287;
        bh=lSPqdqppVJ4EoMHkYpFekKRLhENLMbRjSPSeMJXhizc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HNyYcKn8CbSoWGlyq9KEKRgCdWBm6vXnCnZ7Spn25fvUkgO10DAPrPOMCXRGeXv3h
         KHa5ODoykX6ffnakzH4smXmNozuwxSiTyK9JntuTB2R76rdqfKH4L2bK4Q4vQwZWOA
         JMDuMaVPniTEwLmwgqhVxM8saUhz6ks1y0rCJa+0=
Date:   Thu, 23 Jun 2022 17:48:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Snitzer <snitzer@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, keescook@chromium.org,
        sarthakkukreti@google.com, stable@vger.kernel.org,
        Oleksandr Tymoshenko <ovt@google.com>, dm-devel@redhat.com,
        regressions@lists.linux.dev
Subject: Re: [5.4.y PATCH v2] dm: remove special-casing of bio-based
 immutable singleton target on NVMe
Message-ID: <YrSLNE35zJELb1Jf@kroah.com>
References: <20220610042200.2561917-1-ovt@google.com>
 <YqLTV+5Q72/jBeOG@kroah.com>
 <YqNfBMOR9SE2TuCm@redhat.com>
 <Yqb/sT205Lrhl6Bv@kroah.com>
 <20220615143642.GA2386944@roeck-us.net>
 <Yqn64AMwoIzQXwXM@redhat.com>
 <50eeff2e-45c5-5eb2-c41d-3e0092a84483@roeck-us.net>
 <Yqo63CvFpTDFnH3x@redhat.com>
 <YrBdsTDrreF3H82o@kroah.com>
 <YrHzOGO5fOSFwqdJ@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrHzOGO5fOSFwqdJ@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 12:35:04PM -0400, Mike Snitzer wrote:
> Commit 9c37de297f6590937f95a28bec1b7ac68a38618f upstream.
> 
> There is no benefit to DM special-casing NVMe. Remove all code used to
> establish DM_TYPE_NVME_BIO_BASED.
> 
> Also, remove 3 'struct mapped_device *md' variables in __map_bio() which
> masked the same variable that is available within __map_bio()'s scope.
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> ---
>  drivers/md/dm-table.c         | 32 +--------------
>  drivers/md/dm.c               | 73 ++++-------------------------------
>  include/linux/device-mapper.h |  1 -
>  3 files changed, 9 insertions(+), 97 deletions(-)

Now queued up, thanks.

greg k-h
