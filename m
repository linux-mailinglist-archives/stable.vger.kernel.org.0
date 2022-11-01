Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E91615024
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 18:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiKARL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 13:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiKARLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 13:11:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FF91DA76;
        Tue,  1 Nov 2022 10:11:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6DDB6CE1B1A;
        Tue,  1 Nov 2022 17:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B31AC433D6;
        Tue,  1 Nov 2022 17:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667322659;
        bh=bezW1uh0vxZ39Mjmv7SyAQVVd6Gda5D3lhDk5epzkZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MHhpVjRoKJJq+SVhUBxhP6gfSZJNUHwY3N207bB6jrp/UhLAIEyyk5MuYiz6xfQjB
         tg3Gjj0X9fcFCqLYnAdUgWD4wKHWwNrEBzbL9Qh7fvaHG3TK3uT0rvP9n2beRqiw0q
         47jtTuSfkOz4TwDVKuX/e7zi28PgTxNG8ekPzr0g=
Date:   Tue, 1 Nov 2022 18:11:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     kishon@ti.com, lpieralisi@kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, mie@igel.co.jp, kw@linux.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/5] tools: PCI: Fix parsing the return value of IOCTLs
Message-ID: <Y2FTWLw0tKuZ9Cdl@kroah.com>
References: <20220824123010.51763-1-manivannan.sadhasivam@linaro.org>
 <20220824123010.51763-3-manivannan.sadhasivam@linaro.org>
 <YwYdFt6sc7lZGRcg@kroah.com>
 <20221101141534.GQ54667@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101141534.GQ54667@thinkpad>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 01, 2022 at 07:45:34PM +0530, Manivannan Sadhasivam wrote:
> On Wed, Aug 24, 2022 at 02:44:06PM +0200, Greg KH wrote:
> > On Wed, Aug 24, 2022 at 06:00:07PM +0530, Manivannan Sadhasivam wrote:
> > > "pci_endpoint_test" driver now returns 0 for success and negative error
> > > code for failure. So adapt to the change by reporting FAILURE if the
> > > return value is < 0, and SUCCESS otherwise.
> > > 
> > > Cc: stable@vger.kernel.org #5.10
> > > Fixes: 3f2ed8134834 ("tools: PCI: Add a userspace tool to test PCI endpoint")
> > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > ---
> > >  tools/pci/pcitest.c | 41 +++++++++++++++++++++--------------------
> > >  1 file changed, 21 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/tools/pci/pcitest.c b/tools/pci/pcitest.c
> > > index 441b54234635..a4e5b17cc3b5 100644
> > > --- a/tools/pci/pcitest.c
> > > +++ b/tools/pci/pcitest.c
> > > @@ -18,7 +18,6 @@
> > >  
> > >  #define BILLION 1E9
> > >  
> > > -static char *result[] = { "NOT OKAY", "OKAY" };
> > >  static char *irq[] = { "LEGACY", "MSI", "MSI-X" };
> > >  
> > >  struct pci_test {
> > > @@ -54,9 +53,9 @@ static int run_test(struct pci_test *test)
> > >  		ret = ioctl(fd, PCITEST_BAR, test->barnum);
> > >  		fprintf(stdout, "BAR%d:\t\t", test->barnum);
> > >  		if (ret < 0)
> > > -			fprintf(stdout, "TEST FAILED\n");
> > > +			fprintf(stdout, "FAILED\n");
> > >  		else
> > > -			fprintf(stdout, "%s\n", result[ret]);
> > > +			fprintf(stdout, "SUCCESS\n");
> > 
> > Is this following the kernel TAP output rules?  If not, why not?  If so,
> > say that you are fixing that issue up in the changelog text.
> > 
> 
> Sorry to revive this two months old thread. Adapting to TAP output rules
> requires this test to be moved to KUnit which is strictly not necessary and can
> be done later.

KUint has nothing to do with TAP output.  TAP output is what the
framework in tools/testing/selftests/ wants to see.  Why not move this
test into the proper location there and not in an odd location like
tools/pci/?  It does not belong in tools/pci/ at all.

thanks,

greg k-h
