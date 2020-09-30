Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1FD27EABD
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 16:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbgI3OPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 10:15:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57820 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728232AbgI3OPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 10:15:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UEF6BL190840;
        Wed, 30 Sep 2020 14:15:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yVEkO2onJos5c2Ghmv12wD1fgQT2ciP+YXzItJV2F+U=;
 b=neOJPv5m18Yv+iPv5WHZi8+iQ1V0nSDiwJgzRa9gA7bqgEpknAvZ5K0HgFBUj0nuFbrH
 /5Q3rgzNJp4nQrOTDieyBnOK2XaWyF1gOgNoP050JbBXPLfB1tGS/fffAfcWsHtDG70k
 FRkwtJUDXoDxYKbJ+SFWjvoOeDwOh7fH6Eh3oqT2OHeribHSC6IvQJARMjjNeyBnZf8I
 KSdTbGk6m/9zzp+sCUhlerW0y3qUCkl4p9l4xDevmwF1XNKJowdLPziTCjjLhciGQ8lA
 1uWnQ/YL6BVjBaUQeSMdWn16lmGpgWOvDUFJ3QjDZIOFRfaHdU+zoaI07AqVRDYfez/9 fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9n8nqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 14:15:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UEAVcR168830;
        Wed, 30 Sep 2020 14:15:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfj0680r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 14:15:02 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08UEF1YC024910;
        Wed, 30 Sep 2020 14:15:01 GMT
Received: from [10.74.86.12] (/10.74.86.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 07:15:00 -0700
Subject: Re: [PATCH v2] x86/xen: disable Firmware First mode for correctable
 memory errors
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
References: <20200925140751.31381-1-jgross@suse.com>
From:   boris.ostrovsky@oracle.com
Organization: Oracle Corporation
Message-ID: <dd24ff96-4b45-4f5f-62c9-09f0f62c6da4@oracle.com>
Date:   Wed, 30 Sep 2020 10:14:58 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200925140751.31381-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300113
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/25/20 10:07 AM, Juergen Gross wrote:
> When running as Xen dom0 the kernel isn't responsible for selecting the
> error handling mode, this should be handled by the hypervisor.
>
> So disable setting FF mode when running as Xen pv guest. Not doing so
> might result in boot splats like:
>
> [    7.509696] HEST: Enabling Firmware First mode for corrected errors.
> [    7.510382] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 2.
> [    7.510383] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 3.
> [    7.510384] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 4.
> [    7.510384] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 5.
> [    7.510385] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 6.
> [    7.510386] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 7.
> [    7.510386] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 8.
>
> Reason is that the HEST ACPI table contains the real number of MCA
> banks, while the hypervisor is emulating only 2 banks for guests.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


Applied to for-linus-5.10



-boris

