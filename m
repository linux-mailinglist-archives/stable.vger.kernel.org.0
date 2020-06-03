Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E151EC6E4
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 03:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgFCBm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 21:42:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42646 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgFCBm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jun 2020 21:42:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0531gELT117727;
        Wed, 3 Jun 2020 01:42:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ZVSt6fgPdJ/CcpTZx/Rwe/Oczc0sTullCA75JDI9ZCE=;
 b=Jo5KW3r8OhyKp7cM663ARgdXcOFIbRrENHwcZPdUhpqk0eTJDX3Vyh9S88tDZi5mom7b
 PCGLnUZh7a5587Kl56YkR3HH8W0DcWPjD+DZ9zhO0nfug3cdiLKurbR5RiESpT1GfEHx
 7tRkgoUi35QK70r1F2yY/FbuW+iwK3/rigW3U7ahQWkfJDFXyrWDIlQf26ybN6HapxMm
 sxV0B7rwiLI6+hlMOfquvFlBWkapXkFrGc7wx2+zyT9HsI26y+2xdvjO38PdgULUMWaQ
 WyXO5Y9U6HF4/NlHOBwlVxL9E+FtfdeWZ2wpmvbxmVIHnDtEBWff+g/O7qZ9t+Kv/ggG 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31dkruksg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 01:42:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0531dP2I189042;
        Wed, 3 Jun 2020 01:42:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31c12q4340-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 01:42:13 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0531gAKF007867;
        Wed, 3 Jun 2020 01:42:10 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 18:42:10 -0700
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rmx9b9w.fsf@ca-mkp.ca.oracle.com>
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
Date:   Tue, 02 Jun 2020 21:42:06 -0400
In-Reply-To: <20200518183141.66621-1-r.bolshakov@yadro.com> (Roman Bolshakov's
        message of "Mon, 18 May 2020 21:31:42 +0300")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=1 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=1 malwarescore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030010
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Roman,

> The driver performs SCR (state change registration) in all modes
> including pure target mode.

What is the current status of this patch? There was a bunch of going
back and forth wrt. whether this was the correct approach.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
