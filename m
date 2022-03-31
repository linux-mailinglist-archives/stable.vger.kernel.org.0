Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16EA4ED6E0
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 11:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbiCaJaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 05:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiCaJ3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 05:29:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3E91FF422;
        Thu, 31 Mar 2022 02:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648718846; x=1680254846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mPcmSRFysKdQJULNHMdsCcsem8XlXgWIUxePX6FqmbU=;
  b=e66tOk8W/E0fWH/7ffuke1+vLmGKS753EjTf+Sd7H3LTwjwjfFeP1Sdk
   YPpDOxKDp9J3lm6ztf4Y2sZyok/q7i/5Mh27rz2dDbeibrWRSnxJfQEnQ
   ybUq5UXSGsve3t1spi7ROQJmFLUpMPUMzAuvl24/6xG++3wUVwdB+YMe1
   o8kjdbK31UAN0JFkzz13QVzhs/Bxi6pFzGr4V0qK0PCixxICLJo+ws0CT
   qlKHibwceo1P53bs2hMoY0KKXPvuv/t6+fbjXs2aBnr2mY68zRo7LwQoE
   HfRxHo6Wozc1ANd14UWLSntZEK+tRDYBWSNoFmKFBhhrQyxlS+tlgxhvo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="239705897"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="239705897"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 02:27:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="695423344"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 31 Mar 2022 02:27:23 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Thu, 31 Mar 2022 12:27:23 +0300
Date:   Thu, 31 Mar 2022 12:27:23 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Won Chung <wonchung@google.com>
Cc:     Tomas Winkler <tomas.winkler@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] misc/mei: Add NULL check to component match callback
 functions
Message-ID: <YkVz+1HkSeXcIux2@kuha.fi.intel.com>
References: <20220331084918.2592699-1-wonchung@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331084918.2592699-1-wonchung@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Won,

On Thu, Mar 31, 2022 at 08:49:18AM +0000, Won Chung wrote:
> Component match callback functions need to check if expected data is
> passed to them. Without this check, it can cause a NULL pointer
> dereference when another driver registers a component before i915
> drivers have their component master fully bind.
> 
> Fixes: 1e8d19d9b0dfc ("mei: hdcp: bind only with i915 on the same PCH")
> Fixes: c2004ce99ed73 ("mei: pxp: export pavp client to me client bus")
> Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Suggested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Won Chung <wonchung@google.com>
> Cc: stable@vger.kernel.org
> ---
> Changes from v2:
> - Correctly add "Suggested-by" tag
> - Add "Cc: stable@vger.kernel.org"
> 
> Changes from v1:
> - Add "Fixes" tag
> - Send to stable@vger.kernel.org

You are sending these really fast. Before you send the next one,
please wait for at least one day.

thanks,

-- 
heikki
