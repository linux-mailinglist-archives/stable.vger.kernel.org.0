Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386D94D4031
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 05:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239433AbiCJETS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 23:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239431AbiCJETQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 23:19:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90FF57B00;
        Wed,  9 Mar 2022 20:18:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 866AD61820;
        Thu, 10 Mar 2022 04:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72070C340E8;
        Thu, 10 Mar 2022 04:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646885895;
        bh=6iSEJ3wU3FzUZTv0RzpHgZNG0F9nHjVBdsz7P6dvBMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oA40XrOAotQlxjyxfmZX6SWY05dOajakzPs0J6WPXeSEmIxnP48zQfs7IjgUHnSGC
         VnsuFcTcEa7qlci4CQSScUpiNJomY96FDfGDBwwkod5zGwQUNiRdL4KUlrE2F4f+h+
         T4PJImeuf2zRADaazJhmGjz2hnrAHgQCTPgL9yfc=
Date:   Wed, 9 Mar 2022 20:18:14 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: use vcalloc/__vcalloc for very large
 allocations
Message-Id: <20220309201814.241f39d9ed2f6671c636ece4@linux-foundation.org>
In-Reply-To: <20220308105918.615575-4-pbonzini@redhat.com>
References: <20220308105918.615575-1-pbonzini@redhat.com>
        <20220308105918.615575-4-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue,  8 Mar 2022 05:59:18 -0500 Paolo Bonzini <pbonzini@redhat.com> wrote:

> Allocations whose size is related to the memslot size can be arbitrarily
> large.  Do not use kvzalloc/kvcalloc, as those are limited to "not crazy"
> sizes that fit in 32 bits.  Now that it is available, they can use either
> vcalloc or __vcalloc, the latter if accounting is required.
> 
> Cc: stable@vger.kernel.org

Please fully describe the end user visible runtime effects when
proposing a -stable backport.  And when not proposing a -stable
backport, come to that...


