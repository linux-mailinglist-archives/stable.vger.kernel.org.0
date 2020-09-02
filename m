Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E8525B432
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 21:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgIBTCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 15:02:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58306 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgIBTCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 15:02:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082Is04l177872;
        Wed, 2 Sep 2020 19:02:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+5nXlfRChHWChHNEKZ5ej28tkqI+7By/rL4n8sS49zc=;
 b=K0UAZQWzfNbBKy0dGHalqpyHKN1S8xVXutRXfH7kYASAWwutX5SYH034+7knoxWOSexI
 P8ASnVivGsdSyseMu61+MXsUZ4eR51bh3loxG07OWTdYp7EpQeEaTZE3p/JGU/P6Hat1
 hdvsfuIyLEFf0VByBwSh7x9CKu+TgGE5kYhzJ+f1WgkEMFun307gyEzUGs0KYCjpplA3
 3XCdFAM7UTgAbQbJZmGT3AJJ/6Y6WBIYOG4c18URc1eCkOWp0L+FGu+TfuHDqa349DHk
 x4+iQPK9K4sPDE1LDv9T+xVcakT5528LotvedrYS/v8vBuk18j1N+wEX4a1Cziz0bn6O VA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 339dmn33wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 19:02:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082J1FJT106774;
        Wed, 2 Sep 2020 19:02:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380kqgj44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 19:02:13 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 082J2C5Z019201;
        Wed, 2 Sep 2020 19:02:12 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 12:02:12 -0700
Subject: Re: [PATCH] iscsi-target: fix hang in iscsit_access_np() when getting
 tpg->np_login_sem
To:     Hou Pu <houpu@bytedance.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200729130343.24976-1-houpu@bytedance.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <32079608-6e37-e70b-821e-8519af4e590a@oracle.com>
Date:   Wed, 2 Sep 2020 14:02:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729130343.24976-1-houpu@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=2 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=2
 spamscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020177
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/20 8:03 AM, Hou Pu wrote:
> The iscsi target login thread might stuck in following stack:
> 
> cat /proc/`pidof iscsi_np`/stack
> [<0>] down_interruptible+0x42/0x50
> [<0>] iscsit_access_np+0xe3/0x167
> [<0>] iscsi_target_locate_portal+0x695/0x8ac
> [<0>] __iscsi_target_login_thread+0x855/0xb82
> [<0>] iscsi_target_login_thread+0x2f/0x5a
> [<0>] kthread+0xfa/0x130
> [<0>] ret_from_fork+0x1f/0x30
> 
> This could be reproduced by following steps:
> 1. Initiator A try to login iqn1-tpg1 on port 3260. After finishing
>    PDU exchange in the login thread and before the negotiation is
>    finished, at this time the network link is down. In a production
>    environment, this could happen. I could emulated it by bring
>    the network card down in the initiator node by ifconfig eth0 down.
>    (Now A could never finish this login. And tpg->np_login_sem is
>    hold by it).
> 2. Initiator B try to login iqn2-tpg1 on port 3260. After finishing
>    PDU exchange in the login thread. The target expect to process
>    remaining login PDUs in workqueue context.
> 3. Initiator A' try to re-login to iqn1-tpg1 on port 3260 from
>    a new socket. It will wait for tpg->np_login_sem with
>    np->np_login_timer loaded to wait for at most 15 second.
>    (Because the lock is held by A. A never gets a change to
>    release tpg->np_login_sem. so A' should finally get timeout).
> 4. Before A' got timeout. Initiator B gets negotiation failed and
>    calls iscsi_target_login_drop()->iscsi_target_login_sess_out().
>    The np->np_login_timer is canceled. And initiator A' will hang
>    there forever. Because A' is now in the login thread. All other
>    login requests could not be serviced.
> 
> Fix this by moving iscsi_stop_login_thread_timer() out of
> iscsi_target_login_sess_out(). Also remove iscsi_np parameter
> from iscsi_target_login_sess_out().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hou Pu <houpu@bytedance.com>
> ---
>  drivers/target/iscsi/iscsi_target_login.c | 6 +++---
>  drivers/target/iscsi/iscsi_target_login.h | 3 +--
>  drivers/target/iscsi/iscsi_target_nego.c  | 3 +--
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index 85748e338858..893d1b406c29 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1149,7 +1149,7 @@ void iscsit_free_conn(struct iscsi_conn *conn)
>  }
>  
>  void iscsi_target_login_sess_out(struct iscsi_conn *conn,
> -		struct iscsi_np *np, bool zero_tsih, bool new_sess)
> +				 bool zero_tsih, bool new_sess)
>  {
>  	if (!new_sess)
>  		goto old_sess_out;
> @@ -1167,7 +1167,6 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
>  	conn->sess = NULL;
>  
>  old_sess_out:
> -	iscsi_stop_login_thread_timer(np);
>  	/*
>  	 * If login negotiation fails check if the Time2Retain timer
>  	 * needs to be restarted.
> @@ -1407,8 +1406,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
>  new_sess_out:
>  	new_sess = true;
>  old_sess_out:
> +	iscsi_stop_login_thread_timer(np);
>  	tpg_np = conn->tpg_np;
> -	iscsi_target_login_sess_out(conn, np, zero_tsih, new_sess);
> +	iscsi_target_login_sess_out(conn, zero_tsih, new_sess);
>  	new_sess = false;
>  
>  	if (tpg) {
> diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
> index 3b8e3639ff5d..fc95e6150253 100644
> --- a/drivers/target/iscsi/iscsi_target_login.h
> +++ b/drivers/target/iscsi/iscsi_target_login.h
> @@ -22,8 +22,7 @@ extern int iscsit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
>  extern void iscsit_free_conn(struct iscsi_conn *);
>  extern int iscsit_start_kthreads(struct iscsi_conn *);
>  extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
> -extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
> -				bool, bool);
> +extern void iscsi_target_login_sess_out(struct iscsi_conn *, bool, bool);
>  extern int iscsi_target_login_thread(void *);
>  extern void iscsi_handle_login_thread_timeout(struct timer_list *t);
>  
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index 685d771b51d4..e32d93b92742 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -535,12 +535,11 @@ static bool iscsi_target_sk_check_and_clear(struct iscsi_conn *conn, unsigned in
>  
>  static void iscsi_target_login_drop(struct iscsi_conn *conn, struct iscsi_login *login)
>  {
> -	struct iscsi_np *np = login->np;
>  	bool zero_tsih = login->zero_tsih;
>  
>  	iscsi_remove_failed_auth_entry(conn);
>  	iscsi_target_nego_release(conn);
> -	iscsi_target_login_sess_out(conn, np, zero_tsih, true);
> +	iscsi_target_login_sess_out(conn, zero_tsih, true);
>  }
>  
>  struct conn_timeout {
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
