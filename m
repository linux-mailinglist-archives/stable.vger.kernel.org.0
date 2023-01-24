Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552E3679E03
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjAXPyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbjAXPyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:54:12 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F94A4957E;
        Tue, 24 Jan 2023 07:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jNHtzpQOTdp0ytvoR4xoHlOVD5NYR8NiN+8MSchKfiA=; b=Kh84e6zyK6Clb28u7cWaRT1JRt
        g68D2SFELCs2vTV+ysnbfSOO65VPXsE2c1XIlyHlvS2f68w228eLBIerAU3uDdqjNELDH+xHWW+Im
        jMy/WgbaTOCimcm1BNlKuUISEJpNLaQw96ztbjz1baqZHpVsKeX407xyhIsvOfCOR0IAcOmpS3QE7
        GZ/FLmjGTow5VCGlp3bNC5e4enwD147cpeDjRPbpP76fvP//Xrpab003Wd/Nt4D4X1dHGX4MkbyNG
        jjO2t6mMeQeCAYlHmonLyESikxVmMOe1rM391uPX5DCdmYwiKmVb4BFdmQoc+AbP39g5bRNnc71G9
        InS9IlOw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pKLb6-001sgN-26;
        Tue, 24 Jan 2023 15:52:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 082623002BF;
        Tue, 24 Jan 2023 16:52:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DBE412C539557; Tue, 24 Jan 2023 16:52:57 +0100 (CET)
Date:   Tue, 24 Jan 2023 16:52:57 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>,
        paulmck@kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        mingo@redhat.com, will@kernel.org, boqun.feng@gmail.com,
        akpm@osdl.org, tglx@linutronix.de, joel@joelfernandes.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com, linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Message-ID: <Y8/+2YBRD4rFySjh@hirez.programming.kicks-ass.net>
References: <20230120135525.25561-1-hernan.poncedeleon@huaweicloud.com>
 <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
 <d1e28124-b7a7-ae19-87ec-b1dcd3701b61@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1e28124-b7a7-ae19-87ec-b1dcd3701b61@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 10:42:24AM -0500, Waiman Long wrote:

> I would suggest to do it as suggested by PeterZ. Instead of set_bit(),
> however, it is probably better to use atomic_long_or() like
> 
> atomic_long_or_relaxed(RT_MUTEX_HAS_WAITERS, (atomic_long_t *)&lock->owner)

That function doesn't exist, atomic_long_or() is implicitly relaxed for
not returning a value.
