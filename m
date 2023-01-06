Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907CE65F988
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 03:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjAFCZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 21:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjAFCZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 21:25:04 -0500
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0133963F54
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 18:25:00 -0800 (PST)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230106022457epoutp03ea651692df74ecb2d02f2621eb1f3178~3lxO31HwO1672516725epoutp03l
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 02:24:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230106022457epoutp03ea651692df74ecb2d02f2621eb1f3178~3lxO31HwO1672516725epoutp03l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1672971897;
        bh=zYAVVwKbYWstk25NjpAYrxBF81yAcrHna5VCyCM4pz8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=mtMuKQAPQ5gb4u0njOYlSAGUXfO60S83nMptdarFtNEE07qbA+XQpbza2kUocTw2i
         f5OvZIsYVsK10mFrw0NAMK0d5CYOSUBx7ex60BKAQ2dqd5ezUq/uUK7f5XN8tuSaye
         BoSddzSg6iwwWUpjCWBXTPNoE/Xw3E2LROsf3yaY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20230106022457epcas2p1e8b266521fd8f3ab2e6b8cec6ec29135~3lxOdNyH42057020570epcas2p1i;
        Fri,  6 Jan 2023 02:24:57 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.102]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Np6cS3djLz4x9Q0; Fri,  6 Jan
        2023 02:24:56 +0000 (GMT)
X-AuditID: b6c32a47-619ff7000000f187-f5-63b786783a81
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.0F.61831.87687B36; Fri,  6 Jan 2023 11:24:56 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) [PATCH] scsi: ufs: core: fix devfreq deadlocks
Reply-To: j-young.choi@samsung.com
Sender: Jinyoung CHOI <j-young.choi@samsung.com>
From:   Jinyoung CHOI <j-young.choi@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>
CC:     Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Can Guo <quic_cang@quicinc.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB65750DE015FA51FDC08D994BFCFA9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20230106022456epcms2p784b3cf9115f6b170bdef0732258381ba@epcms2p7>
Date:   Fri, 06 Jan 2023 11:24:56 +0900
X-CMS-MailID: 20230106022456epcms2p784b3cf9115f6b170bdef0732258381ba
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMJsWRmVeSWpSXmKPExsWy7bCmuW5F2/Zkg0+XxSwezNvGZvHy51U2
        i2kffjJbvDykabHoxjYmixWVFpd3zWGz6L6+g81i+fF/TBYLO+ayWEy6toHNYsHGR4wOPB6X
        r3h7bFrVyeYxYdEBRo+PT2+xeEzcU+fRt2UVo8fnTXIe7Qe6mQI4orJtMlITU1KLFFLzkvNT
        MvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuVVIoS8wpBQoFJBYXK+nb2RTl
        l5akKmTkF5fYKqUWpOQUmBfoFSfmFpfmpevlpZZYGRoYGJkCFSZkZ9x9/pCpYBVnxew5p5ka
        GFexdzFyckgImEj0Tl3FCmILCexglDjaYdXFyMHBKyAo8XeHMEhYWMBOYs+x68wQJUoS59bM
        YgQpERYwkLjVaw4SZhPQk/i5ZAYbSFhEoEzizeWYLkYuDmaBTmaJB3sXQ23ilZjR/pQFwpaW
        2L58KyOIzSkQK7H60wxmiLiGxI9lvVC2qMTN1W/ZYez3x+YzQtgiEq33zkLVCEo8+LkbKi4p
        cejQV7AbJATyJTYcCIQI10i8XX4AqkRf4lrHRhaIB30lvvV5gIRZBFQl/k2/CDXRReL8vD6w
        rcwC8hLb385hBilnFtCUWL9LH2K4ssSRWywwPzVs/M2OzmYW4JPoOPwXLr5j3hMmiFY1iUVN
        RhMYlWchwngWklWzEFYtYGRexSiWWlCcm55abFRgDI/V5PzcTYzg1KrlvoNxxtsPeocYmTgY
        DzFKcDArifCW9W9LFuJNSaysSi3Kjy8qzUktPsRoCvTkRGYp0eR8YHLPK4k3NLE0MDEzMzQ3
        MjUwVxLnDdo6P1lIID2xJDU7NbUgtQimj4mDU6qBiel2a1D0/xDdE5+WTnwUvEqAXf8Yi/ak
        SFUG13+m8kvNW1jXPzvxsaFW7siX34cOc+463PP6Mff2YxvcIwLXdjWHfvv2zJTpXqZKUKNc
        laTdVOcU6z0PFujW8P230z1ed7XlSXJF0eyFS24Z9oflihhPYb3mzbHVddLRyyt+b9hhezQ8
        wSJrc65WX4wC3+w3X5LlnKXWPWS5tXH9uUNStcGLtwsucTfeWlVzRPmDVuJ6RVuW1dUn+ESq
        zh87NmlN1pH7LFZzp9qeyZade5OvpdS81GkuY8nVlR5HLYI1+id6+ky8saLWun/zqrXl6d+j
        IkS2HLj8WO6nlPTTecubku8oxLw223/x+qRH1qy1k5RYijMSDbWYi4oTAbW/Hvo2BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230105072134epcas2p47a72da1ee48e341295575770d3eb573c
References: <DM6PR04MB65750DE015FA51FDC08D994BFCFA9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20221222102121.18682-1-johan+linaro@kernel.org>
        <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
        <20230104141045.GB8114@asutoshd-linux1.qualcomm.com>
        <3db8c140-2e4e-0d75-4d81-b2c1f22f68d1@acm.org>
        <CGME20230105072134epcas2p47a72da1ee48e341295575770d3eb573c@epcms2p7>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> On 1/4/23 06:10, Asutosh Das wrote:
>> > Load based toggling of WB seemed fine to me then.
>> > I haven't thought about another method to toggle WriteBooster yet.
>> > Let me see if I can come up with something.
>> > IMT if you have a mechanism in mind, please let me know.
>> 
>> Hi Asutosh,
>> 
>> Which UFS devices need this mechanism? All UFS devices I'm familiar with can
>> achieve wire speed for large write requests without enabling the WriteBooster.
>This feature assures SLC-performance for writes to the WriteBooster buffer.
>So enabling it is advantageous as far as write performance.

I agree with you. Also, it can be used in various ways.

>As for the toggling functionality, compared to e.g. enabling it on init and leave it on,
>some flash vendors require it because of device health considerations.
>This is not the case for us, so let others to comment.

In our case, it does not matter whether to toggle or not.
To make the code simple, it seems to be a good way to enable it on init and leave it on.
Considering device health, WB can be disabled through lifetime check.

Thanks,
Jinyoung.

>
>Thanks,
>Avri
>> 
>> Thanks,
>> 
>> Bart.

