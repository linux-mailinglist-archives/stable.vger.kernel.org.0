Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60EA076ED6
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 18:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfGZQU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 12:20:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48708 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728715AbfGZQU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 12:20:56 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6QG6ZLD096817
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 12:20:55 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2u04rh0n6k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 12:20:55 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 26 Jul 2019 17:20:53 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 26 Jul 2019 17:20:48 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6QGKlGD34930820
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jul 2019 16:20:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A7744C04A;
        Fri, 26 Jul 2019 16:20:47 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBE964C040;
        Fri, 26 Jul 2019 16:20:46 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.110])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 26 Jul 2019 16:20:46 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92)
        (envelope-from <bblock@linux.ibm.com>)
        id 1hr2xa-0001Ek-Lx; Fri, 26 Jul 2019 18:20:46 +0200
Date:   Fri, 26 Jul 2019 18:20:46 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 0/2] block/scsi/dm-rq: fix leak of request private
 data in dm-mpath
References: <20190720030637.14447-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190720030637.14447-1-ming.lei@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-TM-AS-GCONF: 00
x-cbid: 19072616-0016-0000-0000-00000296814D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072616-0017-0000-0000-000032F482E9
Message-Id: <20190726162046.GA7523@t480-pf1aa2c2>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260195
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Ming Lei,

On Sat, Jul 20, 2019 at 11:06:35AM +0800, Ming Lei wrote:
> Hi,
> 
> When one request is dispatched to LLD via dm-rq, if the result is
> BLK_STS_*RESOURCE, dm-rq will free the request. However, LLD may allocate
> private data for this request, so this way will cause memory leak.

I am confused about this. Probably because I am not up-to-date with
all of blk-mq. But if you free the LLD private data before the request
is finished, what is the LLD doing if the request finishes afterwards?
Would that not be an automatic use-after-free?

> 
> Add .cleanup_rq() callback and implement it in SCSI for fixing the issue,
> since SCSI is the only driver which allocates private requst data in
> .queue_rq() path.
> 
> Another use case of this callback is to free the request and re-submit
> bios during cpu hotplug when the hctx is dead, see the following link:
> 
> https://lore.kernel.org/linux-block/f122e8f2-5ede-2d83-9ca0-bc713ce66d01@huawei.com/T/#t
> 
> V2:
> 	- run .cleanup_rq() in blk_mq_free_request(), as suggested by Mike 

-- 
With Best Regards, Benjamin Block      /      Linux on IBM Z Kernel Development
IBM Systems & Technology Group   /  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Matthias Hartmann       /      Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294

