Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321E2655179
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 15:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbiLWOld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 09:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiLWOld (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 09:41:33 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253EAB85D;
        Fri, 23 Dec 2022 06:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671806492; x=1703342492;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0+6p+VS1oE94n8QNDeI1T8hMST+L9ogs9AORZAYfFCo=;
  b=Mon3qRVuQo8EKaLJPfUgIGWwRgt9OIzhoUKdJUKbJJpiO2QbXw7MHv5M
   egtdJB/yBxiBEpP0LMiadYSaUgrBanZsL3c1dU8n4v3ilZYfBO7TcHL5B
   4SIcUYxrdxOwLSnIBJMhKdHCy1oKF1EgZzXMSNcNaRgNBI1khheWpzpqo
   0k3BhUVFTd1uunG7NckIHrOagLKNBJyD7TEYWOW9Ut43qsg1T5o3wJkgQ
   wbRuVMYk2lNkUHhtjXNINCYWlSZBfviU7CPLAY9BOwvMHIFcumGzyJ7if
   22wybmTlHKxcEF6WPljBkXf9nN/ul9J0CRzZop/ZhOk/p80GkIPsMvhyk
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10570"; a="406579808"
X-IronPort-AV: E=Sophos;i="5.96,268,1665471600"; 
   d="scan'208";a="406579808"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2022 06:41:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10570"; a="720664512"
X-IronPort-AV: E=Sophos;i="5.96,268,1665471600"; 
   d="scan'208";a="720664512"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 23 Dec 2022 06:41:29 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2BNEfRpL017707;
        Fri, 23 Dec 2022 14:41:27 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Prashanth K <quic_prashk@quicinc.com>,
        David Laight <David.Laight@aculab.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: usb: f_fs: Fix CFI failure in ki_complete
Date:   Fri, 23 Dec 2022 15:41:19 +0100
Message-Id: <20221223144119.1840796-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <Y6VvEmfgbQOmW2cN@kadam>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com> <Y5cuCMhFIaKraUyi@kroah.com> <abe47a47aa5d49878c58fc1199be18ea@AcuMS.aculab.com> <acdda510-945f-ff68-5c8b-a1a0290bed6d@quicinc.com> <Y6VvEmfgbQOmW2cN@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Fri, 23 Dec 2022 12:04:18 +0300

> On Thu, Dec 22, 2022 at 06:21:03PM +0530, Prashanth K wrote:
> > 
> > 
> > On 14-12-22 11:05 pm, David Laight wrote:
> > > From: Greg Kroah-Hartman
> > > > Sent: 12 December 2022 13:35
> > > > 
> > > > On Mon, Dec 12, 2022 at 06:54:24PM +0530, Prashanth K wrote:
> > > > > Function pointer ki_complete() expects 'long' as its second
> > > > > argument, but we pass integer from ffs_user_copy_worker. This
> > > > > might cause a CFI failure, as ki_complete is an indirect call
> > > > > with mismatched prototype. Fix this by typecasting the second
> > > > > argument to long.
> > > > 
> > > > "might"?  Does it or not?  If it does, why hasn't this been reported
> > > > before?
> > > 
> > > Does the cast even help at all.
> > Actually I also have these same questions
> > - why we haven't seen any instances other than this one?
> > - why its not seen on other indirect function calls?
> > 
> > Here is the the call stack of the failure that we got.
> > 
> > [  323.288681][    T7] Kernel panic - not syncing: CFI failure (target:
> > 0xffffffe5fc811f98)
> > [  323.288710][    T7] CPU: 6 PID: 7 Comm: kworker/u16:0 Tainted: G S    W
> > OE     5.15.41-android13-8-g5ffc5644bd20 #1
> > [  323.288730][    T7] Workqueue: adb ffs_user_copy_worker.cfi_jt
> > [  323.288752][    T7] Call trace:
> > [  323.288755][    T7]  dump_backtrace.cfi_jt+0x0/0x8
> > [  323.288772][    T7]  dump_stack_lvl+0x80/0xb8
> > [  323.288785][    T7]  panic+0x180/0x444
> > [  323.288797][    T7]  find_check_fn+0x0/0x218
> > [  323.288810][    T7]  ffs_user_copy_worker+0x1dc/0x204
> > [  323.288822][    T7]  kretprobe_trampoline.cfi_jt+0x0/0x8
> > [  323.288837][    T7]  worker_thread+0x3ec/0x920
> > [  323.288850][    T7]  kthread+0x168/0x1dc
> > [  323.288859][    T7]  ret_from_fork+0x10/0x20
> > [  323.288866][    T7] SMP: stopping secondary CPUs
> > 
> > And from address to line translation, we got know the issue is from
> > ffs_user_copy_worker+0x1dc/0x204
> > 		||
> > io_data->kiocb->ki_complete(io_data->kiocb, ret);
> > 
> > And "find_check_fn" was getting invoked from ki_complete. Only thing that I
> > found suspicious about ki_complete() is its argument types. That's why I
> > pushed this patch here, so that we can discuss this out here.
> 
> I think the problem is more likely whatever ->ki_complete() points to
> but I have no idea what that is on your system.  You're using an Android
> kernel so it could be something out of tree as well...

Correct, CFI would *never* trigger a failure due to passing int as
long. It triggers only on prototype-implementation mismatches. The
author should go and check carefully whether there are any places
where some implementation differs and then ::ki_complete() gets
passed with a function typecast. Also, there can be places where a
proto has an argument as enum and an implementation has it as int.
Compilers don't warn on such mismatches, CFI does. The latest LLVM
Git snapshot with `-Wcast-function-type-strict` enabled could help
hunt such.

> 
> regards,
> dan carpenter

Thanks,
Olek
