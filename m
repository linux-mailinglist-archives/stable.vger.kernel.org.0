Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F25690507
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 11:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjBIKiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 05:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjBIKhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 05:37:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D334ED6
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 02:36:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ECFDB8207C
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 10:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63149C433EF;
        Thu,  9 Feb 2023 10:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675939008;
        bh=Cc/WNTKPyja30Kn4Lpz1zJJjb3EYN9lEnAhno7TpW3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2m3HPkatv1+j0fDQ5bqFF0qNyoCOXq2IHcbBFo5HOjhGWI4FDOLjG42R9a/ue4lp0
         dMynAe7bFNvp+zNRjrp0GIsugMkI+tTJrOfYgVmzOonyonRu/vRR2a0sr/W629JGp1
         sPoWdUPBoB2Zryhyu28wTxTMlKPSrf0WKTehY8B8=
Date:   Thu, 9 Feb 2023 11:36:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shaoying Xu <shaoyi@amazon.com>
Cc:     stable@vger.kernel.org, abuehaze@amazon.com, peterz@infradead.org,
        longman@redhat.com
Subject: Re: [PATCH stable 5.10 0/7] Remove reader optimistic spinning
Message-ID: <Y+TMvcaArE0M/TnS@kroah.com>
References: <20230207190135.25258-1-shaoyi@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207190135.25258-1-shaoyi@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 07:01:28PM +0000, Shaoying Xu wrote:
> This patch series is to remove reader optimistic spinning in
> kernel 5.10 to improve the MongoDB performance. Performance measurements
> (10 times running average of overall throughput ops/sec) are using
> MongoDB 5.0.11 and YCSB [1] microbenchmark with workloadA [2] on AWS EC2
> m5.4xlarge/m6g.4xlarge (16-vCPU 64GiB-memory) instances with a 512GB EBS
> IO1 drive disk with 5000 IOPS and separating MongoDB and YCSB load generator
> on 2 instances and setting recordcount=25000000 and operationcount=10000000
> to see the impacts of these changes:
> 
>   Before - v5.10.165 kernel in OS Amazon Linux 2
>   After  - v5.10.165 kernel with reader spinning disabled in OS Amazon Linux 2
> 
>   | Arch    | Instance Type | Before  | After   |
>   |---------+---------------+---------+---------|
>   | x86_64  | m5.4xlarge    | 37365.4 | 42373.9 |
>   |---------+---------------+---------+---------|
>   | aarch64 | m6g.4xlarge   | 33823.1 | 43113.7 |
>   |---------+---------------+---------+---------|
> 
> It can be seen that the MongoDB throughput can be improved around 13% in x86_64
> and 27% in aarch64 after disabling reader optimistic spinning and these patches 
> can be applied to 5.10 with no conflict so we wonder if it's possible to backport 
> them to stable 5.10? 

This is, frankly, crazy. :)

This is great that you did this work and found this out, but really,
shouldn't you have done the less work and just moved to 5.15.y instead?
You're going to have to do that anyway, what's preventing that from
happening now, with the HUGE justification that you get a big workload
increase and power savings (i.e. real money)?

So now you just delay the inevitable and spend more work overall (i.e.
the backport work now, and the 5.15.y move later?)  This feels like a
bad management decision somewhere, who do I need to talk to to resolve
this?

thanks,

greg k-h
