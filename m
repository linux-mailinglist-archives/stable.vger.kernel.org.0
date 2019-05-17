Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C530F21178
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfEQAwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbfEQAwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 20:52:12 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91B58206BF;
        Fri, 17 May 2019 00:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558054330;
        bh=evCk6i9bDk/I5c2X+xZ+Chs3ONwfa6LxwuHlbdO0rIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tfIKweUCclmf6xRH9XauSrAaYawwz5cChyMsy+W5M5Mtq5BwoZb2V1fbUwGyuIGDm
         /CjbynQO9E7bTl0StHahugA/ElIK413mdIuCJd5cvXCh93WBVoJAkcGuxnLNLJxGRu
         wTFhn5ozh1rb0iOYSLMwyM36N3x4yty40BQhgu2Y=
Date:   Thu, 16 May 2019 20:52:09 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Schmauss, Erik" <erik.schmauss@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
 interpreter: add region addresses...")
Message-ID: <20190517005209.GZ11972@sasha-vm>
References: <20190505194448.GA2649@windriver.com>
 <20190506084145.GA23991@kroah.com>
 <CF6A88132359CE47947DB4C6E1709ED53C5CF0B6@ORSMSX121.amr.corp.intel.com>
 <20190515045711.GA16452@kroah.com>
 <f2110cb8-8d80-65df-55a9-5428e6e4e9c3@intel.com>
 <CF6A88132359CE47947DB4C6E1709ED53C5D0845@ORSMSX121.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CF6A88132359CE47947DB4C6E1709ED53C5D0845@ORSMSX121.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 12:45:54AM +0000, Schmauss, Erik wrote:
>
>
>> -----Original Message-----
>> From: Wysocki, Rafael J
>> Sent: Wednesday, May 15, 2019 1:57 PM
>> To: Schmauss, Erik <erik.schmauss@intel.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Paul Gortmaker
>> <paul.gortmaker@windriver.com>; stable@vger.kernel.org
>> Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
>> interpreter: add region addresses...")
>>
>> On 5/15/2019 6:57 AM, Greg Kroah-Hartman wrote:
>> > On Wed, May 15, 2019 at 01:17:28AM +0000, Schmauss, Erik wrote:
>> >>
>> >>> -----Original Message-----
>> >>> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
>> >>> Sent: Monday, May 6, 2019 1:42 AM
>> >>> To: Paul Gortmaker <paul.gortmaker@windriver.com>; Wysocki, Rafael J
>> >>> <rafael.j.wysocki@intel.com>
>> >>> Cc: stable@vger.kernel.org; Schmauss, Erik <erik.schmauss@intel.com>
>> >>> Subject: Re: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA:
>> >>> AML
>> >>> interpreter: add region addresses...")
>> >>>
>> >>> On Sun, May 05, 2019 at 03:44:48PM -0400, Paul Gortmaker wrote:
>> >>>> I noticed 4.19.35 got a backport of mainline 4abb951b, but it
>> >>>> appears to be a duplicate backport that landed in the wrong
>> >>>> function.  We can see this in the stable-queue repo:
>> >>>>
>> >>>> stable-queue$ find . -name '*acpica-aml-interpreter-add-region-addr*'
>> >>>> |grep 4.19
>> >>>> ./releases/4.19.6/acpica-aml-interpreter-add-region-addresses-in-gl
>> >>>> oba
>> >>>> l-list-during-initialization.patch
>> >>>> ./releases/4.19.3/revert-acpica-aml-interpreter-add-region-addresse
>> >>>> s-i
>> >>>> n.patch
>> >>>> ./releases/4.19.35/acpica-aml-interpreter-add-region-addresses-in-g
>> >>>> lob al-list-during-initialization.patch
>> >>>> ./releases/4.19.2/acpica-aml-interpreter-add-region-addresses-in-gl
>> >>>> oba
>> >>>> l-list-during-initialization.patch
>> >>>>
>> >>>> So it was added to 4.19.2, reverted in .3, re-added in .6, and then
>> >>>> finally patched into a similar looking but wrong function in .35
>> >>>>
>> >>>> If we diff the .6 and .35 versions, we see the function difference:
>> >>>>
>> >>>> -@@ -417,6 +417,10 @@ acpi_ds_eval_region_operands(struct acpi
>> >>>> +@@ -523,6 +523,10 @@ acpi_ds_eval_table_region_operands(struc
>> >>>>
>> >>>> I don't know what the history is/was around the 2/3/6 churn, but
>> >>>> the re-addition in 4.19.35 to a different function sure looks wrong.
>> >>>>
>> >>>> The commit adds a call "status = acpi_ut_add_address_range(..." and
>> >>>> if we check mainline, there is only one in that file, but in
>> >>>> 4.19.35+ there now are two calls - since the two functions had
>> >>>> similar context and comments, it isn't hard to see how patch
>> >>>> could/would apply it a 2nd time in the wrong place.
>> >>>>
>> >>>> I didn't check if any of the other currently maintained
>> >>>> linux-stable versions also had this possible issue.
>> >>>>
>> >> Hi Greg,
>> >>
>> >>> Ugh, Rafael, did I mess this up again?  Can you check to see if I
>> >>> need to fix this somehow?
>> >> It should be called in acpi_ds_eval_region_operands rather than
>> acpi_ds_eval_table_region_operands.
>> >> Please remove the call from acpi_ds_eval_table_region_operands.
>> > Great, can someone please send me a patch for this so that I don't get
>> > it wrong myself?
>>
>> Erik, can you please cut a patch for that against 4.19.35 and send it to Greg?
>>
>
>I'm not sure what the process is for this case but here's the patch...
>Let me know if you need me to send it some other way...
>
>From a738f1c452c0762d3c0a1b1a9a12c78bd97b0a23 Mon Sep 17 00:00:00 2001
>From: Erik Schmauss <erik.schmauss@intel.com>
>Date: Wed, 15 May 2019 17:25:31 -0700
>Subject: [PATCH] Revert "ACPICA: AML interpreter: add region addresses in
> global list during initialization"
>
>This reverts commit f8053df634d40c733f26ca49c2c3835002e61b77 that was
>unintentionally included as a part of the stable branch.

So to clarify, we're now just going to revert it? It's not needed in
-stable?

--
Thanks,
Sasha
