Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBC33CC40B
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 17:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhGQPcY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sat, 17 Jul 2021 11:32:24 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:31512 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234255AbhGQPcX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Jul 2021 11:32:23 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4GRsTx3TnMzB6G4;
        Sat, 17 Jul 2021 17:29:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CsnSEz9Ns0sb; Sat, 17 Jul 2021 17:29:25 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4GRsTx2MlBzB6FJ;
        Sat, 17 Jul 2021 17:29:25 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id C1C925EF; Sat, 17 Jul 2021 17:34:35 +0200 (CEST)
Received: from 37-171-38-5.coucou-networks.fr
 (37-171-38-5.coucou-networks.fr [37.171.38.5]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Sat, 17 Jul 2021 17:34:35 +0200
Date:   Sat, 17 Jul 2021 17:34:35 +0200
Message-ID: <20210717173435.Horde.Yjk9m3mjnYfLI-Xv6-IIdg8@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, brking@linux.ibm.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH] ibmvfc: fix command state accounting and stale response
 detection
In-Reply-To: <20210716205220.1101150-1-tyreld@linux.ibm.com>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tyrel Datwyler <tyreld@linux.ibm.com> a écrit :

> Prior to commit 1f4a4a19508d ("scsi: ibmvfc: Complete commands outside
> the host/queue lock") responses to commands were completed sequentially
> with the host lock held such that a command had a basic binary state of
> active or free. It was therefore a simple affair of ensuring the
> assocaiated ibmvfc_event to a VIOS response was valid by testing that it
> was not already free. The lock relexation work to complete commands
> outside the lock inadverdently made it a trinary command state such that
> a command is either in flight, received and being completed, or
> completed and now free. This breaks the stale command detection logic as
> a command may be still marked active and been placed on the delayed
> completion list when a second stale response for the same command
> arrives. This can lead to double completions and list corruption. This
> issue was exposed by a recent VIOS regression were a missing memory
> barrier could occasionally result in the ibmvfc client receiveing a
> duplicate response for the same command.
>
> Fix the issue by introducing the atomic ibmvfc_event.active to track the
> trinary state of a command. The state is explicitly set to 1 when a
> command is successfully sent. The CRQ response handlers use
> atomic_dec_if_positive() to test for stale responses and correctly
> transition to the completion state when a active command is received.
> Finally, atomic_dec_and_test() is used to sanity check transistions
> when commands are freed as a result of a completion, or moved to the
> purge list as a result of error handling or adapter reset.
>
> Cc: stable@vger.kernel.org
> Fixes: 1f4a4a19508d ("scsi: ibmvfc: Complete commands outside the  
> host/queue lock")
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 19 +++++++++++++++++--
>  drivers/scsi/ibmvscsi/ibmvfc.h |  1 +
>  2 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index bee1bec49c09..935b01ee44b7 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -807,6 +807,13 @@ static int ibmvfc_init_event_pool(struct  
> ibmvfc_host *vhost,
>  	for (i = 0; i < size; ++i) {
>  		struct ibmvfc_event *evt = &pool->events[i];
>
> +		/*
> +		 * evt->active states
> +		 *  1 = in flight
> +		 *  0 = being completed
> +		 * -1 = free/freed
> +		 */
> +		atomic_set(&evt->active, -1);
>  		atomic_set(&evt->free, 1);
>  		evt->crq.valid = 0x80;
>  		evt->crq.ioba = cpu_to_be64(pool->iu_token + (sizeof(*evt->xfer_iu) * i));
> @@ -1017,6 +1024,7 @@ static void ibmvfc_free_event(struct ibmvfc_event *evt)
>
>  	BUG_ON(!ibmvfc_valid_event(pool, evt));
>  	BUG_ON(atomic_inc_return(&evt->free) != 1);
> +	BUG_ON(atomic_dec_and_test(&evt->active));

Avoid new BUG_ONs. See  
https://www.kernel.org/doc/html/latest/process/deprecated.html

>
>  	spin_lock_irqsave(&evt->queue->l_lock, flags);
>  	list_add_tail(&evt->queue_list, &evt->queue->free);
> @@ -1072,6 +1080,12 @@ static void ibmvfc_complete_purge(struct  
> list_head *purge_list)
>   **/
>  static void ibmvfc_fail_request(struct ibmvfc_event *evt, int error_code)
>  {
> +	/*
> +	 * Anything we are failing should still be active. Otherwise, it
> +	 * implies we already got a response for the command and are doing
> +	 * something bad like double completing it.
> +	 */
> +	BUG_ON(!atomic_dec_and_test(&evt->active));

Same


