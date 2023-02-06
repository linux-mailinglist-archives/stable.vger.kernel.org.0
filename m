Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4D268C433
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 18:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjBFRId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 12:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBFRI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 12:08:28 -0500
Received: from bird.elm.relay.mailchannels.net (bird.elm.relay.mailchannels.net [23.83.212.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1B22940B;
        Mon,  6 Feb 2023 09:08:26 -0800 (PST)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 625426C08DA;
        Mon,  6 Feb 2023 17:08:25 +0000 (UTC)
Received: from pdx1-sub0-mail-a221.dreamhost.com (unknown [127.0.0.6])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 811BA6C0C72;
        Mon,  6 Feb 2023 17:08:24 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1675703304; a=rsa-sha256;
        cv=none;
        b=fgwctutULoffn+Lu3imn3mOld/qaMzi2bJihJg1R9IIzLt24+8nNleMohfc6Da/UK5y6f7
        189eKhcbDM9i1QLROjNPaqETv0nKSQnYeNB6OyRUIZui5PHu6FtJQeI64eY0/vTnwEviDS
        1bi1cSAOT4en31IO68s4G/oGlNb/YcCLJ9FhOR4QE7E3dOXbd1lin5fD1aewjf8+F0fKwP
        3T97UbBwheD+vwcXgPSwdPooC2+MB7hzQVKHBFEnVTNYivzTn29ifBvZTP8K3xhfqT2ZF2
        pLYtzWCUp1ZBbLTwQAT49yK5sjcz8ImEjf0W5/N4rq0EO21ZN2qJDX52t1BzNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1675703304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:dkim-signature;
        bh=zIznFMDI6Lij7FER4Z78PRmQWP5O6fXpz/Om0xIe8N4=;
        b=cIj+joqvEjajKbNKATkqiJgUXu6DEp3SXSRn7fL2QM5HoRlZP1BezvbtQbeFJ47kjR9Z85
        RfOIjXWoekzSppoHkMYZKIKrv182rjCyw0vqevU6qe1qJ5iXkzhLZDHQZBPU2BrEX3lAJK
        ELD7fykFFh65TaKK9AHSMoCP3RBPKbw9Jnbfk+ZnqJJ8i5MQQ9u/LnA+gFFfOgcgIwB9Ui
        idZI8+UQfb3AkZNVfs4oSBNirbrOFiU0wi1cdAVSdDJdU/WDR5Eoa2Knl5VydjbdaI1Ybn
        2Ow7yMZixq7otg7mU95OjctS9DVmNGVY/5jxBCOqSuaNNFkw1HKDFUTSAbf8eQ==
ARC-Authentication-Results: i=1;
        rspamd-544f66f495-sp79h;
        auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Exultant-Shelf: 5d67a00933d30b44_1675703305130_2989549785
X-MC-Loop-Signature: 1675703305130:41392582
X-MC-Ingress-Time: 1675703305129
Received: from pdx1-sub0-mail-a221.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.103.24.28 (trex/6.7.1);
        Mon, 06 Feb 2023 17:08:25 +0000
Received: from offworld (ip72-199-50-187.sd.sd.cox.net [72.199.50.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dave@stgolabs.net)
        by pdx1-sub0-mail-a221.dreamhost.com (Postfix) with ESMTPSA id 4P9XlW2sWHz1D;
        Mon,  6 Feb 2023 09:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
        s=dreamhost; t=1675703304;
        bh=zIznFMDI6Lij7FER4Z78PRmQWP5O6fXpz/Om0xIe8N4=;
        h=Date:From:To:Cc:Subject:Content-Type;
        b=mXp8B55Ok+VGVQ3wv0CNCIijFteqatu7t72n1gJglNvPTOuL4d9ysY3cRFU1o+CDB
         dBTfkUddNW9DaaaEP8Hz8mkueG4EQLRNmk35aa9i1AvdaBmQbIgT/bN6Nfi7MruNsS
         w+3S3BqMeG9kySn/izBNQ7WiXacrbF5UwX/BBVUvVSto+n895E2CUlPdubePVhDW+U
         6aBONJrcOsSt4iTjB4AYZvlwP7YNiEnlU2YUCwQoszAuCoIuvfWSheOQiKcqz4SsbH
         XzFYLo+3c4Lb9sX6PRWWwN5uBJfQOFi5MfflGJPeufCoEoABxWPObHmIEW8ilkbKvR
         Rk87VjBdNWyBA==
Date:   Mon, 6 Feb 2023 08:40:56 -0800
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Gregory Price <gregory.price@memverge.com>
Cc:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <20230206164056.a4ifv3k4juadlazl@offworld>
Mail-Followup-To: Gregory Price <gregory.price@memverge.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <Y+CRyz0eFKfERZLD@memverge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y+CRyz0eFKfERZLD@memverge.com>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 06 Feb 2023, Gregory Price wrote:

>On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:
>> Summary:
>> --------
>>
>> CXL RAM support allows for the dynamic provisioning of new CXL RAM
>> regions, and more routinely, assembling a region from an existing
>> configuration established by platform-firmware. The latter is motivated
>> by CXL memory RAS (Reliability, Availability and Serviceability)
>> support, that requires associating device events with System Physical
>> Address ranges and vice versa.
>>
>> The 'Soft Reserved' policy rework arranges for performance
>> differentiated memory like CXL attached DRAM, or high-bandwidth memory,
>> to be designated for 'System RAM' by default, rather than the device-dax
>> dedicated access mode. That current device-dax default is confusing and
>> surprising for the Pareto of users that do not expect memory to be
>> quarantined for dedicated access by default. Most users expect all
>> 'System RAM'-capable memory to show up in FREE(1).
>
>Leverage the same QEMU branch, machine, and configuration as my prior
>tests, i'm now experiencing a kernel panic on boot.  Will debug a bit
>in the morning, but here is the stack trace i'm seeing
>
>Saw this in both 1 and 2 root port configurations

I also see it in "regular" pmem setups, and narrowed it down to this
change in the last patch:

-module_init(cxl_acpi_init);
+/* load before dax_hmem sees 'Soft Reserved' CXL ranges */
+subsys_initcall(cxl_acpi_init);
