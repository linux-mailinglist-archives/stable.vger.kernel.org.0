Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B98056622F
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 06:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiGEEUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 00:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiGEEUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 00:20:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10978E009
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 21:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656994839; x=1688530839;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Whp3q+OS0CZUyllYOMs7sfnpeEoA6yx6a8lLdhw7r0c=;
  b=H0hRN0U8tj7WXTB3l3vJbIFbhmejFVe1GvsE7wVpSab1kpFdfDB0B1+x
   O0UqwA5tcuwICsLBfY/0Pl5zYs/9b3n7OUIbyaNwkqx5Z/59L2FhgxzxQ
   bM0spt4PFaNqDFPWMPTsrNoIB8V17n2uWQ/wMNmo1kNYfoNoTONWfN+ep
   fN7Lv1ZSLngkxOGudqzxfxYErXD8GUEKvYByJH3xk7kD0/DHmcsiOFTMV
   N2slBR3G532ZbAWMk10sKzUUhgYEn91G77myamScJVNl/87dkD7nztoD9
   /tIps2pnJJfxS2n6J33tFCVthTjmrXSTE4cvfYiO/i5AtvytLKVeRxG68
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="284356931"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="284356931"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 21:20:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="649910722"
Received: from swatichx-mobl.amr.corp.intel.com (HELO [10.212.242.218]) ([10.212.242.218])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 21:20:37 -0700
Message-ID: <bd35c4f9-90c5-fffc-193d-02bd42b04008@intel.com>
Date:   Mon, 4 Jul 2022 21:18:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.19] x86/mm/cpa: Unconditionally avoid WBINDV when we can
Content-Language: en-US
To:     Wen Yang <wenyang@linux.alibaba.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bin Yang <bin.yang@intel.com>,
        Mark Gross <mark.gross@intel.com>, stable@vger.kernel.org
References: <20220704154508.13317-1-wenyang@linux.alibaba.com>
 <YsMOWwHRUdQ/zLmx@kroah.com>
 <36b71543-fc3f-2787-06b8-2d38f1ee5b93@linux.alibaba.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <36b71543-fc3f-2787-06b8-2d38f1ee5b93@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/4/22 20:45, Wen Yang wrote:> On a 128-core Intel(R) Xeon(R)
Platinum 8369B CPU @ 2.90GHz server,
> when the user program frequently calls nv_alloc_system_pages to
> allocate large memory,

We seem to be repeating the same conversation we had back in November of
last year:

> https://lore.kernel.org/all/9c415df9-9575-8217-03e9-a6bbf20a491a@linux.alibaba.com/T/#u

It's the binary nvidia driver doing unusual stuff again.  Please talk to
the folks you got that driver from.
