Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0432D4459D2
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 19:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhKDSjf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 4 Nov 2021 14:39:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:15360 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhKDSje (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 14:39:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10158"; a="211820937"
X-IronPort-AV: E=Sophos;i="5.87,209,1631602800"; 
   d="scan'208";a="211820937"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 11:36:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,209,1631602800"; 
   d="scan'208";a="586066902"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 04 Nov 2021 11:36:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 4 Nov 2021 11:36:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 4 Nov 2021 11:36:55 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2242.012;
 Thu, 4 Nov 2021 11:36:55 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "seanjc@google.com" <seanjc@google.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/sgx: Fix free page accounting
Thread-Topic: [PATCH] x86/sgx: Fix free page accounting
Thread-Index: AQHX0ancXoKdYS/VT063RtxMG9uqNKvzsfGg
Date:   Thu, 4 Nov 2021 18:36:55 +0000
Message-ID: <9f96f71fe67042a89cd1a8f79a1840fa@intel.com>
References: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
In-Reply-To: <373992d869cd356ce9e9afe43ef4934b70d604fd.1636049678.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -/* The free page list lock protected variables prepend the lock. */
> -static unsigned long sgx_nr_free_pages;
> +atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);

You accidentally lost the "static" here. This is still only accessed within this
one source file.

Otherwise:

Reviewed-by: Tony Luck <tony.luck@intel.com>

-Tony
