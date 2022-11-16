Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE4762C0EC
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 15:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiKPOc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 09:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKPOc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 09:32:59 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7057669;
        Wed, 16 Nov 2022 06:32:58 -0800 (PST)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 2AGDn4ZZ018984;
        Wed, 16 Nov 2022 14:32:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=Lsxlj5AabKJ7AffYDE479PSqYgJV4h1n1KSkSjcCA2Y=;
 b=mj/WxlNKFw7cyX3RIcWfDrAUXpFQicfBuUFDaCzLwx/m+AoS9L+d4DEnzJ0L2L65Tcg1
 1cnnWnwX26vohEcNhEtdWwJDrzd2vFI93H2VIuzHepLmcOFa/mhcTeZuSlGBvOqeHKGU
 LSKQ/msh0i7zyCObRZsvSv9OGaS2mX/VjmbOCAfWND2jExMrGorAZawvaIkepC8CkZmW
 2hPfOQ3jkd+TIgxI+K03joYFjXPBMyIur7saGG5fe/dDdUeiYvarNORS74AhG2ueFyGV
 NI8VDCEwwCoqAtcJqEEtqaQFZWA9hcaoe8UFLt2dExTnpS4dvh+h3i4XwjcZipwa4ZaK oA== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050095.ppops.net-00190b01. (PPS) with ESMTPS id 3kw132h1k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Nov 2022 14:32:46 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.17.1.5/8.17.1.5) with ESMTP id 2AGDcLCJ022718;
        Wed, 16 Nov 2022 09:32:42 -0500
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com (PPS) with ESMTP id 3kt7q49sf9-1;
        Wed, 16 Nov 2022 09:32:41 -0500
Received: from [172.19.33.48] (bos-lpa4700a.bos01.corp.akamai.com [172.19.33.48])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id BE5CD5306A;
        Wed, 16 Nov 2022 14:32:41 +0000 (GMT)
Message-ID: <f1afc4ed-505e-109f-9c4c-1053af2c1bcd@akamai.com>
Date:   Wed, 16 Nov 2022 09:32:41 -0500
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
 <Y3TGFJn7ykeUMk+O@zn.tnic>
From:   Jason Baron <jbaron@akamai.com>
In-Reply-To: <Y3TGFJn7ykeUMk+O@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=732 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211160101
X-Proofpoint-GUID: bkzVylsBtnEldxcXcuRCKIb6CFa6CAgp
X-Proofpoint-ORIG-GUID: bkzVylsBtnEldxcXcuRCKIb6CFa6CAgp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-16_03,2022-11-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=675 mlxscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211160100
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/16/22 06:14, Borislav Petkov wrote:
> On Tue, Nov 15, 2022 at 07:37:29PM -0500, Jason Baron wrote:
>> Currently, ghes_edac_register() is called via ghes_init() from acpi_init()
> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git/log/?h=edac-ghes__;!!GjvTz_vk!RVsGvU3qNqFLwWDFImJScVgizbxofNbNY-8NF2inDqKTrn3IWJdJdcQJ6FoKxFkWhEPRpYmwzw$ 
>
Hi Boris,

Thanks, yes this looks like it will address the regression. Is this
planned for 6.1?

Or 5.15 stable, which is where we hit this regression?

Thanks,

-Jason

