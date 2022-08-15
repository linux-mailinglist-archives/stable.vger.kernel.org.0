Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CB8592EC4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 14:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiHOMPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 08:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241189AbiHOMPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 08:15:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E705DDC8
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 05:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F6A0CE1077
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 12:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAB3C433C1;
        Mon, 15 Aug 2022 12:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660565713;
        bh=oNXAfO4+P40tuMLHu76wzGad3avf9s37/g/p2jUH22Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e/4/AgIDA4LJeBIGp0fBRhbKaCY38RgV1JrqNE5zsmSweRNpPZ5i1MbwuzXkcSmO0
         YK65ONcHBJUgMyP4/POU56NfYvI3V1wHY8TB3yS9000eVgyxUUfe1rqVR/ZtNPXoZ9
         NdTFJzBZacVZvme+brZjlVEgpCoPEJrpujJoRUyw=
Date:   Mon, 15 Aug 2022 14:15:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 1/4] selftests/bpf: add selftest part of "bpf: Fix
 the off-by-two error in range markings"
Message-ID: <Yvo4zy8quy9lYall@kroah.com>
References: <20220809073947.33804-1-ovidiu.panait@windriver.com>
 <20220809073947.33804-2-ovidiu.panait@windriver.com>
 <Yvei3RLnHqGgb9yp@kroah.com>
 <ae246cb9-989d-9b41-89b3-fcb953add65d@windriver.com>
 <YvkKMEMC11MqZOqu@kroah.com>
 <029942ab-365d-0e69-7b5a-3b568518fd02@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029942ab-365d-0e69-7b5a-3b568518fd02@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 14, 2022 at 06:08:26PM +0300, Ovidiu Panait wrote:
> 
> On 8/14/22 17:44, Greg KH wrote:
> > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > 
> > On Sun, Aug 14, 2022 at 04:58:56PM +0300, Ovidiu Panait wrote:
> > > Hi Greg,
> > > 
> > > On 8/13/22 16:10, Greg KH wrote:
> > > > [Please note: This e-mail is from an EXTERNAL e-mail address]
> > > > 
> > > > On Tue, Aug 09, 2022 at 10:39:44AM +0300, Ovidiu Panait wrote:
> > > > > From: Maxim Mikityanskiy <maximmi@nvidia.com>
> > > > > 
> > > > > The 4.19 backport of upstream commit 2fa7d94afc1a ("bpf: Fix the off-by-two
> > > > > error in range markings") did not include the selftest changes, so currently
> > > > > there are 8 verifier selftests that are failing:
> > > > >    # root@intel-x86-64:~# ./test_verifier
> > > > >    ...
> > > > >    #495/p XDP pkt read, pkt_end > pkt_data', bad access 1 FAIL
> > > > >    #498/p XDP pkt read, pkt_data' < pkt_end, bad access 1 FAIL
> > > > >    #504/p XDP pkt read, pkt_data' >= pkt_end, bad access 1 FAIL
> > > > >    #513/p XDP pkt read, pkt_end <= pkt_data', bad access 1 FAIL
> > > > >    #519/p XDP pkt read, pkt_data > pkt_meta', bad access 1 FAIL
> > > > >    #522/p XDP pkt read, pkt_meta' < pkt_data, bad access 1 FAIL
> > > > >    #528/p XDP pkt read, pkt_meta' >= pkt_data, bad access 1 FAIL
> > > > >    #537/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 FAIL
> > > > >    Summary: 924 PASSED, 0 SKIPPED, 8 FAILED
> > > > > 
> > > > > Cherry-pick the selftest changes to fix these.
> > > > What specific "selftest changes" are you cherry-picking here?  I can't
> > > > take this commit without that reference.
> > > This patch includes the selftest part of upstream commit:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=2fa7d94afc1a
> > > 
> > > 
> > > The 4.19 backport of the above commit did not include the selftest updates:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=c315bd962528
> > I still do not understand, what commit is this coming from that matches
> > it up with what is in Linus's tree?
> The changes come from commit 2fa7d94afc1a ("bpf: Fix the off-by-two error in
> range markings") in Linus's tree.

Then can you please reword the text here to make it obvious what is
happening and resubmit?

thanks,

gre gk-h
