Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B084A5F72A1
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 03:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiJGByg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 21:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJGBye (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 21:54:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A568AA3CC;
        Thu,  6 Oct 2022 18:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665107673; x=1696643673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9OVOm9eDtKJN7qyZMh1z05mjjfPmqKiVIGSFHi9feuU=;
  b=SoZMLfNma5N2zXgMTCnGX+roMi247f4X8fMUTAPU7HdIm0q98gVTvu+5
   lgIoYQet8xYiUdpzLibyhtu3BPyjEz0SUvu5QL/qVPmOBway66LrH7kJ5
   vk0olUvF4zBU+XOFgcQjcKzbHU0rScZ6U5yrWAcY7GQZJi3trOoXNUxnW
   JoMUgOdqncczTsyDL3gCnVDd6xM0D6yGvhp5DVjNyizeoPhEiKUewb5g3
   WwLjnfmUEJjrwX0hqvJlCu3prAhdZ9i0Ms6t1Umvt9YyARmeg8sPC/B2u
   J3ODCKVEcqajmu/Yo+KY1kThtmtR7J0+LlLb1wC47Ev4vjUGC/xLBt6Dm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="305206852"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="305206852"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 18:54:32 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="800118233"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="800118233"
Received: from spvenkat-mobl.amr.corp.intel.com (HELO desk) ([10.209.50.56])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 18:54:32 -0700
Date:   Thu, 6 Oct 2022 18:54:31 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     kvm@vger.kernel.org, sjitindarsingh@gmail.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@suse.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        jpoimboe@kernel.org, daniel.sneddon@linux.intel.com,
        benh@kernel.crashing.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
Message-ID: <20221007015431.i4k4d3cxnhirnpgc@desk>
References: <20221005220227.1959-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221005220227.1959-1-surajjs@amazon.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Suraj,

On Wed, Oct 05, 2022 at 03:02:27PM -0700, Suraj Jitindar Singh wrote:
>tl;dr: The existing mitigation for eIBRS PBRSB predictions uses an INT3 to
>ensure a call instruction retires before a following unbalanced RET. Replace
>this with a WRMSR serialising instruction which has a lower performance
>penalty.
>
>== Background ==
>
>eIBRS (enhanced indirect branch restricted speculation) is used to prevent
>predictor addresses from one privilege domain from being used for prediction
>in a higher privilege domain.
>
>== Problem ==
>
>On processors with eIBRS protections there can be a case where upon VM exit
>a guest address may be used as an RSB prediction for an unbalanced RET if a
>CALL instruction hasn't yet been retired. This is termed PBRSB (Post-Barrier
>Return Stack Buffer).
>
>A mitigation for this was introduced in:
>(2b1299322016731d56807aa49254a5ea3080b6b3 x86/speculation: Add RSB VM Exit protections)
>
>This mitigation [1] has a ~1% performance impact on VM exit compared to without
>it [2].
>
>== Solution ==
>
>The WRMSR instruction can be used as a speculation barrier and a serialising
>instruction. Use this on the VM exit path instead to ensure that a CALL
>instruction (in this case the call to vmx_spec_ctrl_restore_host) has retired
>before the prediction of a following unbalanced RET.
>
>This mitigation [3] has a negligible performance impact.
>
>== Testing ==
>
>Run the outl_to_kernel kvm-unit-tests test 200 times per configuration which
>counts the cycles for an exit to kernel mode.
>
>[1] With existing mitigation:
>Average: 2026 cycles
>[2] With no mitigation:
>Average: 2008 cycles

During these tests was the value of MSR SPEC_CTRL for host and guest different?

>[3] With proposed mitigation:
>Average: 2008 cycles
