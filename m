Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2092AA72F1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfICS6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:58:41 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:37256 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbfICS6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:58:41 -0400
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83IuRI4028761;
        Tue, 3 Sep 2019 18:58:22 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        by mx0a-002e3701.pphosted.com with ESMTP id 2usht0dy7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 18:58:22 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id BCEBA66;
        Tue,  3 Sep 2019 18:58:21 +0000 (UTC)
Received: from [16.116.163.9] (unknown [16.116.163.9])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id 80AD44C;
        Tue,  3 Sep 2019 18:58:19 +0000 (UTC)
Subject: Re: [PATCH 8/8] x86/platform/uv: Account for UV Hubless in is_uvX_hub
 Ops
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903001816.705097213@stormcage.eag.rdlabs.hpecorp.net>
 <20190903161917.GA23281@infradead.org>
From:   Mike Travis <mike.travis@hpe.com>
Message-ID: <98e34464-f9b7-6e78-6528-96b83f094282@hpe.com>
Date:   Tue, 3 Sep 2019 11:58:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903161917.GA23281@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_04:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 mlxlogscore=662 lowpriorityscore=0 spamscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909030187
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/3/2019 9:19 AM, Christoph Hellwig wrote:
> On Mon, Sep 02, 2019 at 07:18:23PM -0500, Mike Travis wrote:
>> +#ifdef	UV1_HUB_IS_SUPPORTED
> 
> All these ifdefs are dead code, please just remove them.

Those ifdefs are not dead code and are being actively used.  Plus UV1 
support is dead and I think the last running system died about a year 
ago and no support or parts are available.  So undef'ing these macros 
will simplify and reduce the size of the object code.

> Also it seems like at least the various mmr macros just check
> for a specific version, I think you are much better off just
> using a switch statement for the possible revisions there.
> 
>> +		return (uv_hub_info->hub_revision == UV4A_HUB_REVISION_BASE);

The problem is those revision bases can change if a UV HUB revision 
changes.  That is why there are ranges and why I'm converting them to 
"uv_type".  Some UV kernel source code still needs to know the exact HUB 
revision, like (again) hwperf.

> 
> And none of these braces are required.
> 

Sure, I can take those out now, but usually I then get bit by 
checkpatches which then says "parenthesis's are required".
