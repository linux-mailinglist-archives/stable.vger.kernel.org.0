Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B00511F57
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243126AbiD0Qfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 12:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243749AbiD0QfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 12:35:23 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5DC5F8C6
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1651077112; x=1682613112;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=NC8YZo3Ff/awyLU7dIblJRVsiNI3DVtv88vPTENpOs0=;
  b=YZVO0IEzXHvzszwtVtd5xzZ0Wks/l6BHIzJ9q5Xjy5PESHgkr6kfVm9l
   ywCVlDql/T+Rw8VQOWPU/Y/iSL7Yyond7K83kVdzYKA1K8fJxleRDXh1N
   jX/obVGbFH+jsu+Fblp2swmU/Sb+Ip6ZhQDIEXnxaPI0JYaxWsaGhPlrj
   A=;
X-IronPort-AV: E=Sophos;i="5.90,293,1643673600"; 
   d="scan'208";a="1011143953"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 27 Apr 2022 16:31:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com (Postfix) with ESMTPS id 43C4F41B2B
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 16:31:51 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Wed, 27 Apr 2022 16:31:51 +0000
Received: from localhost (10.43.160.125) by EX13d01UWA002.ant.amazon.com
 (10.43.160.74) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 27 Apr
 2022 16:31:50 +0000
Date:   Wed, 27 Apr 2022 09:31:50 -0700
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     <stable@vger.kernel.org>
Subject: Re: [PATCH 4.9-4.19] jbd2: fix use-after-free of transaction_t race
Message-ID: <20220427163150.djuapjmnvtautt5x@u46989501580c5c.ant.amazon.com>
References: <20220426182702.716304-1-samjonas@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220426182702.716304-1-samjonas@amazon.com>
X-Originating-IP: [10.43.160.125]
X-ClientProxiedBy: EX13D49UWB001.ant.amazon.com (10.43.163.72) To
 EX13d01UWA002.ant.amazon.com (10.43.160.74)
X-Spam-Status: No, score=-12.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 26, 2022 at 11:27:01AM -0700, Samuel Mendoza-Jonas wrote:
> From: Ritesh Harjani <riteshh@linux.ibm.com>
> 
> commit cc16eecae687912238ee6efbff71ad31e2bc414e upstream.
> 
> jbd2_journal_wait_updates() is called with j_state_lock held. But if
> there is a commit in progress, then this transaction might get committed
> and freed via jbd2_journal_commit_transaction() ->
> jbd2_journal_free_transaction(), when we release j_state_lock.
> So check for journal->j_running_transaction everytime we release and
> acquire j_state_lock to avoid use-after-free issue.
> 
> Link: https://lore.kernel.org/r/948c2fed518ae739db6a8f7f83f1d58b504f87d0.1644497105.git.ritesh.list@gmail.com
> Fixes: 4f98186848707f53 ("jbd2: refactor wait logic for transaction updates into a common function")
> Cc: stable@kernel.org
> Reported-and-tested-by: syzbot+afa2ca5171d93e44b348@syzkaller.appspotmail.com
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> [backport to 4.9-4.19 in original jbd2_journal_commit_transaction()
>  location before the refactor in
>  4f9818684870 "jbd2: refactor wait logic for transaction updates into a
>  common function"]
> Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
> Fixes: 1da177e4c3f41524
> Cc: stable@kernel.org # 4.9.x - 4.19.x
> ---
> While marked for 5.17 stable, it looks like this fix also applies to the
> original location in jbd2_journal_commit_transaction() before it was
> refactored to use jbd2_journal_wait_updates(). This applies the same
> change there.

Jan kindly pointed out this was a false alarm:
https://lore.kernel.org/all/20220427111726.3wdyxbqoxs7skdzf@quack3.lan/

So the existing patch is fine and these can be ignored!

Cheers,
Sam

> 
>  fs/jbd2/commit.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 97760cb9bcd7..66e776eb5ea7 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -382,6 +382,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	int csum_size = 0;
>  	LIST_HEAD(io_bufs);
>  	LIST_HEAD(log_bufs);
> +	DEFINE_WAIT(wait);
>  
>  	if (jbd2_journal_has_csum_v2or3(journal))
>  		csum_size = sizeof(struct jbd2_journal_block_tail);
> @@ -434,22 +435,25 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	stats.run.rs_running = jbd2_time_diff(commit_transaction->t_start,
>  					      stats.run.rs_locked);
>  
> -	spin_lock(&commit_transaction->t_handle_lock);
> -	while (atomic_read(&commit_transaction->t_updates)) {
> -		DEFINE_WAIT(wait);
> +	while (1) {
> +		commit_transaction = journal->j_running_transaction;
> +		if (!commit_transaction)
> +			break;
>  
> +		spin_lock(&commit_transaction->t_handle_lock);
>  		prepare_to_wait(&journal->j_wait_updates, &wait,
>  					TASK_UNINTERRUPTIBLE);
> -		if (atomic_read(&commit_transaction->t_updates)) {
> +		if (!atomic_read(&commit_transaction->t_updates)) {
>  			spin_unlock(&commit_transaction->t_handle_lock);
> -			write_unlock(&journal->j_state_lock);
> -			schedule();
> -			write_lock(&journal->j_state_lock);
> -			spin_lock(&commit_transaction->t_handle_lock);
> +			finish_wait(&journal->j_wait_updates, &wait);
> +			break;
>  		}
> +		spin_unlock(&commit_transaction->t_handle_lock);
> +		write_unlock(&journal->j_state_lock);
> +		schedule();
>  		finish_wait(&journal->j_wait_updates, &wait);
> +		write_lock(&journal->j_state_lock);
>  	}
> -	spin_unlock(&commit_transaction->t_handle_lock);
>  
>  	J_ASSERT (atomic_read(&commit_transaction->t_outstanding_credits) <=
>  			journal->j_max_transaction_buffers);
> -- 
> 2.25.1
> 
