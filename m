Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4A75099EB
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 09:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386222AbiDUHyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 03:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386229AbiDUHyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 03:54:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384BEE092
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 00:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD5E4B82299
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 07:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB90EC385A5;
        Thu, 21 Apr 2022 07:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650527505;
        bh=As1nP7mO1yybV+AD4HiSTOlPuI9KNCttKVmZjIulvN0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=j9Vig0M8vaxGvcJj12STrpT+CwTEGlcPBXKWeGcuoD0pSNDlmaNkE+5k2AZWDmYs7
         YKs10Q23+W4+t2ALVQX+LMs4fx3Pi7sd4M7O4fnZBWrkCVtCtVWO44vNF2AS6MgmtL
         t/qxQkJN/AyMDMjPQAxr8eFWmWfLDBPRl4A8bydilrXIpP04OUWcYJRV+J3z7mQZfX
         SerLAEwEu/O2w6EtTdXc3rpA/6gATRa03cGOrI85z861dU8BwXk25q+TQtb1HVPrK4
         gclKXE1LNaT6Pw67+JEh86QMpUGf/ZibFVk2kSHVuscesENC52DfdFJEQnEGaZmuT0
         XLtvcdJRY6uoQ==
Message-ID: <ebccb5ef-e9df-48f5-ecf6-3969fb62df16@kernel.org>
Date:   Thu, 21 Apr 2022 10:51:39 +0300
MIME-Version: 1.0
Subject: Re: [PATCH 5.15 1/2] dma-mapping: remove bogus test for pfn_valid
 from dma_map_resource
Content-Language: en-US
To:     Greg KH <greg@kroah.com>, Georgi Djakov <quic_c_gdjako@quicinc.com>
Cc:     stable@vger.kernel.org, rppt@linux.ibm.com,
        anshuman.khandual@arm.com, david@redhat.com, will@kernel.org,
        catalin.marinas@arm.com, hch@lst.de, akpm@linux-foundation.org,
        surenb@google.com, quic_sudaraja@quicinc.com
References: <20220420124341.14982-1-quic_c_gdjako@quicinc.com>
 <YmD8+0S2AxAlUaG4@kroah.com>
From:   Georgi Djakov <djakov@kernel.org>
In-Reply-To: <YmD8+0S2AxAlUaG4@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 21.04.22 9:43, Greg KH wrote:
> On Wed, Apr 20, 2022 at 05:43:40AM -0700, Georgi Djakov wrote:
>> From: Mike Rapoport <rppt@linux.ibm.com>
>>
>> [ Upstream commit a9c38c5d267cb94871dfa2de5539c92025c855d7 ]
>>
>> dma_map_resource() uses pfn_valid() to ensure the range is not RAM.
>> However, pfn_valid() only checks for availability of the memory map for a
>> PFN but it does not ensure that the PFN is actually backed by RAM.
>>
>> As dma_map_resource() is the only method in DMA mapping APIs that has this
>> check, simply drop the pfn_valid() test from dma_map_resource().
>>
>> Link: https://lore.kernel.org/all/20210824173741.GC623@arm.com/
>> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Link: https://lore.kernel.org/r/20210930013039.11260-2-rppt@kernel.org
>> Signed-off-by: Will Deacon <will@kernel.org>
>> Fixes: 859a85ddf90e ("mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE")
>> Link: https://lore.kernel.org/r/Yl0IZWT2nsiYtqBT@linux.ibm.com
>> Signed-off-by: Georgi Djakov <quic_c_gdjako@quicinc.com>
>> ---
>>   kernel/dma/mapping.c | 4 ----
>>   1 file changed, 4 deletions(-)
> 
> I took this, but I do not understand why patch 2/2 in this series is
> needed, as Sasha points out.  Cleanups are nice, but is it necessary
> here?

It's needed as it removes the "select HAVE_ARCH_PFN_VALID" from the arm64/Kconfig.
This will make us use the generic pfn_valid() function in mmzone.h, instead of the
arch-specific one, that we are dropping.

Thanks,
Georgi
