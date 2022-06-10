Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37ABC546D4A
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 21:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346255AbiFJTb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 15:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345235AbiFJTb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 15:31:56 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802132F007
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 12:31:54 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 38BCE100007;
        Fri, 10 Jun 2022 19:31:51 +0000 (UTC)
Message-ID: <1958f430-b56a-851a-71ac-e0ed58420000@ovn.org>
Date:   Fri, 10 Jun 2022 21:31:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Cc:     i.maximets@ovn.org, stable@vger.kernel.org, echaudro@redhat.com
Subject: Re: net/sched: act_police: more accurate MTU policing
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <YqNcHbk0K20+qfxP@dcaratti.users.ipa.redhat.com>
 <YqNeoTphHJV5jRYy@kroah.com> <YqN6oALiUdh7vnCE@dcaratti.users.ipa.redhat.com>
From:   Ilya Maximets <i.maximets@ovn.org>
In-Reply-To: <YqN6oALiUdh7vnCE@dcaratti.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/10/22 19:08, Davide Caratti wrote:
> hello Greg,
> 
> thanks for looking at this!
> 
> On Fri, Jun 10, 2022 at 05:09:21PM +0200, Greg KH wrote:
>> On Fri, Jun 10, 2022 at 04:58:37PM +0200, Davide Caratti wrote:
>>> hello,
>>>
>>> Ilya reports bad TCP throughput when GSO packets hit an OVS rule that does
>>> tc MTU policing. According to his observations [1], the problem is fixed
>>> by upstream commit 4ddc844eb81d ("net/sched: act_police: more accurate MTU
>>> policing"). Can we queue this commit for inclusion in stable trees?
>>
>> Did you test this,
> 
> I tested it on upstream, RHEL8 and RHEL9 kernels. BTW, the kselftest I included
> in the commit only verifies the correct setting for the MTU threshold, not
> the GSO problem (to test GSO, we should use netperf / iperf3 rather than
> mausezahn to generate traffic).
> 
>> and what kernel(s) do you want it applied to?
> 
> the reported bug is in act_police since the very beginning; however, the
> patch should apply cleanly at least on 5.x kernels. On older ones, there
> might be a small conflict due to lack of RCU-ification of struct
> tcf_police_params.
> A conflict that gets fixed easily, but in case we need it I volunteer to
> write a patch for kernels older than 4.20. @Ilya, what is the
> minimum kernel usable for openvswitch with MTU policing?

act_police MTU check is supposed to be an alternative for OVS' check_pkt_len()
action which was introduced in 5.2.  So, backport to 5.2+ should be enough.

Best regards, Ilya Maximets.
