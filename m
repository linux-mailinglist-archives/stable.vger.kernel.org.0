Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66F72A43C4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgKCLLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 06:11:13 -0500
Received: from smtp2.axis.com ([195.60.68.18]:33746 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgKCLLN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 06:11:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=1649; q=dns/txt; s=axis-central1;
  t=1604401873; x=1635937873;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i5CSmu9+LpfEutwG2UOnvj25IvZpi4qmAuz9g3NC5Qc=;
  b=QFgfz7uDqIPpnMqxFKPA6erjXBfr1uzssxifgvYtz8DNI2XKx6WoTdeW
   MGVqyFBkAY/+D6iFstGAU2J0lIpfCgARwdz9Dghd3AZwbKwOWYVFEEeZ0
   RTxFCkUwhKLHjEx/Fe3CspVKW9ijNL+JCWWZ2zvwLWVTyKEiD8G6KTJWj
   QAZPFkD37IClSzrh5xZ0j0w7IMZ3x4m7m3D0iyRkOsE2U1Sdp+NGl3ngM
   lgBPlqO5EiA9kyFcBXbDDSpaLY8NY4MRITwpkeooqI4JFLIlDASna8nHO
   zHbyGr4p9n7CV+quHK5qnrhJa/11rBw7ALRDgi/EGrcTf5v6jtKB9cwhR
   w==;
IronPort-SDR: 1Zd6dDNif6MAndOHT4gj7Z10l+3bhqzM3EjvXKyX742M+LLPkrr5GQ14ax3hbHMxn+H1LA8MF3
 SeetxIMiFXCYQbHhhCJa1CX3fRewO8MD4mjsuO36MTlRM1Z2h/1aQZ/bm4mlN1H0J6b2rx+7Az
 mi4KnKHoAl9Zax199xMetASEabUFcBYLl7wqcFOcOJIDecm2QOr4qYNvHE1sqTqDTEiILQ8TGf
 Ct2Sr8zTLaCglNSZ3vpnccNhQlIcXuaX5fH9onGy9LuF769bZFu5T+CDPaqRXsni8kJ2AIJyHE
 epY=
X-IronPort-AV: E=Sophos;i="5.77,447,1596492000"; 
   d="scan'208";a="14167250"
Date:   Tue, 3 Nov 2020 12:11:10 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.4 3/5] of: Fix reserved-memory overlap detection
Message-ID: <20201103111110.lvapcdf4nndunsie@axis.com>
References: <20201103012119.184049-1-sashal@kernel.org>
 <20201103012119.184049-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201103012119.184049-3-sashal@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 02:21:16AM +0100, Sasha Levin wrote:
> From: Vincent Whitchurch <vincent.whitchurch@axis.com>
> 
> [ Upstream commit ca05f33316559a04867295dd49f85aeedbfd6bfd ]
> 
> The reserved-memory overlap detection code fails to detect overlaps if
> either of the regions starts at address 0x0.  The code explicitly checks
> for and ignores such regions, apparently in order to ignore dynamically
> allocated regions which have an address of 0x0 at this point.  These
> dynamically allocated regions also have a size of 0x0 at this point, so
> fix this by removing the check and sorting the dynamically allocated
> regions ahead of any static regions at address 0x0.
> 
> For example, there are two overlaps in this case but they are not
> currently reported:
> 
> 	foo@0 {
> 	        reg = <0x0 0x2000>;
> 	};
> 
> 	bar@0 {
> 	        reg = <0x0 0x1000>;
> 	};
> 
> 	baz@1000 {
> 	        reg = <0x1000 0x1000>;
> 	};
> 
> 	quux {
> 	        size = <0x1000>;
> 	};
> 
> but they are after this patch:
> 
>  OF: reserved mem: OVERLAP DETECTED!
>  bar@0 (0x00000000--0x00001000) overlaps with foo@0 (0x00000000--0x00002000)
>  OF: reserved mem: OVERLAP DETECTED!
>  foo@0 (0x00000000--0x00002000) overlaps with baz@1000 (0x00001000--0x00002000)
> 
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> Link: https://lore.kernel.org/r/ded6fd6b47b58741aabdcc6967f73eca6a3f311e.1603273666.git-series.vincent.whitchurch@axis.com
> Signed-off-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I'm not sure if this really needs to be backported.  It's only fixing
what is essentially a minor debugging feature.
