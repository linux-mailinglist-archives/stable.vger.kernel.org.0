Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73ACD1535B1
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 17:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBEQ40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 11:56:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727054AbgBEQ40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 11:56:26 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 015GnpZJ131463;
        Wed, 5 Feb 2020 11:55:50 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xyhmgwxt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Feb 2020 11:55:50 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 015Gp2Ri135129;
        Wed, 5 Feb 2020 11:55:50 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xyhmgwxsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Feb 2020 11:55:49 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 015GtnRg024988;
        Wed, 5 Feb 2020 16:55:49 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 2xykc9e4k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Feb 2020 16:55:49 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 015GtmHr11338068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Feb 2020 16:55:48 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E96BC6063;
        Wed,  5 Feb 2020 16:55:48 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34DA6C605A;
        Wed,  5 Feb 2020 16:55:48 +0000 (GMT)
Received: from localhost (unknown [9.41.100.106])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  5 Feb 2020 16:55:48 +0000 (GMT)
From:   Nathan Lynch <nathanl@linux.ibm.com>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     David Hildenbrand <david@redhat.com>,
        Michal Suchanek <msuchanek@suse.cz>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Leonardo Bras <leonardo@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michal Suchanek <msuchanek@suse.de>,
        Allison Randal <allison@lohutok.net>,
        linuxppc-dev@lists.ozlabs.org, Libor Pechacek <lpechacek@suse.cz>
Subject: Re: [PATCH v2] powerpc: drmem: avoid NULL pointer dereference when drmem is unavailable
In-Reply-To: <20200131132829.10281-1-msuchanek@suse.de>
References: <20200131132829.10281-1-msuchanek@suse.de>
Date:   Wed, 05 Feb 2020 10:55:47 -0600
Message-ID: <87r1z92cto.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-05_05:2020-02-04,2020-02-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=1
 spamscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 clxscore=1011 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002050128
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Michal Suchanek <msuchanek@suse.de> writes:
> From: Libor Pechacek <lpechacek@suse.cz>
>
> In guests without hotplugagble memory drmem structure is only zero
> initialized. Trying to manipulate DLPAR parameters results in a crash.
>

[...]

>
> Fixes: 6c6ea53725b3 ("powerpc/mm: Separate ibm, dynamic-memory data from DT format")
> Cc: Michal Suchanek <msuchanek@suse.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
> v2: rename last_lmb -> limit, clarify error condition.

Acked-by: Nathan Lynch <nathanl@linux.ibm.com>

Thanks!
