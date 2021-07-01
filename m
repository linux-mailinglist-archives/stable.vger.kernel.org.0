Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0A33B95FC
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 20:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhGASOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 14:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232717AbhGASOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 14:14:54 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 028C461285;
        Thu,  1 Jul 2021 18:12:22 +0000 (UTC)
Date:   Thu, 1 Jul 2021 14:12:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paul Burton <paulburton@google.com>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] tracing: Resize tgid_map to pid_max, not
 PID_MAX_DEFAULT
Message-ID: <20210701141221.1d0b1fe0@oasis.local.home>
In-Reply-To: <20210701172407.889626-2-paulburton@google.com>
References: <20210701095525.400839d3@oasis.local.home>
        <20210701172407.889626-1-paulburton@google.com>
        <20210701172407.889626-2-paulburton@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  1 Jul 2021 10:24:07 -0700
Paul Burton <paulburton@google.com> wrote:

> +static int *trace_find_tgid_ptr(int pid)
> +{
> +	// Pairs with the smp_store_release in set_tracer_flag() to ensure that
> +	// if we observe a non-NULL tgid_map then we also observe the correct
> +	// tgid_map_max.

BTW, it's against the Linux kernel coding style to use // for comments.

I can take this patch, but I need to change this to:

	/*
	 * Pairs with the smp_store_release in set_tracer_flag() to ensure that
	 * if we observe a non-NULL tgid_map then we also observe the correct
	 * tgid_map_max.
	 */

Same with the other comments. Please follow coding style that can be
found in:

   Documentation/process/coding-style.rst

And see section 8 on Commenting.

Thanks,

-- Steve


> +	int *map = smp_load_acquire(&tgid_map);
> +
> +	if (unlikely(!map || pid > tgid_map_max))
> +		return NULL;
> +
> +	return &map[pid];
> +}
> +
