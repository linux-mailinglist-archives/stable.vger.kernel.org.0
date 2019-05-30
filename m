Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7662EA1F
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 03:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfE3BOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 21:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbfE3BOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 21:14:19 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9718323BC5;
        Thu, 30 May 2019 01:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559178858;
        bh=QZzDMRd9CB/MrO8s4JZC2FCSZDZQxh3WfwYlPuei1hk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQbN+oorUjzGozrW2QRq9OBw4G7l+E8BCS6r3zIEVsHU4x8bbpDfIwKdncDPLdlhY
         XQpTlMmjiQ9qGwjPg67dRm+j6MHI5DfdpEpjLqUH0Ta1ybMVXib9vGmuq2l9VD2wlb
         R1paZ//0Kw1NpZUMqTaRuEI8jj8hzQPb3VC48L5A=
Date:   Wed, 29 May 2019 18:14:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Jan Luebbe <jlu@pengutronix.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andy Lutomirski <luto@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCHv3] fs/proc: allow reporting eip/esp for all coredumping
 threads
Message-Id: <20190529181418.7d47766ab12b43030a357721@linux-foundation.org>
In-Reply-To: <87pno0u59o.fsf_-_@linutronix.de>
References: <20190522161614.628-1-jlu@pengutronix.de>
        <875zpzif8v.fsf@linutronix.de>
        <20190525143220.e771b7915d17f22dad1438fa@linux-foundation.org>
        <87d0k5f1g7.fsf@linutronix.de>
        <87y32p7i7a.fsf@linutronix.de>
        <87pno0u59o.fsf_-_@linutronix.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

(ooh, Greg, let me do it!)

On Thu, 30 May 2019 02:58:59 +0200 John Ogness <john.ogness@linutronix.de> wrote:

> Commit 0a1eb2d474ed ("fs/proc: Stop reporting eip and esp in
> /proc/PID/stat") stopped reporting eip/esp and commit fd7d56270b52
> ("fs/proc: Report eip/esp in /prod/PID/stat for coredumping")
> reintroduced the feature to fix a regression with userspace core dump
> handlers (such as minicoredumper).
> 
> Because PF_DUMPCORE is only set for the primary thread, this didn't fix
> the original problem for secondary threads. Allow reporting the eip/esp
> for all threads by checking for PF_EXITING as well. This is set for all
> the other threads when they are killed. coredump_wait() waits for all
> the tasks to become inactive before proceeding to invoke a core dumper.
> 
> Fixes: fd7d56270b526ca3 ("fs/proc: Report eip/esp in /prod/PID/stat for coredumping")
> Reported-by: Jan Luebbe <jlu@pengutronix.de>
> Signed-off-by: John Ogness <john.ogness@linutronix.de>
> ---
>  This is a rework of Jan's v1 patch that allows accessing eip/esp of all
>  the threads without risk of the task still executing on a CPU.
> 
>  The code chagnes are the same as v2. With v3 I included a "Fixes" tag,
>  fixed a typo in the commit message, and Cc'd stable.

No, the way to Cc stable is to add

Cc: <stable@vger.kernel.org> to the changelog metadata.

I've made these changes to my copy of this patch, thanks.
