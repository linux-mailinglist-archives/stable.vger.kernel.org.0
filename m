Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F05611413F
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 14:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbfLENLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 08:11:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729146AbfLENLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 08:11:39 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB5D7iMO023250
        for <stable@vger.kernel.org>; Thu, 5 Dec 2019 08:11:38 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wpx3dbbyj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 08:11:37 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <rppt@linux.ibm.com>;
        Thu, 5 Dec 2019 13:11:35 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 5 Dec 2019 13:11:32 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB5DBVaS43057616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Dec 2019 13:11:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2162CA405F;
        Thu,  5 Dec 2019 13:11:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62861A405C;
        Thu,  5 Dec 2019 13:11:30 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.148.8.135])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  5 Dec 2019 13:11:30 +0000 (GMT)
Date:   Thu, 5 Dec 2019 15:11:28 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wentao Wang <witallwang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 200/321] mm/page_alloc.c: deduplicate
 __memblock_free_early() and memblock_free()
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223437.527630884@linuxfoundation.org>
 <20191205115043.GA25107@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205115043.GA25107@duo.ucw.cz>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-TM-AS-GCONF: 00
x-cbid: 19120513-0020-0000-0000-0000039452F3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120513-0021-0000-0000-000021EB8058
Message-Id: <20191205131128.GA25566@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-05_03:2019-12-04,2019-12-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=2
 mlxlogscore=796 mlxscore=0 impostorscore=0 spamscore=0 phishscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912050111
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 12:50:43PM +0100, Pavel Machek wrote:
> Hi!
> On Tue 2019-12-03 23:34:26, Greg Kroah-Hartman wrote:
> > From: Wentao Wang <witallwang@gmail.com>
> > 
> > [ Upstream commit d31cfe7bff9109476da92c245b56083e9b48d60a ]
> 
> 
> > @@ -1537,12 +1537,7 @@ void * __init memblock_virt_alloc_try_nid(
> >   */
> >  void __init __memblock_free_early(phys_addr_t base, phys_addr_t size)
> >  {
> > -	phys_addr_t end = base + size - 1;
> > -
> > -	memblock_dbg("%s: [%pa-%pa] %pF\n",
> > -		     __func__, &base, &end, (void *)_RET_IP_);
> > -	kmemleak_free_part_phys(base, size);
> > -	memblock_remove_range(&memblock.reserved, base, size);
> > +	memblock_free(base, size);
> >  }
> 
> This makes the memblock_dbg() less useful: _RET_IP_ will now be one of
> __memblock_free_early(), not of the original caller.
> 
> That may be okay, but I guess it should be mentioned in changelog, and
> I don't really see why it is queued for -stable.

Not sure why this one was picked for -stable, but in upstream there is a
followup commit 4d72868c8f7c ("memblock: replace usage of
__memblock_free_early() with memblock_free()") that completely eliminates
__memblock_free_early(). IMHO it would make sense to either to take both or
to drop both.
 
> Best regards,
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Sincerely yours,
Mike.

