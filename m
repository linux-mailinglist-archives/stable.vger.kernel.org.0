Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEA511783F
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 22:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfLIVSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 16:18:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45544 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfLIVSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 16:18:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9LEJTt099179;
        Mon, 9 Dec 2019 21:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DcHo2qcfzMbQlUOHHHSb+VlsPwDr5lda2gZcp52PhOE=;
 b=j6Tb2U+ealnyosc4c714KslmFt3jbEt3DAhcv9T//5gCV1QRXwhsJkLrUa1Anbc7I3uX
 cvHGFHPs1PCwHF/QVkOK+dj0n68DoD4JKjuqxigScmCdkdGmmKsj8cc613fEACR4q73E
 dTd6bFJBVgqYiO0a7kcIm3GnnMC2ouWCtP41GcBWF94n0IH8Gz06/U7k0A66PizPLmve
 tFNmgnd2Sla5GF+Xur5UZNw/cF+TuPz9wFYCm+jSnXfcVGIV5gcvIyoQlq4WibRiAZPL
 ugcYOjQHvZ250UTq2DnSdImkWT/+3DNpWNdvu6brKG4/u5Z0+C3H08fZKCCYYejMahNk pQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2wr41q28yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 21:18:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB9LDike192068;
        Mon, 9 Dec 2019 21:18:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2wsv8amj78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Dec 2019 21:18:34 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB9LHLtl022412;
        Mon, 9 Dec 2019 21:17:21 GMT
Received: from bostrovs-us.us.oracle.com (/10.152.32.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Dec 2019 13:17:21 -0800
Subject: Re: [PATCH] xen/pciback: Prevent NULL pointer dereference in
 quirks_show
To:     "Nuernberger, Stefan" <snu@amazon.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Seidel, Conny" <consei@amazon.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "ross.lagerwall@citrix.com" <ross.lagerwall@citrix.com>,
        "Dannowski, Uwe" <uwed@amazon.de>
References: <20191206134804.4537-1-snu@amazon.com>
 <9917a357-12f6-107f-e08d-33e464036317@oracle.com>
 <1575655787.7257.42.camel@amazon.de>
 <4bc83b82-427f-2215-3161-5776867675a1@oracle.com>
 <1575915416.21160.49.camel@amazon.de>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <7e20daf7-e351-205d-183d-5861e0839c66@oracle.com>
Date:   Mon, 9 Dec 2019 16:21:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1575915416.21160.49.camel@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912090167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9466 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912090167
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/9/19 1:16 PM, Nuernberger, Stefan wrote:
> On Fri, 2019-12-06 at 15:15 -0500, Boris Ostrovsky wrote:
>> On 12/6/19 1:09 PM, Nuernberger, Stefan wrote:
>>> On Fri, 2019-12-06 at 10:11 -0500, Boris Ostrovsky wrote:
>>>> On 12/6/19 8:48 AM, Stefan Nuernberger wrote:
>>>>> From: Uwe Dannowski <uwed@amazon.de>
>>>>>   
>>>>>   		list_for_each_entry(cfg_entry, &dev_data-
>>>>>> config_fields, list) {
>>>> Couldn't you have the same race here?
>>> Not quite the same, but it might not be entirely safe yet. The
>>> 'quirks_show' takes the 'device_ids_lock' and races with unbind /
>>> 'pcistub_device_release' "which takes device_lock mutex". So this
>>> might
>>> now be a UAF read access instead of a NULL pointer dereference.
>> Yes, that's what I meant (although I don't see much difference in
>> this
>> context).
> Well, the NULL ptr access causes an instant kernel panic whereas we
> have not attributed crashes to the possible UAF read until now.
>
>>>   We have
>>> not observed adversarial effects in our testing (compared to the
>>> obvious issues with NULL pointer) but that's not a guarantee of
>>> course.
>>>
>>> So should quirks_show actually be protected by pcistub_devices_lock
>>> instead as are other functions that access dev_data? Does it need
>>> both
>>> locks in that case?
>> device_ids_lock protects device_ids list, which is not what you are
>> trying to access, so that doesn't look like right lock to hold. And
>> AFAICT pcistub_devices_lock is not held when device data is cleared
>> in
>> pcistub_device_release() (which I think is where we are racing).
> Indeed. The xen_pcibk_quirks list does not have a separate lock to
> protect it. It's either modified under 'pcistub_devices_lock', from
> pcistub_remove(), or iterated over with the 'device_ids_lock' held in
> quirks_show(). Also the quirks list is amended from
>    pcistub_init_device()
>      -> xen_pcibk_config_init_dev()
>        -> xen_pcibk_config_quirks_init()
> without holding any lock at all. In fact the
> pcistub_init_devices_late() and pcistub_seize() functions deliberately
> release the pcistub_devices_lock before calling pcistub_init_device().
> This looks broken.


Indeed.


>
> The race is between
>    pcistub_remove()
>      -> pcistub_device_put()
>        -> pcistub_device_release()
> on one side and the quirks_show() on the other side. The problematic
> quirk is freed from the xen_pcibk_quirks list in pcistub_remove() early
> on under pcistub_devices_lock before the associated dev_data is freed
> eventually. So switching from device_ids_lock to pcistub_devices_lock
> in quirks_show() could be sufficient to always have valid dev_data for
> all quirks in the list.


Yes, that should do it. (I missed xen_pcibk_config_quirk_release() call, 
which is why I wasn't sure pcistub_devices_lock is held where necessary).


>
> There is also pcistub_put_pci_dev() possibly in the race, called from
> xen_pcibk_remove_device(), or xen_pcibk_xenbus_remove(), or
> pcistub_remove(). The pcistub_remove() call site is safe when we switch
> to pcistub_devices_lock (same reasoning as above). For the others I
> currently do not see when the quirks are ever freed?


I wonder whether we should call xen_pcibk_config_quirk_release() from 
pcistub_device_release() under pcistub_devices_lock.


-boris

