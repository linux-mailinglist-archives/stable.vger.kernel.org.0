Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CFD5786DF
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 18:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiGRQBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 12:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiGRQBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 12:01:06 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93411DF3A;
        Mon, 18 Jul 2022 09:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658160063; x=1689696063;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C6vWqUcyXQkTAuAAqqcnVbId6I4b0LLhuzC6Emj2LTg=;
  b=ny87szQTt7zBeXtvhsu18grUus6XtfPtAZvX6L2JyEQUC6ELGzT7lkwC
   Eo6nCMhV3/GBhSutC+0A1EIw+xgY4et6lxad/aD76pTUczxs5yl2xSVwI
   stObR2HivokLz+Kunp8RuBCYhWbj91aJVjE0++D67jJBnIBiMEMfT39kP
   L8vwxYCUghimkE4T+ERxBrVC6rQLBnAWTYd57e23X+v5/7AUSeMOTqWy8
   YiVbIH22J7A8vM3CQHgQnTFJkjf8PrLIahIYwRTg/EmgCRmH6hQ+EUOlQ
   mVv+h0o8fD+OIKSv5hqCsQ4b33sNke5vMjDbvf7dJA2IFLcv0PMq9z9Zj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="286999542"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="286999542"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 09:01:01 -0700
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="655344616"
Received: from maurocar-mobl2.ger.corp.intel.com (HELO maurocar-mobl2) ([10.249.35.85])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 09:00:56 -0700
Date:   Mon, 18 Jul 2022 18:00:54 +0200
From:   Mauro Carvalho Chehab <mauro.chehab@linux.intel.com>
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas =?UTF-8?B?SGVsbHN0?= =?UTF-8?B?csO2bQ==?= 
        <thomas.hellstrom@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris.p.wilson@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH v2 04/21] drm/i915/gt: Only invalidate TLBs
 exposed to user manipulation
Message-ID: <20220718180054.048929ef@maurocar-mobl2>
In-Reply-To: <72a40626-ee71-fffe-3816-933fbec92c4d@linux.intel.com>
References: <cover.1657800199.git.mchehab@kernel.org>
        <c0ab69f803cfe439f9218d0c0a930eae563dee83.1657800199.git.mchehab@kernel.org>
        <72a40626-ee71-fffe-3816-933fbec92c4d@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jul 2022 14:39:17 +0100
Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com> wrote:

> On 14/07/2022 13:06, Mauro Carvalho Chehab wrote:
> > From: Chris Wilson <chris.p.wilson@intel.com>
> > 
> > Don't flush TLBs when the buffer is only used in the GGTT under full
> > control of the kernel, as there's no risk of concurrent access
> > and stale access from prefetch.
> > 
> > We only need to invalidate the TLB if they are accessible by the user.
> > That helps to reduce the performance regression introduced by TLB
> > invalidate logic.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")  
> 
> Do we really need or want stable and fixes on this one?
> 
> What do we think the performance improvement is, given there's very 
> little in GGTT, which is not mapped via PPGTT as well?
> 
> I think it is safe, but part of me would ideally not even want to think 
> about whether it is safe, if the performance improvement is 
> non-existent. Which I can't imagine how there would be?

Makes sense. Patch 6 actually ends removing the code doing
that, so I'll just fold this patch with patch 6, in order to
avoid adding something that will later be removed.

Regards,
Mauro
