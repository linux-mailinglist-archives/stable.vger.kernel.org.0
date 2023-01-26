Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDDC67CD91
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 15:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjAZOVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 09:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjAZOVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 09:21:07 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BF4D1;
        Thu, 26 Jan 2023 06:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h9WIGkvTDhG3zM/vS6F1wiaN1m8XxoyTkKz6L+IxEJs=; b=N7ju3JLaKzUIEy/musw0GNi3MD
        os+/+yiWUFGrbfQzr8/U9PrhmqB9KtFvAbiejqDjCt5OuNwqyYVWckIHltD2qyCc/m+n23rP5aIF1
        asgAjCkOUbu0UUuHIl9+u2BD+hN3J5uS/UHacOhZyGKQBovb0TFI7/jsPIV0s+dOBtNv45K+i5tH5
        +kk2Q1L7sTHZtducPRwe7vBSqUGBwt3yN9w/7IZ/nyVw/SLc2mqCntpFWvnnQva1bCgGBFwfquOyn
        Ey+b/EYg16PetxtVgZ4sleZdXNVYBajAV6ehaHHS3riay9wBDwhKvMyfV93Q4voK+Hmcst+Plfjzv
        vTCVUGeg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pL36d-002TRZ-2Y;
        Thu, 26 Jan 2023 14:19:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 63744300137;
        Thu, 26 Jan 2023 15:20:29 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 459DA203C2B1E; Thu, 26 Jan 2023 15:20:29 +0100 (CET)
Date:   Thu, 26 Jan 2023 15:20:29 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Hernan Ponce de Leon <hernan.poncedeleon@huaweicloud.com>
Cc:     Waiman Long <longman@redhat.com>, paulmck@kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, mingo@redhat.com,
        will@kernel.org, boqun.feng@gmail.com, akpm@osdl.org,
        tglx@linutronix.de, joel@joelfernandes.org,
        stern@rowland.harvard.edu, diogo.behrens@huawei.com,
        jonas.oberhauser@huawei.com, linux-kernel@vger.kernel.org,
        Hernan Ponce de Leon <hernanl.leon@huawei.com>,
        stable@vger.kernel.org,
        Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
Subject: Re: [PATCH] Fix data race in mark_rt_mutex_waiters
Message-ID: <Y9KMLfMHxlPkpRRr@hirez.programming.kicks-ass.net>
References: <562c883b-b2c3-3a27-f045-97e7e3281e0b@linux.intel.com>
 <20230120155439.GI2948950@paulmck-ThinkPad-P17-Gen-1>
 <9a1c7959-4b8c-94df-a3e2-e69be72bfd7d@huaweicloud.com>
 <20230123164014.GN2948950@paulmck-ThinkPad-P17-Gen-1>
 <f17dcce0-d510-a112-3127-984e8e73f480@huaweicloud.com>
 <d1e28124-b7a7-ae19-87ec-b1dcd3701b61@redhat.com>
 <Y8/+2YBRD4rFySjh@hirez.programming.kicks-ass.net>
 <ae90e931-df19-9d60-610c-57dc34494d8e@redhat.com>
 <c300747a-cf81-0e2d-77ec-f861421291f9@huaweicloud.com>
 <Y9Jv9yL8x7/TAq/X@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9Jv9yL8x7/TAq/X@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 01:20:07PM +0100, Peter Zijlstra wrote:
> Well, set_bit() implies smp_mb(), atomic_long_or() does not and would
> need to retain the barrier.

set_bit() does not, must've had a brain-fart or so.
