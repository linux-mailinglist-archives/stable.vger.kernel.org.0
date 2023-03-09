Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A886B18E1
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 02:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCIBqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 20:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCIBqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 20:46:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31D269CFF
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 17:46:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64C55B81E16
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 01:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96788C433D2;
        Thu,  9 Mar 2023 01:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678326370;
        bh=mZUUqDVmjnQcz5ki8ID/5GhTPms3yRpD6egNZ7qELyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uL4ubQEsvjb5ruxhzanTCIFfc+To+PV5PK8wMHyR+H268suW+RQcJ/LptTWdF26Ck
         esfiB9T8BxJlJOB9VhSxF08u7Slygi/DWM25Qh78NPFOh8WcpRmuc1eOxxSO1RdhfT
         S5hKKQp75KI0A4PS+aYDAdLUFWdiBAKxbR1HxE3s=
Date:   Wed, 8 Mar 2023 17:46:08 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     catalin.marinas@arm.com, andreyknvl@gmail.com, linux-mm@kvack.org,
        kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com,
        linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        will@kernel.org, eugenis@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Revert
 "kasan: drop skip_kasan_poison variable in free_pages_prepare"
Message-Id: <20230308174608.e66ed98c97ea29934d99c596@linux-foundation.org>
In-Reply-To: <20230301003545.282859-2-pcc@google.com>
References: <20230301003545.282859-1-pcc@google.com>
        <20230301003545.282859-2-pcc@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Feb 2023 16:35:44 -0800 Peter Collingbourne <pcc@google.com> wrote:

> This reverts commit 487a32ec24be819e747af8c2ab0d5c515508086a.
> 
> The should_skip_kasan_poison() function reads the PG_skip_kasan_poison
> flag from page->flags. However, this line of code in free_pages_prepare():
> 
> page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
> 
> clears most of page->flags, including PG_skip_kasan_poison, before calling
> should_skip_kasan_poison(), which meant that it would never return true
> as a result of the page flag being set. Therefore, fix the code to call
> should_skip_kasan_poison() before clearing the flags, as we were doing
> before the reverted patch.

What are the user visible effects of this change?

> Cc: <stable@vger.kernel.org> # 6.1

Especially if it's cc:stable.

Thanks.
