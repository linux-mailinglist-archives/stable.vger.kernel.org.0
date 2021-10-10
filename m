Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5D9427F3F
	for <lists+stable@lfdr.de>; Sun, 10 Oct 2021 07:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhJJFda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Oct 2021 01:33:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38936 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230180AbhJJFda (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Oct 2021 01:33:30 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19A5BiEC025590;
        Sun, 10 Oct 2021 01:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=shUZ6uqlQTOHed2KAnYjTi0w/xXr6hUSlmrC1GmJuNI=;
 b=qavXZzNrbaNTpa1IcpTgPSXomJ7rEtgtIZmWFHX2upg0lG9PX9Ou4Xt56crxT+8WJJor
 Aw9WCDoO3exGtXBTHUHb0h4fshk44sEhj2HrcFY9xwzhL/gsmyTsEQGx5sJARyz7lAIx
 P8fMwrqughz5QRMaIbgVaBYhPNuQNRw/aBNJ+ERSlxUEQkUQ8sSVJkxwtj6DPgZKyG44
 ObzcC9L92eIEz+cMqrsKYifpf5eS7lr7mGXbjhzpwG3PkpDOh0CTr22E6z8kzbfvrjA0
 KsLF2jhFsgg+E5+aGyMKm5okqjUYTqjeQYCj+8KB2AcWlXvVAqNZLgH4s8sNFOsPeCAz EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bkstd85tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Oct 2021 01:29:26 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19A5TQ0r011505;
        Sun, 10 Oct 2021 01:29:26 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bkstd85t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Oct 2021 01:29:26 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19A5R9AN006970;
        Sun, 10 Oct 2021 05:29:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2q8w0e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 10 Oct 2021 05:29:24 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19A5TLnO62587264
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Oct 2021 05:29:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB09EA4054;
        Sun, 10 Oct 2021 05:29:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A453FA405C;
        Sun, 10 Oct 2021 05:29:20 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.54.246])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 10 Oct 2021 05:29:20 +0000 (GMT)
Date:   Sun, 10 Oct 2021 08:29:18 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Nadav Amit <namit@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: provide unmasked address on page-fault
Message-ID: <YWJ6Lv4QpJ3Kzynt@linux.ibm.com>
References: <20211007235055.469587-1-namit@vmware.com>
 <d5a244e9-a04e-8794-e55f-380db5e8c6c4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5a244e9-a04e-8794-e55f-380db5e8c6c4@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K_g-r_8Z10k5Tl0NqMdiPO_rmmbBoPg2
X-Proofpoint-GUID: tO4xLlIrcooGRdes9d51jzYTPheidXTO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-10_01,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1011
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=673 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110100034
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 10:05:36AM +0200, David Hildenbrand wrote:
> On 08.10.21 01:50, Nadav Amit wrote:
> > From: Nadav Amit <namit@vmware.com>
> > 
> > Userfaultfd is supposed to provide the full address (i.e., unmasked) of
> > the faulting access back to userspace. However, that is not the case for
> > quite some time.
> > 
> > Even running "userfaultfd_demo" from the userfaultfd man page provides
> > the wrong output (and contradicts the man page). Notice that
> > "UFFD_EVENT_PAGEFAULT event" shows the masked address.
> > 
> > 	Address returned by mmap() = 0x7fc5e30b3000
> > 
> > 	fault_handler_thread():
> > 	    poll() returns: nready = 1; POLLIN = 1; POLLERR = 0
> > 	    UFFD_EVENT_PAGEFAULT event: flags = 0; address = 7fc5e30b3000
> > 		(uffdio_copy.copy returned 4096)
> > 	Read address 0x7fc5e30b300f in main(): A
> > 	Read address 0x7fc5e30b340f in main(): A
> > 	Read address 0x7fc5e30b380f in main(): A
> > 	Read address 0x7fc5e30b3c0f in main(): A
> > 
> > Add a new "real_address" field to vmf to hold the unmasked address. It
> > is possible to keep the unmasked address in the existing address field
> > (and mask whenever necessary) instead, but this is likely to cause
> > backporting problems of this patch.
> 
> Can we be sure that no existing users will rely on this behavior that has
> been the case since end of 2016 IIRC, one year after UFFD was upstreamed? I
> do wonder what the official ABI nowadays is, because man pages aren't
> necessarily the source of truth.
> 
> I checked QEMU (postcopy live migration), and I think it should be fine with
> this change.

CRIU is Ok with this change, we anyway mask the address.
 
-- 
Sincerely yours,
Mike.
