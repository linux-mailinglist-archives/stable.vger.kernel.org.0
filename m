Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2976BD5B3F
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 08:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbfJNGS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 02:18:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729982AbfJNGS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 02:18:57 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9E671AJ016447
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 02:18:56 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vmc7na0qx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 02:18:56 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Mon, 14 Oct 2019 07:18:53 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 14 Oct 2019 07:18:49 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9E6Im7a40567074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Oct 2019 06:18:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 039EC4CCB7;
        Mon, 14 Oct 2019 06:18:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D2404CC9B;
        Mon, 14 Oct 2019 06:18:47 +0000 (GMT)
Received: from osiris (unknown [9.152.212.85])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 14 Oct 2019 06:18:47 +0000 (GMT)
Date:   Mon, 14 Oct 2019 08:18:46 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Harald Freudenberger <freude@linux.ibm.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 4/4] s390/zcrypt: fix memleak at release
References: <20191010131333.23635-1-johan@kernel.org>
 <20191010131333.23635-5-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010131333.23635-5-johan@kernel.org>
X-TM-AS-GCONF: 00
x-cbid: 19101406-0008-0000-0000-00000321CE1C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101406-0009-0000-0000-00004A40DEC6
Message-Id: <20191014061846.GA6834@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=5 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=905 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910140060
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 10, 2019 at 03:13:33PM +0200, Johan Hovold wrote:
> If a process is interrupted while accessing the crypto device and the
> global ap_perms_mutex is contented, release() could return early and
> fail to free related resources.
> 
> Fixes: 00fab2350e6b ("s390/zcrypt: multiple zcrypt device nodes support")
> Cc: stable <stable@vger.kernel.org>     # 4.19
> Cc: Harald Freudenberger <freude@linux.ibm.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/s390/crypto/zcrypt_api.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied, thanks!

