Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FB12CD528
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 13:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbgLCMGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 07:06:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57464 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgLCMGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 07:06:38 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Bx1Vt105799;
        Thu, 3 Dec 2020 12:03:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mEpRFiNKnG2ABwP47dDamNoZNQLncqQeYcI+mwUMkYg=;
 b=Um+MccciO4d31mxMT4fatxqTR3rCsXR5iWDBmHq5vO26nlvGouVUOfIkDbeH2vRCJK5i
 di9X36AWpz7D2Ca6rs4J4svpzcUMUoMV4lPyv2zTcEHc0FMtp/jfPSlTGoSRnuBFtilT
 v/dS2/v0FIiSMIaRBbwuK2c5+gUhwkgOlTtA4QH9qbKdJ2gSWCmGgQs32ZhUVAJ3FHjA
 PKngfEhD+ThcmYPHxX+V3fxim7hfk2Yu0grgh0Vesi538joh9ssyAsIK0CO1u/e1qVeT
 ek9N6rVTQd7JjeUlNe0niDgIv0MtF69hh/cuOf0M79WRTAuaVIXNWgTVos2W/lTFlAxh Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egkwey2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 12:03:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3BuN3E089683;
        Thu, 3 Dec 2020 12:03:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3540aw0jm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 12:03:24 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3C3KcZ018060;
        Thu, 3 Dec 2020 12:03:20 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 04:03:19 -0800
Date:   Thu, 3 Dec 2020 15:03:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Thomas Lamprecht <t.lamprecht@proxmox.com>
Cc:     James.Bottomley@suse.de,
        jayamohank@HDRedirect-LB5-1afb6e2973825a56.elb.us-east-1.amazonaws.com,
        jejb@linux.ibm.com, jitendra.bhivare@broadcom.com,
        kernel-janitors@vger.kernel.org, ketan.mukadam@broadcom.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, subbu.seetharaman@broadcom.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: be2iscsi: Fix a theoretical leak in
 beiscsi_create_eqs()
Message-ID: <20201203120308.GM2789@kadam>
References: <20200928091300.GD377727@mwanda>
 <54f36c62-10bf-8736-39ce-27ece097d9de@proxmox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54f36c62-10bf-8736-39ce-27ece097d9de@proxmox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030074
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020 at 11:10:09AM +0100, Thomas Lamprecht wrote:
> > The be_fill_queue() function can only fail when "eq_vaddress" is NULL
> > and since it's non-NULL here that means the function call can't fail.
> > But imagine if it could, then in that situation we would want to store
> > the "paddr" so that dma memory can be released.
> > 
> > Fixes: bfead3b2cb46 ("[SCSI] be2iscsi: Adding msix and mcc_rings V3")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> This came in here through the stable 5.4 tree with v5.4.74, and we have some
> users of ours report that it results in kernel oopses and delayed boot on their
> HP DL 380 Gen 9 (and other Gen 9, FWICT) servers:
> 

Thanks for the report Thomas.  I see the bug in my patch:

drivers/scsi/be2iscsi/be_main.c
  3008                  eq_for_mcc = 1;
  3009          else
  3010                  eq_for_mcc = 0;
  3011          for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
  3012                  eq = &phwi_context->be_eq[i].q;
  3013                  mem = &eq->dma_mem;
  3014                  phwi_context->be_eq[i].phba = phba;
  3015                  eq_vaddress = dma_alloc_coherent(&phba->pcidev->dev,
  3016                                                     num_eq_pages * PAGE_SIZE,
  3017                                                     &paddr, GFP_KERNEL);
  3018                  if (!eq_vaddress) {
  3019                          ret = -ENOMEM;
  3020                          goto create_eq_error;
  3021                  }
  3022  
  3023                  mem->dma = paddr;
                        ^^^^^^^^^^^^^^^^
I moved this assignment ahead of the call to be_fill_queue().

  3024                  mem->va = eq_vaddress;
  3025                  ret = be_fill_queue(eq, phba->params.num_eq_entries,
  3026                                      sizeof(struct be_eq_entry), eq_vaddress);
  3027                  if (ret) {
  3028                          beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
  3029                                      "BM_%d : be_fill_queue Failed for EQ\n");
  3030                          goto create_eq_error;
  3031                  }


drivers/scsi/be2iscsi/be_main.c
  2978  static int be_fill_queue(struct be_queue_info *q,
  2979                  u16 len, u16 entry_size, void *vaddress)
  2980  {
  2981          struct be_dma_mem *mem = &q->dma_mem;
  2982  
  2983          memset(q, 0, sizeof(*q));
                ^^^^^^^^^^^^^^^^^^^^^^^
But the first thing that it does is it overwrites it with zeros.

  2984          q->len = len;
  2985          q->entry_size = entry_size;
  2986          mem->size = len * entry_size;
  2987          mem->va = vaddress;

It also overwrites the "mem->va = eq_vaddress;" assignment as well, but
but it sets that back again here...

  2988          if (!mem->va)
  2989                  return -ENOMEM;
  2990          memset(mem->va, 0, mem->size);
  2991          return 0;
  2992  }

I will just revert my patch.  This code is messy but it works so far as
I can see.

regards,
dan carpenter
