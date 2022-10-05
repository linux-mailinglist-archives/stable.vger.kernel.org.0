Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55A65F5573
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiJENdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 09:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJENdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 09:33:01 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919C979EFA
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 06:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664976780; x=1696512780;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eILrqrbum5QwAkBtdxqbrJnoct2lE9sWsCAfF3dyF/Q=;
  b=FZeTjhfeDuYdQIAaDgD5Ui3zS17KLA7RbSg6vUt17v5AsJmU314nVn4p
   I94/GxqioeBtoKlSsYswA1+uyeKzVejdSjLG6QoqfFnXvyB6a5nRXF/dD
   nx52XXBTiW6fBToAXjddKR3FrQn1qtg1A7t2G8CC1kvCqkqyQuAMuA521
   9fK4xmIBYBw6aMsG3gqM41BNP7ft3QtxiVZKDIhYgTgxmhjhf0/GRK/Pi
   Pp0AtmZLZbtZ/c9kTcPCF2bPc3dV0dRihNdrc80f4WE4OmAMkdwsCzx1i
   B97VMhuA4C/UFCAL6aFM+bdvO+EkZrE38SrgHeH2RR4HasCrpAVcsYTnu
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="389446987"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="389446987"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 06:32:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="624309124"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="624309124"
Received: from vadimbel-mobl2.ger.corp.intel.com (HELO [10.252.23.121]) ([10.252.23.121])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 06:32:54 -0700
Message-ID: <e9722ab4-31fe-3f2e-a1e6-5df5d1bef623@intel.com>
Date:   Wed, 5 Oct 2022 14:32:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.1
Subject: Re: [PATCH RESEND] drm/i915: Fix display problems after resume
Content-Language: en-GB
To:     =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>, intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Kevin Boulain <kevinboulain@gmail.com>,
        David de Sousa <davidesousa@gmail.com>
References: <20221005121159.340245-1-thomas.hellstrom@linux.intel.com>
From:   Matthew Auld <matthew.auld@intel.com>
In-Reply-To: <20221005121159.340245-1-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

On 05/10/2022 13:11, Thomas Hellström wrote:
> Commit 39a2bd34c933 ("drm/i915: Use the vma resource as argument for gtt
> binding / unbinding") introduced a regression that due to the vma resource
> tracking of the binding state, dpt ptes were not correctly repopulated.
> Fix this by clearing the vma resource state before repopulating.
> The state will subsequently be restored by the bind_vma operation.
> 
> Fixes: 39a2bd34c933 ("drm/i915: Use the vma resource as argument for gtt binding / unbinding")
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20220912121957.31310-1-thomas.hellstrom@linux.intel.com
> Cc: Matthew Auld <matthew.auld@intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.18+
> Reported-and-tested-by: Kevin Boulain <kevinboulain@gmail.com>
> Tested-by: David de Sousa <davidesousa@gmail.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>

