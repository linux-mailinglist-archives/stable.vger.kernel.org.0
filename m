Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C2B62C815
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 19:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiKPSpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 13:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbiKPSoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 13:44:39 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71101C68;
        Wed, 16 Nov 2022 10:43:31 -0800 (PST)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2AGITFN2017459;
        Wed, 16 Nov 2022 18:43:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=PVz8DE1+if9pFWMMr73CQxHTxNV1L8eNQQuz00I9uic=;
 b=mRUHzOh+j/uvoHasB/pC6B6JaZjKGpynafWrDTP24IQ0B+eBnC71AfN4snTJ3yqYhgFs
 tWJEHaVyQ3Nl39a+/1Lc7k3gpgKATpiiCVjBpn9UAqUKltezBwxPzTmt9GQ12bVrekWg
 7rE/Qd4H8Eco8GH+GLMg1fYyfb7JaGjV9Efw3441mHhIVvTxaEM4xL8iNJGTpE3eWq/S
 2Vw9dcimO8LWOeRaODl5eBOTBi/IzIthV8nsDi20skog2xm/RMcpF7ek3mvHNXWuRK+r
 OTRSOZGOs1RIWIqBW2kS67LDCK7uQe9uBbPS1/Q0WVQ8SuW7OIS6qwHjjT1wfsu7vTYr Ww== 
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
        by m0050096.ppops.net-00190b01. (PPS) with ESMTPS id 3kvv5ap2cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 18:43:12 +0000
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AGHn1X1023866;
        Wed, 16 Nov 2022 13:43:11 -0500
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint7.akamai.com (PPS) with ESMTP id 3kt7q4nmf4-1;
        Wed, 16 Nov 2022 13:43:11 -0500
Received: from [172.19.33.48] (bos-lpa4700a.bos01.corp.akamai.com [172.19.33.48])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id D1EFF600CD;
        Wed, 16 Nov 2022 18:43:10 +0000 (GMT)
Message-ID: <ea9bb9e6-17a5-7ca8-91cc-6c7bcbeac355@akamai.com>
Date:   Wed, 16 Nov 2022 13:43:10 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] EDAC/edac_module: order edac_init() before
 ghes_edac_register()
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Shuai Xue <xueshuai@linux.alibaba.com>, stable@vger.kernel.org
References: <20221116003729.194802-1-jbaron@akamai.com>
 <Y3TGFJn7ykeUMk+O@zn.tnic> <f1afc4ed-505e-109f-9c4c-1053af2c1bcd@akamai.com>
 <Y3Ut4L18XI+PGCze@zn.tnic>
From:   Jason Baron <jbaron@akamai.com>
In-Reply-To: <Y3Ut4L18XI+PGCze@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=500 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211160127
X-Proofpoint-ORIG-GUID: 5gYJ-NpzmG-Zuom9DnaRClrDbnDT5AtT
X-Proofpoint-GUID: 5gYJ-NpzmG-Zuom9DnaRClrDbnDT5AtT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=393 clxscore=1015 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160128
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/16/22 13:37, Borislav Petkov wrote:
> Hi,
>
> On Wed, Nov 16, 2022 at 09:32:41AM -0500, Jason Baron wrote:
>> Thanks, yes this looks like it will address the regression. Is this
>> planned for 6.1?
> 6.2.
>
>> Or 5.15 stable, which is where we hit this regression?
> No, I don't think it is stable material.
>
> Thx.
>
Ok, thanks. Is there any plan to address this in 5.15 stable/6.1 ?

Either with a revert or fixup as I proposed or something else?

Thanks,

-Jason

