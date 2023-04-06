Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5691A6D91EF
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 10:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjDFIso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 04:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbjDFIsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 04:48:40 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D404A7EC9
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 01:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1680770915; x=1712306915;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=eCCEIPDsX9p6xMK5oOcfZQj/UVGS7/pUHr5w0Qxmn+A=;
  b=hT/kDM9FaFL7WQRIz1fRoPYgUEueeSwdr4BPhhgTlyvilLpToQA9spHC
   6/xMbW3pPg//B7kvDl3TBUuS9SpMu2DKJ7C+wqL7ZFcdTv9ggkitw6h9V
   gmS8VT4LRwSlHVdwkeKfOsEER9681VhqSHm0suMwL1odHSvOq9eq0W3+1
   c=;
X-IronPort-AV: E=Sophos;i="5.98,323,1673913600"; 
   d="scan'208";a="326711923"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 08:48:28 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-83883bdb.us-west-2.amazon.com (Postfix) with ESMTPS id 6539060148;
        Thu,  6 Apr 2023 08:48:26 +0000 (UTC)
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 6 Apr 2023 08:48:26 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.250.64.145) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Thu, 6 Apr 2023 08:48:25 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id 72E1622BC6; Thu,  6 Apr 2023 10:48:24 +0200 (CEST)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Steve French <stfrench@microsoft.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Aurelien Aptel <aaptel@suse.com>, <stable@vger.kernel.org>,
        <patches@lists.linux.dev>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4] smb3: fix problem with null cifs super block with
 previous patch
References: <20230405135709.100174-1-ptyadav@amazon.de>
        <2023040523-delusion-corrode-f466@gregkh> <mafs0fs9egzzb.fsf_-_@amazon.de>
        <2023040514-ravishing-problem-9302@gregkh>
Date:   Thu, 6 Apr 2023 10:48:24 +0200
In-Reply-To: <2023040514-ravishing-problem-9302@gregkh> (Greg Kroah-Hartman's
        message of "Wed, 5 Apr 2023 19:04:35 +0200")
Message-ID: <mafs0bkk1gzvr.fsf_-_@amazon.de>
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

> On Wed, Apr 05, 2023 at 04:34:00PM +0200, Pratyush Yadav wrote:
>> On Wed, Apr 05 2023, Greg Kroah-Hartman wrote:
>>
>> > On Wed, Apr 05, 2023 at 03:57:09PM +0200, Pratyush Yadav wrote:
>> >> From: Steve French <stfrench@microsoft.com>
>> >>
>> >> [ Upstream commit 87f93d82e0952da18af4d978e7d887b4c5326c0b ]
>> >>
>> >> Add check for null cifs_sb to create_options helper
>> >>
>> >> Signed-off-by: Steve French <stfrench@microsoft.com>
>> >> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> >> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>> >> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>> >> ---
>> >>
>> >> Only compile-tested. This was discovered by our static code analysis
>> >> tool. I do not use CIFS and do not know how to actually reproduce the
>> >> NULL dereference.
>> >>
>> >> Follow up from [0]. Original patch is at [1].
>> >>
>> >> Mandatory text due to licensing terms:
>> >>
>> >> This bug was discovered and resolved using Coverity Static Analysis
>> >> Security Testing (SAST) by Synopsys, Inc.
>> >
>> > What?  That's funny.  And nothing I'm going to be adding to the
>> > changelog text, sorry, as that's not what is upstream.
>>
>> That is fine by me. I placed this text below the 3 dashed lines so it
>> does _not_ end up in the commit message, but still discloses this
>> information.
>>
>> > Please go poke your lawyers, that's not ok.
>>
>> Yes, perhaps I should. But let's go forward with this patch since it
>> keeps the original commit message?
>
> It's already been queued up, you should have gotten an email saying
> that, right?

Yes, I did, thanks! There was a bit of a race in me sending that email
and receiving the notification.

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



