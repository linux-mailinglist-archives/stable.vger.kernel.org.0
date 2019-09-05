Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFAFAAEA3
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 00:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731659AbfIEWmo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 18:42:44 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:37712 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725290AbfIEWmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 18:42:44 -0400
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85MfSmY023499;
        Thu, 5 Sep 2019 22:42:15 GMT
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        by mx0b-002e3701.pphosted.com with ESMTP id 2uu4s0axy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 22:42:15 +0000
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2353.austin.hpe.com (Postfix) with ESMTP id 69D5984;
        Thu,  5 Sep 2019 22:42:14 +0000 (UTC)
Received: from [16.116.163.9] (unknown [16.116.163.9])
        by g2t2360.austin.hpecorp.net (Postfix) with ESMTP id B1C1749;
        Thu,  5 Sep 2019 22:42:11 +0000 (UTC)
Subject: Re: [PATCH 6/8] x86/platform/uv: Decode UVsystab Info
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
 <20190905130253.325911213@stormcage.eag.rdlabs.hpecorp.net>
 <20190905141634.GA25790@kroah.com> <20190905214030.GE1616@sasha-vm>
From:   Mike Travis <mike.travis@hpe.com>
Message-ID: <9745d473-e4bc-7ae2-fc67-a898c3606088@hpe.com>
Date:   Thu, 5 Sep 2019 15:42:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905214030.GE1616@sasha-vm>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_09:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=946 suspectscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 phishscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909050211
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/5/2019 2:40 PM, Sasha Levin wrote:
> On Thu, Sep 05, 2019 at 04:16:34PM +0200, Greg KH wrote:
>> On Thu, Sep 05, 2019 at 08:02:58AM -0500, Mike Travis wrote:
>>> --- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
>>> +++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
>>> @@ -1303,7 +1303,8 @@ static int __init decode_uv_systab(void)
>>>      struct uv_systab *st;
>>>      int i;
>>>
>>> -    if (uv_hub_info->hub_revision < UV4_HUB_REVISION_BASE)
>>> +    /* Select only UV4 (hubbed or hubless) and higher */
>>> +    if (is_uv_hubbed(-2) < uv(4) && is_uv_hubless(-2) < uv(4))
> 
> For someone not too familiar with the code, this is completely
> unreadable. There must be a nicer way to do this.
> 
> -- 
> Thanks,
> Sasha

Hi Sasha,

I can put in further explanation but first the uv() function returns 1 
left shifted by the UV #:

static inline int uv(int uvtype)
{
         /* uv(0) is "any" */
         if (uvtype >= 0 && uvtype <= 30)
                 return 1 << uvtype;
         return 1;
}

The "is_uv_hubbed(x)" and "is_uv_hubless(x)" AND's the incoming arg with 
the actual uv type:

int is_uv_hubbed(int uvtype)
{
         return (uv_hubbed_system & uvtype);
}

The uv_hub{bed,less}_system is set to 1 left shifted by the UV # plus in 
bit 0 is a '1' to indicate "any" UV (as in "is_uv_hubbed(1)" is any UV 
hubbed system).  Hubbed indicates a hubbed system, and hubless indicates 
a hubless system, it cannot be both but can be neither.

>                 /* UV4 Hubless, (0x11:UV4+Any) */
>                 if (strncmp(oem_id, "NSGI4", 5) == 0)
>                         uv_hubless_system = 0x11;
> 
>                 /* UV3 Hubless, UV300/MC990X w/o hub (0x9:UV3+Any) */
>                 else
>                         uv_hubless_system = 0x9;
> 

(There are only hubbed versions of UV1 and UV2.)

Lastly (-2) translates to 0xffff...fffe (note bit 0 is clear to avoid 
the "any" bit.   So it is looking for a a hubbed or hubless UV system 
that is less than UV4 meaning only UV4,5,6...qualify, hence this comment:

 >>> +    /* Select only UV4 (hubbed or hubless) and higher */
	if (UV is less than UV4 either hubbed or hubless)
		return;  /* does not have an extended UVsystab */

Have you a suggestion on what would make it more clear?  Perhaps instead 
of -2 I should use a hex mask?

Thanks,
Mike


