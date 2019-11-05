Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CE9F04BD
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 19:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390520AbfKESKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 13:10:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390519AbfKESKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Nov 2019 13:10:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5I4E5j170533;
        Tue, 5 Nov 2019 18:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=YBEFdTVTSHrqjw+pLLGswOmbh4LUrg6YKBS7yuzwn6g=;
 b=VeJ4Lff0lAZ1h3lwpsdslPfgzJJps8HF5mRQ5TX0mUgQtypohvOl/1hh/CKadgN4za/h
 S/SYH5WfCnzx9eRfyZtbzVqfTuxv3ylyMJapQcLhb6Ewcb65tMv6ywJ1agzNwgQ0wODn
 LsnBkw6Q68d690GnIw7Ho+pQ+9C4nGSxIrTg1Sp2n3CNs9tvZeGE4KKItzNCelI36neH
 HAZSrya0bMDP9zI444aBsxujDS0oCFsZqEBVHPw9Vn0zzHlBpQ7tsilGlM/F5EQ9JWyB
 nxjgJdQIv/XRbc7zgy4cvRHt/ouYMmVS/7dzhyUSxhVnsBl38J2H6J4M93BLWchgh1o+ eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w12er88vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 18:10:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5I9OiT002618;
        Tue, 5 Nov 2019 18:10:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w333vnn4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 18:10:39 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA5I8J3d025043;
        Tue, 5 Nov 2019 18:08:20 GMT
Received: from [10.154.173.7] (/10.154.173.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 10:08:18 -0800
Subject: Re: [PATCH 5.3 143/163] io_uring: ensure we clear io_kiocb->result
 before each issue
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <20191104212140.046021995@linuxfoundation.org>
 <20191104212150.683214210@linuxfoundation.org>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <350f59fb-4413-c95a-aade-300b356009d6@oracle.com>
Date:   Tue, 5 Nov 2019 10:08:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104212150.683214210@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Antivirus: Avast (VPS 191105-0, 11/04/2019), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050152
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/4/2019 1:45 PM, Greg Kroah-Hartman wrote:
> From: Jens Axboe <axboe@kernel.dk>
>
> commit 6873e0bd6a9cb14ecfadd89d9ed9698ff1761902 upstream.
>
> We use io_kiocb->result == -EAGAIN as a way to know if we need to
> re-submit a polled request, as -EAGAIN reporting happens out-of-line
> for IO submission failures. This field is cleared when we originally
> allocate the request, but it isn't reset when we retry the submission
> from async context. This can cause issues where we think something
> needs a re-issue, but we're really just reading stale data.
>
> Reset ->result whenever we re-prep a request for polled submission.
>
> Cc: stable@vger.kernel.org
> Fixes: 9e645e1105ca ("io_uring: add support for sqe links")
> Reported-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>   fs/io_uring.c |    1 +
>   1 file changed, 1 insertion(+)
>
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1078,6 +1078,7 @@ static int io_prep_rw(struct io_kiocb *r
>   
>   		kiocb->ki_flags |= IOCB_HIPRI;
>   		kiocb->ki_complete = io_complete_rw_iopoll;
> +		req->result = 0;
>   	} else {
>   		if (kiocb->ki_flags & IOCB_HIPRI)
>   			return -EINVAL;
>
>
Reviewd-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
