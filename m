Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3961D4E3843
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 06:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbiCVFVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 01:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiCVFVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 01:21:33 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF81B29C;
        Mon, 21 Mar 2022 22:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1647926405; x=1679462405;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mxwNRxhZXnEhaBLVuTqpNgMwfQI6b2+lXrJsxhkw+1A=;
  b=E8D/ED2bdKxMQqCu/OG4RKtdIPvSSfEmXwDivdfBfk751zVtbkK6lNVI
   N2cOEbE3FVeFxrUsSnUv8mHy0zSe2oJE9m3MmTAjJsGgVobrIP+1hhJ6d
   wg+YDpZ17zs/OMUnMS4ZNnryLtBBsxZ1XTA2xe20W1mDep9XGHL4fdE5+
   M=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 21 Mar 2022 22:20:05 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 22:20:05 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 21 Mar 2022 22:20:04 -0700
Received: from [10.216.14.252] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 21 Mar
 2022 22:20:00 -0700
Message-ID: <72b4183b-2ec7-dc73-0c21-b12f342860d4@quicinc.com>
Date:   Tue, 22 Mar 2022 10:49:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>
CC:     Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <surenb@google.com>,
        <vbabka@suse.cz>, <rientjes@google.com>, <sfr@canb.auug.org.au>,
        <edgararriaga@google.com>, <nadav.amit@gmail.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        "# 5 . 10+" <stable@vger.kernel.org>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <YjEaFBWterxc3Nzf@google.com>
 <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
 <YjFAzuLKWw5eadtf@google.com>
 <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
 <YjiTn+7vw2rXA6K/@dhcp22.suse.cz>
From:   Charan Teja Kalla <quic_charante@quicinc.com>
In-Reply-To: <YjiTn+7vw2rXA6K/@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/21/2022 8:32 PM, Michal Hocko wrote:
>> It can return EINTR when:
>> -------------------------
>> 1) PTRACE_MODE_READ is being checked in mm_access() where it is waiting
>> on task->signal->exec_update_lock. EINTR returned from here guarantees
>> that process_madvise() didn't event start processing.
>> https://elixir.bootlin.com/linux/v5.16.14/source/mm/madvise.c#L1264 -->
>> https://elixir.bootlin.com/linux/v5.16.14/source/kernel/fork.c#L1318
>>
>> 2) The process_madvise() started processing VMA's but the required
>> behavior on a VMA needs mmap_write_lock_killable(), from where EINTR is
>> returned.
> Please note this will happen if the task has been killed. The return
> value doesn't really matter because the process won't run in userspace.

Okay, thanks here.

> 
>> The current behaviours supported by process_madvise(),
>> MADV_COLD, PAGEOUT, WILLNEED, just need read lock here.
>> https://elixir.bootlin.com/linux/v5.16.14/source/mm/madvise.c#L1164
>>  **Thus I think no way for EINTR can be returned by process_madvise() in
>> the middle of processing.** . No?
> Maybe not with the current implementation but I can easily imagine that
> there is a requirement to break out early when there is a signal pending
> (e.g. to support terminating madvise on a large memory rage). You would
> get EINTR then somehow need to communicate that to the userspace.

Agree. Will implement this.

