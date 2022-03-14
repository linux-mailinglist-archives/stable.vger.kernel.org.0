Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB04C4D8090
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbiCNLUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiCNLUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:20:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CBD3A183;
        Mon, 14 Mar 2022 04:19:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EF917218FD;
        Mon, 14 Mar 2022 11:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647256782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7f69I2PGb5frPZtdQxRvJIr22WJIzyh/Ui3ZiyFTOaw=;
        b=Z1SXGFctzMw6RcvgIGzJJmcFiyxR38Dcn9C1ppw5lJf5FeQeKFflFm8TmPoGV8cUR+WkbM
        xulZgxS4U20DTfkUDlUOFvp/olP7wx3w8vDEc5aLQup4lxBVAuIIGawryepBYHK3v3zVcr
        iFMXgeNTmUDpFfSP4jB0XoDqMtJ73Rc=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D68E413ADA;
        Mon, 14 Mar 2022 11:19:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rz/nM84kL2KFHwAAMHmgww
        (envelope-from <mkoutny@suse.com>); Mon, 14 Mar 2022 11:19:42 +0000
Date:   Mon, 14 Mar 2022 12:19:41 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Zhang Qiao <zhangqiao22@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhao Gongyi <zhaogongyi@huawei.com>,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH 4.19 01/34] cgroup/cpuset: Fix a race between
 cpuset_attach() and cpu hotplug
Message-ID: <20220314111940.GC1035@blackbody.suse.cz>
References: <20220228172207.090703467@linuxfoundation.org>
 <20220228172208.566431934@linuxfoundation.org>
 <20220308151232.GA21752@blackbody.suse.cz>
 <Yi73dKB10LBTGb+S@kroah.com>
 <aa25447a-f6ff-2ff2-72e9-3bbab1d430e9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa25447a-f6ff-2ff2-72e9-3bbab1d430e9@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

In my opinion there are two approaches:
a) drop this backport (given other races present),
b) swap the locks compatible with v4.19 as this patch proposes.

On Mon, Mar 14, 2022 at 05:11:50PM +0800, Zhang Qiao <zhangqiao22@huawei.com> wrote:
> +       /*
> +        * It should hold cpus lock because a cpu offline event can
> +        * cause set_cpus_allowed_ptr() failed.
> +        */
> +       cpus_read_lock();

Maybe just a nit, the old kernels before commit c5c63b9a6a2e ("cgroup:
Replace deprecated CPU-hotplug functions.") v5.15-rc1~159^2~5
would be more consistent with get_online_cpus() here (but they're
equivalent functionally so the locking order is correct).

Michal
