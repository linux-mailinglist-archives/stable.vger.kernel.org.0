Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1965539782E
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbhFAQjY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 1 Jun 2021 12:39:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:64342 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhFAQjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 12:39:19 -0400
IronPort-SDR: pRE/18E660pIp4BCnV8YWUCPxWXskxXazJ7WCsYJZP467m5MkDv4dZM6DwM4HT/u43HNpF0+Qt
 5glnrw7KlBYg==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="190698183"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="190698183"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 09:37:37 -0700
IronPort-SDR: Uds5R5lpyvT7k8eEpEZrVwqbNyFgW5yhiVMu4hheSDzvfLQKtTFhcywGJ2Prem6gCdWjJKQxk5
 EaesUpVP6LNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="482560381"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga002.fm.intel.com with ESMTP; 01 Jun 2021 09:37:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 09:37:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 09:37:36 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.008;
 Tue, 1 Jun 2021 09:37:36 -0700
From:   "Bloomfield, Jon" <jon.bloomfield@intel.com>
To:     Jason Ekstrand <jason@jlekstrand.net>,
        "intel-gfx-trybot@lists.freedesktop.org" 
        <intel-gfx-trybot@lists.freedesktop.org>
CC:     "Ekstrand, Jason" <jason.ekstrand@intel.com>,
        "Slusarz, Marcin" <marcin.slusarz@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: RE: [PATCH 4/5] Revert "drm/i915: Propagate errors on awaiting
 already signaled fences"
Thread-Topic: [PATCH 4/5] Revert "drm/i915: Propagate errors on awaiting
 already signaled fences"
Thread-Index: AQHXU0V9vFhwtU5wt0yEKXTLofWGK6r/YIMw
Date:   Tue, 1 Jun 2021 16:37:12 +0000
Deferred-Delivery: Tue, 1 Jun 2021 16:36:29 +0000
Message-ID: <46f1c3d15fb64b9c85405b8cb2554280@intel.com>
References: <20210527221259.131918-1-jason@jlekstrand.net>
 <20210527221259.131918-5-jason@jlekstrand.net>
In-Reply-To: <20210527221259.131918-5-jason@jlekstrand.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Jason Ekstrand <jason@jlekstrand.net>
> Sent: Thursday, May 27, 2021 3:13 PM
> To: intel-gfx-trybot@lists.freedesktop.org
> Cc: Jason Ekstrand <jason@jlekstrand.net>; Ekstrand, Jason
> <jason.ekstrand@intel.com>; Slusarz, Marcin <marcin.slusarz@intel.com>;
> stable@vger.kernel.org; Bloomfield, Jon <jon.bloomfield@intel.com>; Daniel
> Vetter <daniel.vetter@ffwll.ch>
> Subject: [PATCH 4/5] Revert "drm/i915: Propagate errors on awaiting already
> signaled fences"
> 
> This reverts commit 9e31c1fe45d555a948ff66f1f0e3fe1f83ca63f7.  Ever
> since that commit, we've been having issues where a hang in one client
> can propagate to another.  In particular, a hang in an app can propagate
> to the X server which causes the whole desktop to lock up.
> 
> Signed-off-by: Jason Ekstrand <jason.ekstrand@intel.com>
> Reported-by: Marcin Slusarz <marcin.slusarz@intel.com>
> Cc: <stable@vger.kernel.org> # v5.6+
> Cc: Jason Ekstrand <jason.ekstrand@intel.com>
> Cc: Marcin Slusarz <marcin.slusarz@intel.com>
> Cc: Jon Bloomfield <jon.bloomfield@intel.com>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/3080
> Fixes: 9e31c1fe45d5 ("drm/i915: Propagate errors on awaiting already
> signaled fences")
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
Reviewed-by: Jon Bloomfield <jon.bloomfield@intel.com>
