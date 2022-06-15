Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED42E54CB52
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 16:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiFOO24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 10:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347416AbiFOO23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 10:28:29 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB051D321
        for <stable@vger.kernel.org>; Wed, 15 Jun 2022 07:28:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 15D5335F;
        Wed, 15 Jun 2022 14:28:28 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 15D5335F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1655303308; bh=vC9CwTdZm/z4Pz05ijVwgi0T285E+Nc749dDtbDBeGA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=DTHl2fuVd21n0ootoa07lZCvZ5aKSDBF0aoRrd9rhFyjwXKJHTmTJBAzJWDOYnhv0
         4xsBdLyrQKe+YrCXn7j8fzRN6wbyYbCvrnfBSiYxJiz1mvMipb9cAsPDVfXLldLKsR
         ZbdnPTRdppX5NMLE2TFuS363wVccn6ZpxIts2UkL0umlG23cCge/+/D8BtprRIwBSZ
         5YhIZJaTj1slK+fdIdj/KupZzp3JzpJsjo1o/CTmsAaswXpMAC8M0vSwVibiWuZWto
         upyxO2fLkjDUSWM8Tdl3c4+ytFpTT6/l8X/wOHB2hJkvI6EwilQ9V5wuUI5LM2RiN3
         M3RJ5yzaIiMtQ==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 5.18 01/11] Documentation: Add documentation for
 Processor MMIO Stale Data
In-Reply-To: <20220615032507.go6t24dyzotpe3xv@guptapa-desk>
References: <20220614183720.861582392@linuxfoundation.org>
 <20220614183721.248466580@linuxfoundation.org>
 <94468546-5571-b61f-0d98-8501626e30e3@gmail.com>
 <20220615032507.go6t24dyzotpe3xv@guptapa-desk>
Date:   Wed, 15 Jun 2022 08:28:27 -0600
Message-ID: <87tu8muhkk.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pawan Gupta <pawan.kumar.gupta@linux.intel.com> writes:

> On Wed, Jun 15, 2022 at 08:06:37AM +0700, Bagas Sanjaya wrote:
>>On 6/15/22 01:40, Greg Kroah-Hartman wrote:
>>> +  .. list-table::
>>> +
>>> +     * - 'Not affected'
>>> +       - The processor is not vulnerable
>>> +     * - 'Vulnerable'
>>> +       - The processor is vulnerable, but no mitigation enabled
>>> +     * - 'Vulnerable: Clear CPU buffers attempted, no microcode'
>>> +       - The processor is vulnerable, but microcode is not updated. The
>>> +         mitigation is enabled on a best effort basis.
>>> +     * - 'Mitigation: Clear CPU buffers'
>>> +       - The processor is vulnerable and the CPU buffer clearing mitigation is
>>> +         enabled.
>>> +
>>> +If the processor is vulnerable then the following information is appended to
>>> +the above information:
>>> +
>>> +  ========================  ===========================================
>>> +  'SMT vulnerable'          SMT is enabled
>>> +  'SMT disabled'            SMT is disabled
>>> +  'SMT Host state unknown'  Kernel runs in a VM, Host SMT state unknown
>>> +  ========================  ===========================================
>>> +
>>
>>Why is list-table used in sysfs table instead of usual ASCII table in SMT
>>vulnerabilities list above? I think using ASCII table in both cases is enough
>>for the purpose.
>
> Maybe you are right (and I am no expert in this), but quite a few
> documents use list-table for sysfs status:
>
>    https://www.kernel.org/doc/Documentation/admin-guide/hw-vuln/mds.rst
>    https://www.kernel.org/doc/Documentation/admin-guide/hw-vuln/spectre.rst
>    https://www.kernel.org/doc/Documentation/admin-guide/hw-vuln/tsx_async_abort.rst

List-table should really be avoided whenever possible; it makes reading
the plain-text files difficult at best.  I'd like to see the existing
uses taken out over time.

This isn't really something to be addressed in the stable updates,
though.

jon
