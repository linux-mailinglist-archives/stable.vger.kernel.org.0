Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860B11FBDB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 22:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfEOU4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 16:56:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:55278 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbfEOU4n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 16:56:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 13:56:43 -0700
X-ExtLoop1: 1
Received: from rmitura-mobl.ger.corp.intel.com (HELO [10.249.140.5]) ([10.249.140.5])
  by orsmga003.jf.intel.com with ESMTP; 15 May 2019 13:56:41 -0700
Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
 interpreter: add region addresses...")
To:     "Schmauss, Erik" <erik.schmauss@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20190505194448.GA2649@windriver.com>
 <20190506084145.GA23991@kroah.com>
 <CF6A88132359CE47947DB4C6E1709ED53C5CF0B6@ORSMSX121.amr.corp.intel.com>
 <20190515045711.GA16452@kroah.com>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <f2110cb8-8d80-65df-55a9-5428e6e4e9c3@intel.com>
Date:   Wed, 15 May 2019 22:56:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515045711.GA16452@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/2019 6:57 AM, Greg Kroah-Hartman wrote:
> On Wed, May 15, 2019 at 01:17:28AM +0000, Schmauss, Erik wrote:
>>
>>> -----Original Message-----
>>> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
>>> Sent: Monday, May 6, 2019 1:42 AM
>>> To: Paul Gortmaker <paul.gortmaker@windriver.com>; Wysocki, Rafael J
>>> <rafael.j.wysocki@intel.com>
>>> Cc: stable@vger.kernel.org; Schmauss, Erik <erik.schmauss@intel.com>
>>> Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
>>> interpreter: add region addresses...")
>>>
>>> On Sun, May 05, 2019 at 03:44:48PM -0400, Paul Gortmaker wrote:
>>>> I noticed 4.19.35 got a backport of mainline 4abb951b, but it appears
>>>> to be a duplicate backport that landed in the wrong function.  We can
>>>> see this in the stable-queue repo:
>>>>
>>>> stable-queue$ find . -name '*acpica-aml-interpreter-add-region-addr*'
>>>> |grep 4.19
>>>> ./releases/4.19.6/acpica-aml-interpreter-add-region-addresses-in-globa
>>>> l-list-during-initialization.patch
>>>> ./releases/4.19.3/revert-acpica-aml-interpreter-add-region-addresses-i
>>>> n.patch
>>>> ./releases/4.19.35/acpica-aml-interpreter-add-region-addresses-in-glob
>>>> al-list-during-initialization.patch
>>>> ./releases/4.19.2/acpica-aml-interpreter-add-region-addresses-in-globa
>>>> l-list-during-initialization.patch
>>>>
>>>> So it was added to 4.19.2, reverted in .3, re-added in .6, and then
>>>> finally patched into a similar looking but wrong function in .35
>>>>
>>>> If we diff the .6 and .35 versions, we see the function difference:
>>>>
>>>> -@@ -417,6 +417,10 @@ acpi_ds_eval_region_operands(struct acpi
>>>> +@@ -523,6 +523,10 @@ acpi_ds_eval_table_region_operands(struc
>>>>
>>>> I don't know what the history is/was around the 2/3/6 churn, but the
>>>> re-addition in 4.19.35 to a different function sure looks wrong.
>>>>
>>>> The commit adds a call "status = acpi_ut_add_address_range(..." and if
>>>> we check mainline, there is only one in that file, but in 4.19.35+
>>>> there now are two calls - since the two functions had similar context
>>>> and comments, it isn't hard to see how patch could/would apply it a
>>>> 2nd time in the wrong place.
>>>>
>>>> I didn't check if any of the other currently maintained linux-stable
>>>> versions also had this possible issue.
>>>>
>> Hi Greg,
>>
>>> Ugh, Rafael, did I mess this up again?  Can you check to see if I need to fix this
>>> somehow?
>> It should be called in acpi_ds_eval_region_operands rather than acpi_ds_eval_table_region_operands.
>> Please remove the call from acpi_ds_eval_table_region_operands.
> Great, can someone please send me a patch for this so that I don't get
> it wrong myself?

Erik, can you please cut a patch for that against 4.19.35 and send it to 
Greg?


