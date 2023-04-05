Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A886D7F96
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 16:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbjDEOeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 10:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbjDEOeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 10:34:25 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B53C1
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 07:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1680705265; x=1712241265;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=vKSsmD1LFhGHckqi8FG6BhqL5uqs9ljlD+0dp7MmnaI=;
  b=UtfYN425pIiooEuFNrQaboK/YwYVC7k4m/GNTljGt2NEDzhw4cmS4mfn
   t5P16+mafmiAguc4bAAe4xF93d8QOquB7OIerNzCKOKZNr5srU5OLKFF3
   iWThMfKHVDjfHr4QgxCYssc67YYyZK6DQZ4L+UHic9h6s7C6i+nwaF5WR
   4=;
X-IronPort-AV: E=Sophos;i="5.98,321,1673913600"; 
   d="scan'208";a="315109822"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 14:34:17 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com (Postfix) with ESMTPS id 37DC6453A4;
        Wed,  5 Apr 2023 14:34:14 +0000 (UTC)
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 5 Apr 2023 14:34:01 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 5 Apr 2023 14:34:01 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id 66FB220D48; Wed,  5 Apr 2023 16:34:00 +0200 (CEST)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Steve French <stfrench@microsoft.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>, <stable@vger.kernel.org>,
        <patches@lists.linux.dev>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4] smb3: fix problem with null cifs super block with
 previous patch
References: <20230405135709.100174-1-ptyadav@amazon.de>
        <2023040523-delusion-corrode-f466@gregkh>
Date:   Wed, 5 Apr 2023 16:34:00 +0200
In-Reply-To: <2023040523-delusion-corrode-f466@gregkh> (Greg Kroah-Hartman's
        message of "Wed, 5 Apr 2023 16:20:40 +0200")
Message-ID: <mafs0fs9egzzb.fsf_-_@amazon.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05 2023, Greg Kroah-Hartman wrote:

> On Wed, Apr 05, 2023 at 03:57:09PM +0200, Pratyush Yadav wrote:
>> From: Steve French <stfrench@microsoft.com>
>>
>> [ Upstream commit 87f93d82e0952da18af4d978e7d887b4c5326c0b ]
>>
>> Add check for null cifs_sb to create_options helper
>>
>> Signed-off-by: Steve French <stfrench@microsoft.com>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>> ---
>>
>> Only compile-tested. This was discovered by our static code analysis
>> tool. I do not use CIFS and do not know how to actually reproduce the
>> NULL dereference.
>>
>> Follow up from [0]. Original patch is at [1].
>>
>> Mandatory text due to licensing terms:
>>
>> This bug was discovered and resolved using Coverity Static Analysis
>> Security Testing (SAST) by Synopsys, Inc.
>
> What?  That's funny.  And nothing I'm going to be adding to the
> changelog text, sorry, as that's not what is upstream.

That is fine by me. I placed this text below the 3 dashed lines so it
does _not_ end up in the commit message, but still discloses this
information.

> Please go poke your lawyers, that's not ok.

Yes, perhaps I should. But let's go forward with this patch since it
keeps the original commit message?

-- 
Regards,
Pratyush Yadav



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



