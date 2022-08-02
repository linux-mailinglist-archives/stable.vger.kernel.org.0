Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944F058835B
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 23:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiHBVVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 17:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiHBVVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 17:21:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59F4BC88;
        Tue,  2 Aug 2022 14:21:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 651EE614FC;
        Tue,  2 Aug 2022 21:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F279C433C1;
        Tue,  2 Aug 2022 21:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659475265;
        bh=PUqEeO+GLm9+nx051DoVWrljhcKSN1GEPZE+s1wniz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X0iYOOetTx7VBG1bw1B40MG1KGmED3sh/YX2xRyJlx+5NygaVYGGfkE5AE3nAi0XM
         OMgwTDPP/V6QTUAGcAjk8jHrDousLsxSOw5O6o96z5nYowdYlOsa2i4iTKg/5zFfwI
         iownstjvS4E8K9vvsd0uqPTmr7eCAw9UGYzXg9Q1TC1TXnM/kZ/8FnG3qAMBTRCFSc
         fCef3g2uEzzMT5nMnfld8Q6d8rhs9pFS7YofCMi8jneqO5qEGcMUIYDIYOlUSL3eoM
         cMz9egbO/a2Oma850SBxC2FB1PGBP+60+DnSy1phk5lydnMWqcp038VzMvCkgGDbOW
         J35BYu8qdUehw==
Date:   Tue, 2 Aug 2022 17:21:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Geliang Tang <geliang.tang@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.18 72/88] mptcp: dont send RST for single subflow
Message-ID: <YumVQNNn3xS2Hf/C@sashalap>
References: <20220801114138.041018499@linuxfoundation.org>
 <20220801114141.321741611@linuxfoundation.org>
 <9ff367ab-bd52-3c3a-a62-2ade761b18f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9ff367ab-bd52-3c3a-a62-2ade761b18f@linux.intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 02, 2022 at 01:52:15PM -0700, Mat Martineau wrote:
>On Mon, 1 Aug 2022, Greg Kroah-Hartman wrote:
>
>>From: Geliang Tang <geliang.tang@suse.com>
>>
>>[ Upstream commit 1761fed2567807f26fbd53032ff622f55978c7a9 ]
>>
>>When a bad checksum is detected and a single subflow is in use, don't
>>send RST + MP_FAIL, send data_ack + MP_FAIL instead.
>>
>>So invoke tcp_send_active_reset() only when mptcp_has_another_subflow()
>>is true.
>>
>>Signed-off-by: Geliang Tang <geliang.tang@suse.com>
>>Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>>Signed-off-by: David S. Miller <davem@davemloft.net>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Hi Greg -
>
>Please drop this patch from the 5.18-stable queue. It was the first of 
>an 8-patch series and doesn't really stand alone.
>
>This commit message lacks the Fixes: tag and the magic commit message 
>words that I've seen the scripts pick up, so I'm curious: was this 
>patch selected by hand?

Yup, between the commit message and the code itself, it looked like a
fix for AUTOSEL.

-- 
Thanks,
Sasha
