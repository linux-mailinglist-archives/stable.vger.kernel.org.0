Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300AA27D3B4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 18:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgI2QeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 12:34:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38398 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgI2QeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 12:34:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TGP4m8060382;
        Tue, 29 Sep 2020 16:32:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tzQi1UXipO6sFuqec9C7WzivylNzYOZjztTncXkQNhc=;
 b=wHQmOCuc9zZMiX7i5bfvKwMRZnEmDJaGEZyksOgkxYGPhX4Qun7DuXtrlp8hB5izTar1
 6JifUaFSSRt2tDMRgq2HdrrLGiQeInh//939Dvff162mfqTRR7G3OUT8Rwe8GeVNRw/5
 ioX+FBlak/g7KxO2Ytg2E637NkrKXrGgJWzTI/B3CTBaqltsO0jQEIopLaj1YTFWeN5k
 rL7lBnjHfGAQo2ODg5gA+Lo1BDVp7vWyDhc4GysvVkCQf7qCgJHRr+0rvZOqjLJAPIh9
 lTX0YsS53CNug1GZDWMLgcyQIwnD97ARB2M8W9hXFD78AIth0iJRFlgS6Bwo2fbRi9GG fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9n3vty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 29 Sep 2020 16:32:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08TGOqfp027429;
        Tue, 29 Sep 2020 16:32:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33uv2e51yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 16:32:36 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08TGWZcH005602;
        Tue, 29 Sep 2020 16:32:35 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 09:32:35 -0700
Subject: Re: [PATCH] iscsi: iscsi_tcp: Avoid holding spinlock while calling
 getpeername
To:     Mark Mielke <mark.mielke@gmail.com>, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        Marc Dionne <marc.c.dionne@gmail.com>, stable@vger.kernel.org
References: <20200928043329.606781-1-mark.mielke@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <aec41066-f5d3-c426-11c1-25e9b0a9ed44@oracle.com>
Date:   Tue, 29 Sep 2020 11:32:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200928043329.606781-1-mark.mielke@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290140
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/27/20 11:33 PM, Mark Mielke wrote:
> Kernel may fail to boot or devices may fail to come up when
> initializing iscsi_tcp devices starting with Linux 5.8.
> 
> Marc Dionne identified the cause in RHBZ#1877345.
> 
> Commit a79af8a64d39 ("[SCSI] iscsi_tcp: use iscsi_conn_get_addr_param
> libiscsi function") introduced getpeername() within the session spinlock.
> 
> Commit 1b66d253610c ("bpf: Add get{peer, sock}name attach types for
> sock_addr") introduced BPF_CGROUP_RUN_SA_PROG_LOCK() within getpeername,
> which acquires a mutex and when used from iscsi_tcp devices can now lead
> to "BUG: scheduling while atomic:" and subsequent damage.
> 
> This commit ensures that the spinlock is released before calling
> getpeername() or getsockname(). sock_hold() and sock_put() are
> used to ensure that the socket reference is preserved until after
> the getpeername() or getsockname() complete.
> 
> Reported-by: Marc Dionne <marc.c.dionne@gmail.com>
> Link: https://urldefense.com/v3/__https://bugzilla.redhat.com/show_bug.cgi?id=1877345__;!!GqivPVa7Brio!IykqCqCEtE_EyrhXerYzj_cIlmkenkaAVddyoEOw9T6n4nExSaGFHkn0ZQrLBVSUtxQ_$ 
> Link: https://urldefense.com/v3/__https://lkml.org/lkml/2020/7/28/1085__;!!GqivPVa7Brio!IykqCqCEtE_EyrhXerYzj_cIlmkenkaAVddyoEOw9T6n4nExSaGFHkn0ZQrLBRT9NL69$ 
> Link: https://urldefense.com/v3/__https://lkml.org/lkml/2020/8/31/459__;!!GqivPVa7Brio!IykqCqCEtE_EyrhXerYzj_cIlmkenkaAVddyoEOw9T6n4nExSaGFHkn0ZQrLBfxZYLKs$ 
> Fixes: a79af8a64d39 ("[SCSI] iscsi_tcp: use iscsi_conn_get_addr_param libiscsi function")
> Fixes: 1b66d253610c ("bpf: Add get{peer, sock}name attach types for sock_addr")
> Signed-off-by: Mark Mielke <mark.mielke@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/scsi/iscsi_tcp.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index b5dd1caae5e9..d10efb66cf19 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -736,6 +736,7 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
>  	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
>  	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
>  	struct sockaddr_in6 addr;
> +	struct socket *sock;
>  	int rc;
>  
>  	switch(param) {
> @@ -747,13 +748,17 @@ static int iscsi_sw_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
>  			spin_unlock_bh(&conn->session->frwd_lock);
>  			return -ENOTCONN;
>  		}
> +		sock = tcp_sw_conn->sock;
> +		sock_hold(sock->sk);
> +		spin_unlock_bh(&conn->session->frwd_lock);
> +
>  		if (param == ISCSI_PARAM_LOCAL_PORT)
> -			rc = kernel_getsockname(tcp_sw_conn->sock,
> +			rc = kernel_getsockname(sock,
>  						(struct sockaddr *)&addr);
>  		else
> -			rc = kernel_getpeername(tcp_sw_conn->sock,
> +			rc = kernel_getpeername(sock,
>  						(struct sockaddr *)&addr);
> -		spin_unlock_bh(&conn->session->frwd_lock);
> +		sock_put(sock->sk);
>  		if (rc < 0)
>  			return rc;
>  
> @@ -775,6 +780,7 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>  	struct iscsi_tcp_conn *tcp_conn;
>  	struct iscsi_sw_tcp_conn *tcp_sw_conn;
>  	struct sockaddr_in6 addr;
> +	struct socket *sock;
>  	int rc;
>  
>  	switch (param) {
> @@ -789,16 +795,18 @@ static int iscsi_sw_tcp_host_get_param(struct Scsi_Host *shost,
>  			return -ENOTCONN;
>  		}
>  		tcp_conn = conn->dd_data;
> -
>  		tcp_sw_conn = tcp_conn->dd_data;
> -		if (!tcp_sw_conn->sock) {
> +		sock = tcp_sw_conn->sock;
> +		if (!sock) {
>  			spin_unlock_bh(&session->frwd_lock);
>  			return -ENOTCONN;
>  		}
> +		sock_hold(sock->sk);
> +		spin_unlock_bh(&session->frwd_lock);
>  
> -		rc = kernel_getsockname(tcp_sw_conn->sock,
> +		rc = kernel_getsockname(sock,
>  					(struct sockaddr *)&addr);
> -		spin_unlock_bh(&session->frwd_lock);
> +		sock_put(sock->sk);
>  		if (rc < 0)
>  			return rc;
>  
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
