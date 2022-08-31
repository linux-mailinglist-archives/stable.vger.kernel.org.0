Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C05A80CE
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 17:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiHaPBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 11:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiHaPBV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 11:01:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FB29C8FE
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 08:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661958078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QihsBjiZvNOELw0Rtm2S0fzDvkyeBUo3nxHPcuLxME0=;
        b=MO4u7cGMqILy3BjaAr/yelgaIFOY2SGcMQkUYSnBchvxhoiwsMCB4PoCEobFE6hOyNSTuJ
        C0TzGkVuCMbxRCZ+yJSmWReIQ97bUE2+Mzs9OMWh1awnYHRmI6lRyYCOAaXLiN6V+yPgPL
        gaZ1O31FdUu4chlhOkHTBBZOsqLyJow=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-rsAfYAwUOH212GukbWNnIg-1; Wed, 31 Aug 2022 11:01:16 -0400
X-MC-Unique: rsAfYAwUOH212GukbWNnIg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 910051C01B34;
        Wed, 31 Aug 2022 15:01:15 +0000 (UTC)
Received: from [10.39.208.41] (unknown [10.39.208.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37F82403344;
        Wed, 31 Aug 2022 15:01:13 +0000 (UTC)
Message-ID: <796c9d73-30a0-2401-e499-724aeb0f8dc6@redhat.com>
Date:   Wed, 31 Aug 2022 17:01:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2] vduse: prevent uninitialized memory accesses
Content-Language: en-US
To:     jasowang@redhat.com, Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, elic@nvidia.com,
        guanjun@linux.alibaba.com, parav@nvidia.com,
        gautam.dawar@xilinx.com, dan.carpenter@oracle.com,
        xieyongji@bytedance.com, mst@redhat.com, stable@vger.kernel.org
References: <20220829073424.5677-1-maxime.coquelin@redhat.com>
 <YwxvXFiuRqGxRgZH@kroah.com>
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
In-Reply-To: <YwxvXFiuRqGxRgZH@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/29/22 09:48, Greg KH wrote:
> On Mon, Aug 29, 2022 at 09:34:24AM +0200, Maxime Coquelin wrote:
>> If the VDUSE application provides a smaller config space
>> than the driver expects, the driver may use uninitialized
>> memory from the stack.
>>
>> This patch prevents it by initializing the buffer passed by
>> the driver to store the config value.
>>
>> This fix addresses CVE-2022-2308.
>>
>> Cc: xieyongji@bytedance.com
>> Cc: stable@vger.kernel.org # v5.15+
>> Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
>>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
> 
> Please no blank line above the Acked-by: line here if possible.

Sure.

Jason, do you prefer I post a new revision with this single change or
you will handle it while applying? Either way is fine to me.

Thanks,
Maxime

> thanks,
> 
> greg k-h
> 

