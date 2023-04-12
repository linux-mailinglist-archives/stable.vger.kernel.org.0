Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6D06DF6EA
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 15:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjDLNWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 09:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjDLNWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 09:22:13 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5703C5B93
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 06:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1681305716; x=1712841716;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=W1YWd/ajlgzCQjykkjTTvd7zscEqaBR3mrcxNHNa3BY=;
  b=qnfSFAKcEMcpxYQuCVZxk30MyjMFehyEonhDnV8jTz78dhWsFVsbDUNi
   xQsC0bPMwXRg0ovhL8z8dJJ64VtyDQHzvGeqjgU0le/4vRpRLlP6txOX+
   wl6ma42D/KFaPSC6VRMNC4Ndb1+FledDh3irkLh41JKe/g2Q8ka6HwTJl
   s=;
X-IronPort-AV: E=Sophos;i="5.98,339,1673913600"; 
   d="scan'208";a="317513665"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 13:21:39 +0000
Received: from EX19MTAUEB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 4D32780F25;
        Wed, 12 Apr 2023 13:21:37 +0000 (UTC)
Received: from EX19MTAUEA001.ant.amazon.com (10.252.134.203) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 12 Apr 2023 13:21:36 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.252.134.102) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 12 Apr 2023 13:21:36 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id E04EA20D22; Wed, 12 Apr 2023 15:21:34 +0200 (CEST)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     Yujie Liu <yujie.liu@intel.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>, <stable@vger.kernel.org>,
        <oe-kbuild-all@lists.linux.dev>
Subject: Re: [PATCH 5.4] cifs/smb3: Fix NULL pointer dereference in
 smb2_query_info_compound()
References: <ZC1fJiHvpbXcysXi@ec83ac1404bb> <mafs0o7o2h7o7.fsf@amazon.de>
        <2023040539-cherub-flattered-bcc0@gregkh>
        <2023040528-maroon-running-0fe2@gregkh> <mafs0jzyqh2sf.fsf_-_@amazon.de>
        <2023040502-shortcut-curtly-cc96@gregkh> <ZDZh+7jJgg4DR+IA@yujie-X299>
Date:   Wed, 12 Apr 2023 15:21:34 +0200
In-Reply-To: <ZDZh+7jJgg4DR+IA@yujie-X299> (Yujie Liu's message of "Wed, 12
        Apr 2023 15:47:07 +0800")
Message-ID: <mafs0h6tlb5i9.fsf_-_@amazon.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SPF_PERMERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12 2023, Yujie Liu wrote:

> Hi Greg, Hi Pratyush,
>
> On Wed, Apr 05, 2023 at 04:22:58PM +0200, Greg KH wrote:
>> On Wed, Apr 05, 2023 at 03:33:20PM +0200, Pratyush Yadav wrote:
>> > On Wed, Apr 05 2023, Greg KH wrote:
>> >
>> > > On Wed, Apr 05, 2023 at 02:26:04PM +0200, Greg KH wrote:
>> > >> On Wed, Apr 05, 2023 at 01:47:52PM +0200, Pratyush Yadav wrote:
>> > >> > On Wed, Apr 05 2023, kernel test robot wrote:
>> > >> >
>> > >> > > Hi,
>> > >> > >
>> > >> > > Thanks for your patch.
>> > >> > >
>> > >> > > FYI: kernel test robot notices the stable kernel rule is not satisfied.
>> > >> > >
>> > >> > > Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
>
> Sorry the info at here is not accurate enough. We will improve the
> wording.
>
>> > >> >
>> > >> > I think the robot should also learn to look at the 'To:' header :-)
>> > >>
>> > >> Nope, the robot is correct, you submitted this incorrectly.
>> > >
>> > > Wait, maybe, I can't tell.
>> >
>> > My point is that it does not matter much if stable@vger.kernel.org is in
>> > Cc or To. It gets the email regardless. In fact, that seems quite a
>> > common practice to me [0][1]. So I'd say it would be nice if the robot
>> > did not needlessly complain about this.
>> >
>> > [0] https://lore.kernel.org/stable/20230403140414.236685532@linuxfoundation.org/
>> > [1] https://lore.kernel.org/stable/20230403140415.140110769@linuxfoundation.org/
>> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=87f93d82e0952da18af4d978e7d887b4c5326c0b
>
> This warning is not caused by "stable@vger.kernel.org is in To or Cc".
>
> The document at [3] gives three options for sending patches to stable,
> and seems option 3 should apply on this patch:
>
> [3] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>
> Option 3
>
> Send the patch, after verifying that it follows the above rules, to stable@vger.kernel.org. You must note the upstream commit ID in the changelog of your submission, as well as the kernel version you wish it to be applied to.
>
> The examples in link [0][1] have "upstream commit" in the changelog, but
> this patch doesn't, so the robot flags a warning.

It is entirely possible for a patch for a stable tree to not have an
upstream commit. For example, I sent a patch recently [0] that was
caused by a buggy backport. The patch to fix it of course would not have
an upstream commit since upstream was correct from the get-go. The bot
should not complain about such patches.

Funnily enough the bot did not complain there even though that patch
also does not have an upstream commit hash. But it puts
stable@vger.kernel.org in Cc instead of To.

[0] https://lore.kernel.org/all/20230411130210.113555-1-ptyadav@amazon.de/

>
>> The robot replaces my bot (well, aguments this), and it rightfully flags
>> many patches that are sent to stable that are not done so correctly, so
>> that the submitter can then fix them up.  The number of "false
>> positives" like this is pretty low, as hey, even I got it wrong when
>> reading this "by hand".
>
> Thanks for the affirmation of our robot. Could you help give some
> suggestions so we can further improve the robot to reduce "false
> positives"? Do we still need to check "upstream commit" in changelog for
> similar cases?
>
> --
> Best Regards,
> Yujie

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



