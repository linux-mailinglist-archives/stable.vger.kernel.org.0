Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02CD591A78
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237374AbiHMNLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiHMNLA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:11:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F1A248C1
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88F01B80092
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55F3C433D6;
        Sat, 13 Aug 2022 13:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660396256;
        bh=zQKFyn8EUEktgFQj6ncS15B99dB5adWlp3Qp7oGxPQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aEQjD2H2qN3twC06w5puTytWhl0Z4ER2qJmDNq9ZGVewbVwMCGjuITC3Tx0hX+xwa
         mnkp5BGChnuirYm2Zu/UglgvNt+GF5hqaeTWATbaxIasgbhfGgVmDqJaDipnFe2Oqx
         BpYGr4FdN5C/uXeLjtW9HpApsp/HJgQJff3NVmY0=
Date:   Sat, 13 Aug 2022 15:10:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH 4.19 1/4] selftests/bpf: add selftest part of "bpf: Fix
 the off-by-two error in range markings"
Message-ID: <Yvei3RLnHqGgb9yp@kroah.com>
References: <20220809073947.33804-1-ovidiu.panait@windriver.com>
 <20220809073947.33804-2-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809073947.33804-2-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 10:39:44AM +0300, Ovidiu Panait wrote:
> From: Maxim Mikityanskiy <maximmi@nvidia.com>
> 
> The 4.19 backport of upstream commit 2fa7d94afc1a ("bpf: Fix the off-by-two
> error in range markings") did not include the selftest changes, so currently
> there are 8 verifier selftests that are failing:
>  # root@intel-x86-64:~# ./test_verifier
>  ...
>  #495/p XDP pkt read, pkt_end > pkt_data', bad access 1 FAIL
>  #498/p XDP pkt read, pkt_data' < pkt_end, bad access 1 FAIL
>  #504/p XDP pkt read, pkt_data' >= pkt_end, bad access 1 FAIL
>  #513/p XDP pkt read, pkt_end <= pkt_data', bad access 1 FAIL
>  #519/p XDP pkt read, pkt_data > pkt_meta', bad access 1 FAIL
>  #522/p XDP pkt read, pkt_meta' < pkt_data, bad access 1 FAIL
>  #528/p XDP pkt read, pkt_meta' >= pkt_data, bad access 1 FAIL
>  #537/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 FAIL
>  Summary: 924 PASSED, 0 SKIPPED, 8 FAILED
> 
> Cherry-pick the selftest changes to fix these.

What specific "selftest changes" are you cherry-picking here?  I can't
take this commit without that reference.

thanks,

greg k-h
