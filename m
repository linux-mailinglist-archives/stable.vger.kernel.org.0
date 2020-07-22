Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879EA2297C1
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 13:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgGVLyN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 22 Jul 2020 07:54:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:27674 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgGVLyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 07:54:12 -0400
IronPort-SDR: EhYgcxrDuSEscA10hBeAw5AAPLnxPJTDYjyO3zohDZABW/EoNCr+K8YzvKI35aTaz92aDkWhzE
 LU5R8TTFL5hw==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="151637675"
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="151637675"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 04:54:12 -0700
IronPort-SDR: 1dhNdg6tFxJz5OyeVPYXA8AFhZu+Kgo5ui8HjuUXPejpnXII28N0r3Yhtrcnxf1XrdkclaGDvu
 Qw+kCeWyUysw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,381,1589266800"; 
   d="scan'208";a="318644138"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 22 Jul 2020 04:54:12 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Jul 2020 04:54:11 -0700
Received: from fmsmsx108.amr.corp.intel.com ([169.254.9.75]) by
 fmsmsx117.amr.corp.intel.com ([169.254.3.66]) with mapi id 14.03.0439.000;
 Wed, 22 Jul 2020 04:54:11 -0700
From:   "Ruhl, Michael J" <michael.j.ruhl@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] io-mapping: Indicate mapping failure
Thread-Topic: [PATCH v2] io-mapping: Indicate mapping failure
Thread-Index: AQHWX4MfwzDEcHdlu02n3oFh4ZbooKkS+TgA//+K8vCAAHzEAIAAfQyA
Date:   Wed, 22 Jul 2020 11:54:11 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E866301245E0ACA@FMSMSX108.amr.corp.intel.com>
References: <20200721171936.81563-1-michael.j.ruhl@intel.com>
        <20200721135648.9603d924377825a7e6c0023b@linux-foundation.org>
        <14063C7AD467DE4B82DEDB5C278E866301245E046C@FMSMSX108.amr.corp.intel.com>
 <20200721142424.b8846cddf1efd48e45278a42@linux-foundation.org>
In-Reply-To: <20200721142424.b8846cddf1efd48e45278a42@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>-----Original Message-----
>From: Andrew Morton <akpm@linux-foundation.org>
>Sent: Tuesday, July 21, 2020 5:24 PM
>To: Ruhl, Michael J <michael.j.ruhl@intel.com>
>Cc: dri-devel@lists.freedesktop.org; Mike Rapoport <rppt@linux.ibm.com>;
>Andy Shevchenko <andriy.shevchenko@linux.intel.com>; Chris Wilson
><chris@chris-wilson.co.uk>; stable@vger.kernel.org
>Subject: Re: [PATCH v2] io-mapping: Indicate mapping failure
>
>On Tue, 21 Jul 2020 21:02:44 +0000 "Ruhl, Michael J"
><michael.j.ruhl@intel.com> wrote:
>
>> >--- a/include/linux/io-mapping.h~io-mapping-indicate-mapping-failure-fix
>> >+++ a/include/linux/io-mapping.h
>> >@@ -107,9 +107,12 @@ io_mapping_init_wc(struct io_mapping *io
>> > 		   resource_size_t base,
>> > 		   unsigned long size)
>> > {
>> >+	iomap->iomem = ioremap_wc(base, size);
>> >+	if (!iomap->iomem)
>> >+		return NULL;
>> >+
>>
>> This does make more sense.
>>
>> I am confused by the two follow up emails I just got.
>
>One was your original patch, the other is my suggested alteration.
>
>> Shall I resubmit, or is this path (if !iomap->iomem) return NULL)
>> now in the tree.
>
>All is OK.  If my alteration is acceptable (and, preferably, tested!)
>then when the time comes, I'll fold it into the base patch, add a
>note indicating this change and shall then send it to Linus.

I am good with the change and have tested it.

Instead of the system crashing I get:

i915 0000:01:00.0: [drm] *ERROR* Failed to setup region(-5) type=1
i915 0000:01:00.0: Device initialization failed (-5)
i915: probe of 0000:01:00.0 failed with error -5

Which is the expected error.

If you would like this for the updated patch:

Tested-By: Michael J. Ruhl <michael.j.ruhl@intel.com>

Thanks!

Mike

