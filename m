Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CC82578E4
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 14:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHaMCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 08:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgHaMCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 08:02:35 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BFFC061755
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 05:02:35 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l191so480263pgd.5
        for <stable@vger.kernel.org>; Mon, 31 Aug 2020 05:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a08AENI2DFUJOZiGvCRTg/GXwM7bPYe8BJ+rCJWtnl4=;
        b=YOKtzczKXPTHUogmgXL30H3d8zUTN7PA3qH1/VNy/iIqfSR5XtUZyM07m1Joxg985J
         VrNmTjEogNeVB1HiyJhuBpqLFF53UzSzSNwyuyuXB7jAinMQyKMdsBL6X0pdjsjdobc+
         ewgM7hdO7Id5BLI7CG75ztKZ2HVgBH0LYm9IO7z85XLDzDN9IG4X0vJHZWBUNK1h4IAR
         BBgh52YyXAHcZPc6rfS1u5wBtniJAjmpQulu6mHEtyeB73B3roqTuMs568SyhmBcrbKZ
         7pqQSzhoMrZNBTGewkIv9tLosYbAgL8Jgnm/8x/NzaRG291HqSY4Bup7OP/P7r0cPfWh
         36jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a08AENI2DFUJOZiGvCRTg/GXwM7bPYe8BJ+rCJWtnl4=;
        b=PBB3Gplvr6pQKXps+/PdFu8UOKHO5J/wE3VZcFMO7E8MQ4Y6mvvoYF5rm5aeIcHGu9
         CtRJe2FPEiH6egB6xozT8DCzk5SpKyya3GE7FDQJ+o6iFezPVGAM2szCxnfVpAy+fWIy
         v12qdNHUHdAasEDGAWOPKDd1G2UvuLAL4oy9AM96MjBPUhh9u/qJyzYWRaNWw37aTwNn
         6WqOmNwNBlmIiS73jEpXEGSceuOfjEl/vJmf9o2o+lC5dw2HekqxwHl24W7Zu24MYWqt
         +ZvwTjCbkqm/rEcJ/Oc7fHVkLY3CdMEENCaIaDgs/dPV1laKWvDjq/wpuqObwc+I+X41
         dMhw==
X-Gm-Message-State: AOAM532AEoLYwXQx3Cfk3q7n7rhSm8t+NyXT4qpBDmLTt7zNCj8tl9tL
        L5iIKnGGsLBpufWtPqjIJEtwKBmoRJ4ewA==
X-Google-Smtp-Source: ABdhPJyVcgDinpA+btaIb9dzZaKvDLDOFy3R9RZel/AFBg1k8y/YJWPQcqpdSx2jFCouDYNOHU0pag==
X-Received: by 2002:a65:66c4:: with SMTP id c4mr1014869pgw.442.1598875354300;
        Mon, 31 Aug 2020 05:02:34 -0700 (PDT)
Received: from houpudeMacBook-Pro.local ([240e:b1:e401:1::d])
        by smtp.gmail.com with ESMTPSA id q201sm7756648pfq.80.2020.08.31.05.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 05:02:33 -0700 (PDT)
Subject: Re: [PATCH] iscsi-target: fix hang in iscsit_access_np() when getting
 tpg->np_login_sem
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, michael.christie@oracle.com
Cc:     stable@vger.kernel.org
References: <20200729130343.24976-1-houpu@bytedance.com>
From:   Hou Pu <houpu@bytedance.com>
Message-ID: <01a58989-8777-3967-ebcd-f8c080e18a3c@bytedance.com>
Date:   Mon, 31 Aug 2020 20:02:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200729130343.24976-1-houpu@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Could anyone help review this patch? It is an important
fix.

Login thread could hang __forever__ and only reboot could
solve this. This happened several times in our production
environment.

np->np_login_timer is shared by all TPGs of a portal.
should be used carefully. If a connection to iqn-TPG A start
login timer, It should not stop by another connection
to iqn-TPG B.

np->np_login_timer protect potential hangs in
__iscsi_target_login_thread.
should be used locally in this function. It should really
not be used in iscsi_target_login_sess_out from workqueue
context.

Thanks,
Hou

On 2020/7/29 9:03 PM, Hou Pu wrote:
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
>     PDU exchange in the login thread and before the negotiation is
>     finished, at this time the network link is down. In a production
>     environment, this could happen. I could emulated it by bring
>     the network card down in the initiator node by ifconfig eth0 down.
>     (Now A could never finish this login. And tpg->np_login_sem is
>     hold by it).
> 2. Initiator B try to login iqn2-tpg1 on port 3260. After finishing
>     PDU exchange in the login thread. The target expect to process
>     remaining login PDUs in workqueue context.
> 3. Initiator A' try to re-login to iqn1-tpg1 on port 3260 from
>     a new socket. It will wait for tpg->np_login_sem with
>     np->np_login_timer loaded to wait for at most 15 second.
>     (Because the lock is held by A. A never gets a change to
>     release tpg->np_login_sem. so A' should finally get timeout).
> 4. Before A' got timeout. Initiator B gets negotiation failed and
>     calls iscsi_target_login_drop()->iscsi_target_login_sess_out().
>     The np->np_login_timer is canceled. And initiator A' will hang
>     there forever. Because A' is now in the login thread. All other
>     login requests could not be serviced.
> 
> Fix this by moving iscsi_stop_login_thread_timer() out of
> iscsi_target_login_sess_out(). Also remove iscsi_np parameter
> from iscsi_target_login_sess_out().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hou Pu <houpu@bytedance.com>
> ---
>   drivers/target/iscsi/iscsi_target_login.c | 6 +++---
>   drivers/target/iscsi/iscsi_target_login.h | 3 +--
>   drivers/target/iscsi/iscsi_target_nego.c  | 3 +--
>   3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index 85748e338858..893d1b406c29 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1149,7 +1149,7 @@ void iscsit_free_conn(struct iscsi_conn *conn)
>   }
>   
>   void iscsi_target_login_sess_out(struct iscsi_conn *conn,
> -		struct iscsi_np *np, bool zero_tsih, bool new_sess)
> +				 bool zero_tsih, bool new_sess)
>   {
>   	if (!new_sess)
>   		goto old_sess_out;
> @@ -1167,7 +1167,6 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
>   	conn->sess = NULL;
>   
>   old_sess_out:
> -	iscsi_stop_login_thread_timer(np);
>   	/*
>   	 * If login negotiation fails check if the Time2Retain timer
>   	 * needs to be restarted.
> @@ -1407,8 +1406,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
>   new_sess_out:
>   	new_sess = true;
>   old_sess_out:
> +	iscsi_stop_login_thread_timer(np);
>   	tpg_np = conn->tpg_np;
> -	iscsi_target_login_sess_out(conn, np, zero_tsih, new_sess);
> +	iscsi_target_login_sess_out(conn, zero_tsih, new_sess);
>   	new_sess = false;
>   
>   	if (tpg) {
> diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
> index 3b8e3639ff5d..fc95e6150253 100644
> --- a/drivers/target/iscsi/iscsi_target_login.h
> +++ b/drivers/target/iscsi/iscsi_target_login.h
> @@ -22,8 +22,7 @@ extern int iscsit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
>   extern void iscsit_free_conn(struct iscsi_conn *);
>   extern int iscsit_start_kthreads(struct iscsi_conn *);
>   extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
> -extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
> -				bool, bool);
> +extern void iscsi_target_login_sess_out(struct iscsi_conn *, bool, bool);
>   extern int iscsi_target_login_thread(void *);
>   extern void iscsi_handle_login_thread_timeout(struct timer_list *t);
>   
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index 685d771b51d4..e32d93b92742 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -535,12 +535,11 @@ static bool iscsi_target_sk_check_and_clear(struct iscsi_conn *conn, unsigned in
>   
>   static void iscsi_target_login_drop(struct iscsi_conn *conn, struct iscsi_login *login)
>   {
> -	struct iscsi_np *np = login->np;
>   	bool zero_tsih = login->zero_tsih;
>   
>   	iscsi_remove_failed_auth_entry(conn);
>   	iscsi_target_nego_release(conn);
> -	iscsi_target_login_sess_out(conn, np, zero_tsih, true);
> +	iscsi_target_login_sess_out(conn, zero_tsih, true);
>   }
>   
>   struct conn_timeout {
> 
