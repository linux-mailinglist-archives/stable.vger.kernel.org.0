Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E338ADFB
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 06:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfHMEqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 00:46:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbfHMEqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 00:46:33 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7D4hDJC144720
        for <stable@vger.kernel.org>; Tue, 13 Aug 2019 00:46:31 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ubkjbwa6y-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 13 Aug 2019 00:46:31 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <mahesh@linux.vnet.ibm.com>;
        Tue, 13 Aug 2019 05:46:29 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 13 Aug 2019 05:46:27 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7D4kPmD61669452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 04:46:25 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D56E42041;
        Tue, 13 Aug 2019 04:46:25 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45D624203F;
        Tue, 13 Aug 2019 04:46:22 +0000 (GMT)
Received: from [9.193.100.20] (unknown [9.193.100.20])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Aug 2019 04:46:22 +0000 (GMT)
Subject: Re: [PATCH v9 1/7] powerpc/mce: Schedule work from irq_work
To:     Santosh Sivaraj <santosh@fossix.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc:     "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>,
        Reza Arbab <arbab@linux.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        christophe leroy <christophe.leroy@c-s.fr>,
        stable@vger.kernel.org
References: <20190812092236.16648-1-santosh@fossix.org>
 <20190812092236.16648-2-santosh@fossix.org>
From:   Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Date:   Tue, 13 Aug 2019 10:16:21 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190812092236.16648-2-santosh@fossix.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19081304-0008-0000-0000-000003086463
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081304-0009-0000-0000-00004A26755B
Message-Id: <80d055bb-945c-e43d-05bb-6c33ec2f0c6f@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130050
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/12/19 2:52 PM, Santosh Sivaraj wrote:
> schedule_work() cannot be called from MCE exception context as MCE can
> interrupt even in interrupt disabled context.
> 
> fixes: 733e4a4c ("powerpc/mce: hookup memory_failure for UE errors")
> Suggested-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
> Cc: stable@vger.kernel.org # v4.15+
> ---
>  arch/powerpc/kernel/mce.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Reviewed-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

Thanks,
-Mahesh.

> 
> diff --git a/arch/powerpc/kernel/mce.c b/arch/powerpc/kernel/mce.c
> index b18df633eae9..cff31d4a501f 100644
> --- a/arch/powerpc/kernel/mce.c
> +++ b/arch/powerpc/kernel/mce.c
> @@ -33,6 +33,7 @@ static DEFINE_PER_CPU(struct machine_check_event[MAX_MC_EVT],
>  					mce_ue_event_queue);
>  
>  static void machine_check_process_queued_event(struct irq_work *work);
> +static void machine_check_ue_irq_work(struct irq_work *work);
>  void machine_check_ue_event(struct machine_check_event *evt);
>  static void machine_process_ue_event(struct work_struct *work);
>  
> @@ -40,6 +41,10 @@ static struct irq_work mce_event_process_work = {
>          .func = machine_check_process_queued_event,
>  };
>  
> +static struct irq_work mce_ue_event_irq_work = {
> +	.func = machine_check_ue_irq_work,
> +};
> +
>  DECLARE_WORK(mce_ue_event_work, machine_process_ue_event);
>  
>  static void mce_set_error_info(struct machine_check_event *mce,
> @@ -199,6 +204,10 @@ void release_mce_event(void)
>  	get_mce_event(NULL, true);
>  }
>  
> +static void machine_check_ue_irq_work(struct irq_work *work)
> +{
> +	schedule_work(&mce_ue_event_work);
> +}
>  
>  /*
>   * Queue up the MCE event which then can be handled later.
> @@ -216,7 +225,7 @@ void machine_check_ue_event(struct machine_check_event *evt)
>  	memcpy(this_cpu_ptr(&mce_ue_event_queue[index]), evt, sizeof(*evt));
>  
>  	/* Queue work to process this event later. */
> -	schedule_work(&mce_ue_event_work);
> +	irq_work_queue(&mce_ue_event_irq_work);
>  }
>  
>  /*
> 

