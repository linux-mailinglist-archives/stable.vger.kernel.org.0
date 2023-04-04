Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BE26D602F
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 14:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbjDDMYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 08:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjDDMX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 08:23:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF7A2D66
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 05:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680611019; x=1712147019;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YIxPVV74jrYRfkOZDeh8wMhARh9e3pNboTGTsGxQLVQ=;
  b=B5ejneRltv0d3TzIxqi0+1S9YeXY3+kr8TkxjwSDrBrhRaX4ORLhwL+v
   cAvp6PN19VIwdlnP00dEg0kZdhEp0d0RGqh1fLMqgr1/6Ww/ZchyhDruX
   JnkGKRkhAd9fJ81J3zQOQnpgXb8/9V+BxAywRE7n84WHfv8ErgyRGyYhO
   d2dTxvEQEbomkIL6zm7AvJl9jG95aRzJYmUGNTkjboLdd+zw8wVeCFd3P
   WsV714xw5vUAlNFFQc20nd5NE3BM/KELBcViht1DfrqMvqXinELTPOvBe
   N504VJBJuY/wrACw9vUVds+c9MFHyBMWuliQXexdd99QPVOpaPoxq7tqN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="343862788"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="343862788"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 05:23:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="750895933"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="750895933"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 04 Apr 2023 05:23:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id D30C613A; Tue,  4 Apr 2023 15:23:02 +0300 (EEST)
Date:   Tue, 4 Apr 2023 15:23:02 +0300
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        Sanju Mehta <Sanju.Mehta@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [PATCH 5.10 063/173] thunderbolt: Use const qualifier for
 `ring_interrupt_index`
Message-ID: <20230404122302.GQ33314@black.fi.intel.com>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140416.499791738@linuxfoundation.org>
 <ZCwKBSQSbj3Ka4on@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZCwKBSQSbj3Ka4on@duo.ucw.cz>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, Apr 04, 2023 at 01:29:09PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Mario Limonciello <mario.limonciello@amd.com>
> > 
> > commit 1716efdb07938bd6510e1127d02012799112c433 upstream.
> > 
> > `ring_interrupt_index` doesn't change the data for `ring` so mark it as
> > const. This is needed by the following patch that disables interrupt
> > auto clear for rings.
> 
> Yeah, nice cleanup. But do we really need it in -stable?

Yes, it was followed by a fix patch that needs this:

468c49f44759 ("thunderbolt: Disable interrupt auto clear for rings")

I marked both for stable but perhaps the latter did not apply cleanly
for v5.10?
