Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41257A8035
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 12:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfIDKSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 06:18:04 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:4920 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727351AbfIDKSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 06:18:04 -0400
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x84AG2G6011135;
        Wed, 4 Sep 2019 10:17:37 GMT
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com [15.241.140.78])
        by mx0b-002e3701.pphosted.com with ESMTP id 2usra9qyv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Sep 2019 10:17:37 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3425.houston.hpe.com (Postfix) with ESMTP id D6DF38D;
        Wed,  4 Sep 2019 10:17:35 +0000 (UTC)
Received: from [16.116.163.9] (unknown [16.116.163.9])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id 85BF856;
        Wed,  4 Sep 2019 10:17:34 +0000 (UTC)
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
 <98e34464-f9b7-6e78-6528-96b83f094282@hpe.com>
 <20190904065246.GB18003@infradead.org>
From:   Mike Travis <mike.travis@hpe.com>
Message-ID: <9a5a57a1-62ef-d1ad-55c1-30873ecb7ba6@hpe.com>
Date:   Wed, 4 Sep 2019 03:18:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904065246.GB18003@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_03:2019-09-03,2019-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 spamscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909040103
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christoph,

I can do these and leave some comments as markers to find the code to 
remove later.  The real problem is uv_mmrs.h is a generated file and the 
scripts cannot be easily redone.  Basically they copy in the verilog 
definition files from the UV HUB design files and create kernel 
compatible files that also then generate run-time checking of hardware 
specifics like MMR addresses and field definitions.  The change to 
remove those "is supported defines" takes a higher level process that 
cannot be done within this short release cycle.  We are racing to 
include this support in the next linux release for pending new hardware 
introductions.

Also that script is in a state of flux for the next UV arch and 
processor updates so changing anything at this moment is highly 
disruptive.  Is there a specific reason why this UV only code that does 
not touch anything else in the kernel and only affects our productivity 
and system performance appears to be such a problem with you?  And why 
now, at this moment, and after 10 years does it suddenly seem so 
important?  I'm all for clean up but not disruption.

Bottom line, I agree to all these changes and I promise to tend to them 
in the next release cycle.  But please let us get through this cycle 
without this much chaos?

Thanks,
Mike

On 9/3/2019 11:52 PM, Christoph Hellwig wrote:
> On Tue, Sep 03, 2019 at 11:58:49AM -0700, Mike Travis wrote:
>> Those ifdefs are not dead code and are being actively used.  Plus UV1
>> support is dead and I think the last running system died about a year ago
>> and no support or parts are available.  So undef'ing these macros will
>> simplify and reduce the size of the object code.
> 
> I'm not complaining about removing some ifdefs, that is always good.
> I complain about keeping the others that are dead.  And if Hub 1 is
> dead please drop all the checks and support code for it.
> 
> A patch against current mainline to show what I mean is below.
> 
> ---
>  From e84506399fa9436d47b33491d3e38e9dc3c718c7 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 3 Sep 2019 18:05:37 +0200
> Subject: x86/uv: Remove the dead UV?_HUB_IS_SUPPORTED defines
> 
> These are always set, so remove them and the dead code for the case
> where they are not defined.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/x86/include/asm/uv/uv_hub.h  | 38 -------------------------------
>   arch/x86/include/asm/uv/uv_mmrs.h |  7 ------
>   2 files changed, 45 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
> index 6eed0b379412..f71eb659f0de 100644
> --- a/arch/x86/include/asm/uv/uv_hub.h
> +++ b/arch/x86/include/asm/uv/uv_hub.h
> @@ -229,68 +229,33 @@ static inline struct uv_hub_info_s *uv_cpu_hub_info(int cpu)
>   #define UV4_HUB_REVISION_BASE		7
>   #define UV4A_HUB_REVISION_BASE		8	/* UV4 (fixed) rev 2 */
>   
> -#ifdef	UV1_HUB_IS_SUPPORTED
>   static inline int is_uv1_hub(void)
>   {
>   	return uv_hub_info->hub_revision < UV2_HUB_REVISION_BASE;
>   }
> -#else
> -static inline int is_uv1_hub(void)
> -{
> -	return 0;
> -}
> -#endif
>   
> -#ifdef	UV2_HUB_IS_SUPPORTED
>   static inline int is_uv2_hub(void)
>   {
>   	return ((uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE) &&
>   		(uv_hub_info->hub_revision < UV3_HUB_REVISION_BASE));
>   }
> -#else
> -static inline int is_uv2_hub(void)
> -{
> -	return 0;
> -}
> -#endif
>   
> -#ifdef	UV3_HUB_IS_SUPPORTED
>   static inline int is_uv3_hub(void)
>   {
>   	return ((uv_hub_info->hub_revision >= UV3_HUB_REVISION_BASE) &&
>   		(uv_hub_info->hub_revision < UV4_HUB_REVISION_BASE));
>   }
> -#else
> -static inline int is_uv3_hub(void)
> -{
> -	return 0;
> -}
> -#endif
>   
>   /* First test "is UV4A", then "is UV4" */
> -#ifdef	UV4A_HUB_IS_SUPPORTED
>   static inline int is_uv4a_hub(void)
>   {
>   	return (uv_hub_info->hub_revision >= UV4A_HUB_REVISION_BASE);
>   }
> -#else
> -static inline int is_uv4a_hub(void)
> -{
> -	return 0;
> -}
> -#endif
>   
> -#ifdef	UV4_HUB_IS_SUPPORTED
>   static inline int is_uv4_hub(void)
>   {
>   	return uv_hub_info->hub_revision >= UV4_HUB_REVISION_BASE;
>   }
> -#else
> -static inline int is_uv4_hub(void)
> -{
> -	return 0;
> -}
> -#endif
>   
>   static inline int is_uvx_hub(void)
>   {
> @@ -302,10 +267,7 @@ static inline int is_uvx_hub(void)
>   
>   static inline int is_uv_hub(void)
>   {
> -#ifdef	UV1_HUB_IS_SUPPORTED
>   	return uv_hub_info->hub_revision;
> -#endif
> -	return is_uvx_hub();
>   }
>   
>   union uvh_apicid {
> diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
> index 62c79e26a59a..9ee5ed6e8b34 100644
> --- a/arch/x86/include/asm/uv/uv_mmrs.h
> +++ b/arch/x86/include/asm/uv/uv_mmrs.h
> @@ -99,13 +99,6 @@
>   #define UV3_HUB_PART_NUMBER_X	0x4321
>   #define UV4_HUB_PART_NUMBER	0x99a1
>   
> -/* Compat: Indicate which UV Hubs are supported. */
> -#define UV1_HUB_IS_SUPPORTED	1
> -#define UV2_HUB_IS_SUPPORTED	1
> -#define UV3_HUB_IS_SUPPORTED	1
> -#define UV4_HUB_IS_SUPPORTED	1
> -#define UV4A_HUB_IS_SUPPORTED	1
> -
>   /* Error function to catch undefined references */
>   extern unsigned long uv_undefined(char *str);
>   
> 
