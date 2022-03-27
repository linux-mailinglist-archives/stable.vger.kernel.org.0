Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D344E880D
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 16:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiC0OYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 10:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiC0OYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 10:24:09 -0400
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.49.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA922317A
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 07:22:29 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 4BB481410176
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 09:22:29 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id YTmnnzvbeb6UBYTmnn8MSn; Sun, 27 Mar 2022 09:22:29 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G/veNDzCNS5/sUVFJGizo3guRLL8pkQ0CB/O7gGvVxs=; b=EmL8qGcra7Wt23Kn0RbrN6quHi
        J9CWPtYJEhIPgJRb0guYbe+vH7gLtxbxdq5KxZR1SEeb/j1WKvTUVEa/0ifN69o8yjv+4QVKhKcps
        1aNwkwqofgKirE16tEjtE6h4A4XcLxRQhWKRJmArD9fE8Ts0ZAtSZBn9dFiU3k5B4mbLK0q3vEkA1
        iIBgjiYyJ0aOC/aHbDTZY3Q4DUWDMbQi56BtouuRTeEJm9dkf/8UXQwGb2zZaer7PPJUmotpipCWk
        Et5tlgfFS1ipzFrDJyH1XwWC9NXuEjV/5GYgihu8DzqTBPXj6HFRbBoozuLZy4+8Kb+TkLBeJcMSS
        whTuAXMQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54514)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nYTmm-001lFq-Md; Sun, 27 Mar 2022 14:22:28 +0000
Message-ID: <10cdb7dc-c210-8439-dacc-4338d3070f7f@roeck-us.net>
Date:   Sun, 27 Mar 2022 07:22:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] device: fix missing check on list iterator
Content-Language: en-US
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     airlied@linux.ie, bskeggs@redhat.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, kherbst@redhat.com,
        linux-kernel@vger.kernel.org, lyude@redhat.com,
        nouveau@lists.freedesktop.org, stable@vger.kernel.org
References: <80429172-37c6-c9ce-4df7-259bb90338a8@roeck-us.net>
 <20220327065950.7886-1-xiam0nd.tong@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220327065950.7886-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nYTmm-001lFq-Md
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54514
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 1
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/26/22 23:59, Xiaomeng Tong wrote:
> On Sat, 26 Mar 2022 22:38:05 -0700, Guenter Roeck <linux@roeck-us.net> wrote:
>>> @@ -103,11 +103,16 @@ nvkm_control_mthd_pstate_attr(struct nvkm_control *ctrl, void *data, u32 size)
>>>    		return -EINVAL;
>>>    
>>>    	if (args->v0.state != NVIF_CONTROL_PSTATE_ATTR_V0_STATE_CURRENT) {
>>> -		list_for_each_entry(pstate, &clk->states, head) {
>>> -			if (i++ == args->v0.state)
>>> +		list_for_each_entry(iter, &clk->states, head) {
>>> +			if (i++ == args->v0.state) {
>>> +				pstate = iter;
>>
>> Is iter and the assignment really necessary ? Unless I am missing something,
>> list_for_each_entry() always assigns pos (pstate/iter), even if the list is
>> empty. If nothing is found, pstate would be NULL at the end, so
> 
> the pstate will not be NULL at the end! so the assignment is necessary!
> #define list_for_each_entry(pos, head, member)                          \
>      for (pos = __container_of((head)->next, pos, member);               \
>           &pos->member != (head);                                        \
>           pos = __container_of(pos->member.next, pos, member))
> 


Uuh, yes, you are correct. Sorry for the noise.

Guenter

