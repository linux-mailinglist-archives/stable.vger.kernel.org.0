Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148164BD0C3
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 19:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243152AbiBTS61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 13:58:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237468AbiBTS60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 13:58:26 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF0C389E;
        Sun, 20 Feb 2022 10:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645383485; x=1676919485;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=pz1vrALtYuxX7Nc74EmHqAm8EasBUPeiK+YJrXOri7Q=;
  b=VDTZOp9qeNhO2jcB1EtJSLB2ILvkRYHfVpKbJAC5zUmlDdorcj5bR63r
   TfXIFkapu1/MhLPjYoqMh9VJuutUTqwwljtbV2aQPj904kUyEM56zTnxz
   YCwvScxoNIGmGweiERB8BMpeoU5K3xiEkjHj3Cexl1DGjSP79tF2dWMLE
   +9B4kBJ9pg4zGuwmST4sQ68u4innmGKTiZoYdoiyFYSz7pZiB6v7nkMGN
   /8BAJ10fxbLcpEuyfA2RTuM0Q65VEkPJkWQUeeep+en3wZGtEqvPcB8sO
   q6OlmF4gCqHX02QVqeCUMap0RH/+GTtWBLCXgdIgozQLpYcd9CPIskPu+
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="232016056"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="232016056"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 10:58:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="547061517"
Received: from jatanner-mobl5.amr.corp.intel.com (HELO [10.212.248.173]) ([10.212.248.173])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 10:58:04 -0800
Message-ID: <bf6654d9-572b-3423-59a0-c17112f75792@intel.com>
Date:   Sun, 20 Feb 2022 10:58:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
References: <20220108140510.76583-1-jarkko@kernel.org>
 <YfJDV63oGmWOmO4F@iki.fi> <8afec431-4dfc-d8df-152b-76cca0e17ccb@intel.com>
 <YhKN+LRD2vuhWhqB@iki.fi>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3] x86/sgx: Free backing memory after faulting the
 enclave page
In-Reply-To: <YhKN+LRD2vuhWhqB@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/22 10:52, Jarkko Sakkinen wrote:
>> Am I just all twisted around from looking at this code too much?  Could
>> you please take another look and send a new version of the patch?
> Yeah, I will. It took me two weeks to make full remote attestation
> implementation for SGX in Rust but at least I can confirm that all
> the kernel bits work on that (and this will also help me to finish
> the man page because it is pretty nasty to document it if you haven't
> gone to the rabbit hole yourself).
> 
> I'll prioritize now to get SGX2 patches tested with Enarx implementation
> but this 2nd thing in my kernel queue.

I really prioritize bug fixes over new features.  New features can's
really get merged until this gets fixed up.
