Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7494F7AE3
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 11:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbiDGJDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 05:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243770AbiDGJDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 05:03:32 -0400
Received: from mx07-00178001.pphosted.com (mx07-00178001.pphosted.com [185.132.182.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4913205A;
        Thu,  7 Apr 2022 02:01:31 -0700 (PDT)
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23743g5e001248;
        Thu, 7 Apr 2022 11:01:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=selector1;
 bh=1ezUATS7YucgATnJzZ/8KE0ypMPsbEqbkpxpFXJwO8U=;
 b=3Ll0G2zY4iXhpM85f2y+tpuAkUiZ6MD+ymFHIxX5IdzbfmP9Rv2LnfP+hejpS+l/tsGx
 0t8+fixaS+WItL/S+j7XXa0Yt+K/U7T+iBrUb2rz51bPN3vkg0IFzodk8NFSgdnKyE+e
 +rxyiWuAJh8OZ2+1p+5cgd9EB6gm6QrdTtuPL0a0z+k07TWVAvM8S+cyG6GLxoMv0Nc4
 uEJmSTd3vkoDxAXOKJtKpfmOePhh+b1NTtDjobiwX190HbtdLnBzeXE9a7APjqgxLY/5
 IUgldEdtq/qcdBNeiicTIZduR6tKo/Cw25+ODeHmxY+89tj9NGu8DPYtD28IUexIr9jY Kg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3f6du13hsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 11:01:21 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B9A3B10002A;
        Thu,  7 Apr 2022 11:01:20 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9EE16215159;
        Thu,  7 Apr 2022 11:01:20 +0200 (CEST)
Received: from [10.201.22.81] (10.75.127.51) by SFHDAG2NODE2.st.com
 (10.75.127.5) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Thu, 7 Apr
 2022 11:01:19 +0200
Message-ID: <f2d9d0e9-aecf-6436-6ff5-56b4ccb98f6c@foss.st.com>
Date:   Thu, 7 Apr 2022 11:01:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] stm: ltdc: fix two incorrect NULL checks on list iterator
Content-Language: en-US
To:     Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        <yannick.fertre@foss.st.com>
CC:     <airlied@linux.ie>, <daniel@ffwll.ch>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@foss.st.com>, <marex@denx.de>,
        <dri-devel@lists.freedesktop.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20220327055355.3808-1-xiam0nd.tong@gmail.com>
 <be2042d2-e315-223d-5454-ebfb934f9d2d@foss.st.com>
From:   Philippe CORNU <philippe.cornu@foss.st.com>
In-Reply-To: <be2042d2-e315-223d-5454-ebfb934f9d2d@foss.st.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/28/22 14:37, Raphael Gallais-Pou wrote:
> Hello Xiaomeng
> 
> On 3/27/22 07:53, Xiaomeng Tong wrote:
>> The two bugs are here:
>> 	if (encoder) {
>> 	if (bridge && bridge->timings)
>>
>> The list iterator value 'encoder/bridge' will *always* be set and
>> non-NULL by drm_for_each_encoder()/list_for_each_entry(), so it is
>> incorrect to assume that the iterator value will be NULL if the
>> list is empty or no element is found.
>>
>> To fix the bug, use a new variable '*_iter' as the list iterator,
>> while use the old variable 'encoder/bridge' as a dedicated pointer
>> to point to the found element.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 99e360442f223 ("drm/stm: Fix bus_flags handling")
>> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
>> ---
>>   drivers/gpu/drm/stm/ltdc.c | 16 ++++++++++------
>>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> 
> Thanks for your fix
> 
> Acked-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
> 
> 
> Raphaël Gallais-Pou
> 

Applied on drm-misc-next.
Many thanks for your patch,
Philippe :-)
