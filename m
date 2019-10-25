Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADD6E408B
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 02:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfJYAW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 20:22:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbfJYAW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 20:22:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P0JNmv079298;
        Fri, 25 Oct 2019 00:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8XdHHh76rUW1m1ray72wnOb07G1aA+EKzlau7o1OblI=;
 b=nN2OwrheiG4Pu28stA1TphiwBnYwGlP+EDN3D0oF41+u8fgdbduj+8k4wbfAC5YMJYhs
 HtBWRXtL/BwvAiLAoT8MqaNY+IC5M/97X4heR91j1tIvF+DtqBRIUpWav6FpgiKbhSCm
 VD4Vlghas+4Qyy80FNKOGMMjiX8YfbL8TPAlmNpfIE2Q6pH0moCOJ8Cn0cc7ZG0HnH7t
 PXZ3IRw4S2w2nrkR49W7RA6rqYgfRd3lBurAHzpO6PAJB6Qm7KeQ5XakedktWgcqkj2A
 5O4Db2jFzVC1xBXhOPwZalWr5pdlgWLZo4NqIRtgcMnesKHhpCTljLVl0Hk2FfX1+0eo sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqteq6y0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 00:22:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P0J4WZ010368;
        Fri, 25 Oct 2019 00:22:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2vtsk67c4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 00:22:42 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9P0Mdcl014923;
        Fri, 25 Oct 2019 00:22:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 17:22:38 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Varun Prakash <varun@chelsio.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] target/cxgbit: Fix cxgbit_fw4_ack()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191023202150.22173-1-bvanassche@acm.org>
Date:   Thu, 24 Oct 2019 20:22:36 -0400
In-Reply-To: <20191023202150.22173-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 23 Oct 2019 13:21:50 -0700")
Message-ID: <yq1ftjhd67n.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=624
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=723 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250002
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Use the pointer 'p' after having tested that pointer instead of before.

Thanks, Bart! Applied to 5.4/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
