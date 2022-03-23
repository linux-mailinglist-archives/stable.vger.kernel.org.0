Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E874E55A3
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 16:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241317AbiCWPt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 11:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238839AbiCWPt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 11:49:26 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D67A76E21;
        Wed, 23 Mar 2022 08:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648050477; x=1679586477;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6M1M82HPoA8EEVObNR5ULMG0Mtv8/Wfw1Iz63bAEOXA=;
  b=HXYb6jI13F0jtJuoBCoctnutAU/crkUojGFghLpT+KdmDciHIraH3bA5
   zzfEK586Udi3vTB4JvQCXnn2vBLO7D0tMVyWLGvh7qiDHmTb61cL3+9Fm
   RRXkVA4apPH+iOtvy0o7M13IuQ8jhi4bxJP/ExMF+uYIkm7F1e/NVpSTY
   g=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 23 Mar 2022 08:47:57 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 08:47:56 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 23 Mar 2022 08:47:56 -0700
Received: from [10.216.14.252] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 23 Mar
 2022 08:47:51 -0700
Message-ID: <e9ff041a-68a1-f74f-e9bf-351bf1591beb@quicinc.com>
Date:   Wed, 23 Mar 2022 21:17:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [patch 163/227] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Content-Language: en-US
To:     Michal Hocko <mhocko@suse.com>, <linux-kernel@vger.kernel.org>
CC:     Andrew Morton <akpm@linux-foundation.org>, <vbabka@suse.cz>,
        <surenb@google.com>, <stable@vger.kernel.org>,
        <sfr@canb.auug.org.au>, <rientjes@google.com>,
        <nadav.amit@gmail.com>, <patches@lists.linux.dev>,
        <linux-mm@kvack.org>, <mm-commits@vger.kernel.org>,
        <torvalds@linux-foundation.org>
References: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
 <20220322214648.AB7A1C340EC@smtp.kernel.org> <Yjpo2jnp5pkJr+XI@google.com>
 <YjraNQkmtkLiv1yz@dhcp22.suse.cz>
From:   Charan Teja Kalla <quic_charante@quicinc.com>
In-Reply-To: <YjraNQkmtkLiv1yz@dhcp22.suse.cz>
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



On 3/23/2022 1:58 PM, Michal Hocko wrote:
> On Tue 22-03-22 17:24:58, Minchan Kim wrote:
>> On Tue, Mar 22, 2022 at 02:46:48PM -0700, Andrew Morton wrote:
>>> From: Charan Teja Kalla <quic_charante@quicinc.com>
>>> Subject: mm: madvise: skip unmapped vma holes passed to process_madvise
>>>
>>> The process_madvise() system call is expected to skip holes in vma passed
>>> through 'struct iovec' vector list.  But do_madvise, which
>>> process_madvise() calls for each vma, returns ENOMEM in case of unmapped
>>> holes, despite the VMA is processed.
>>>
>>> Thus process_madvise() should treat ENOMEM as expected and consider the
>>> VMA passed to as processed and continue processing other vma's in the
>>> vector list.  Returning -ENOMEM to user, despite the VMA is processed,
>>> will be unable to figure out where to start the next madvise.
>>>
>>> Link: https://lkml.kernel.org/r/4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com
>> I thought it was still under discussion and Charan will post next
>> version along with previous patch
>> "mm: madvise: return correct bytes advised with process_madvise"
>>
>> https://lore.kernel.org/linux-mm/7207b2f5-6b3e-aea4-aa1b-9c6d849abe34@quicinc.com/
> Yes, I am not even sure the new semantic is sensible[1]. We should discuss
> that and see all the consequences. Changing the semantic of an existing
> syscall is always tricky going back and forth is even worse.

Starting the discussion @
https://lore.kernel.org/linux-mm/cover.1648046642.git.quic_charante@quicinc.com/

Thanks,
Charan

