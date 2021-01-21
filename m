Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0378E2FF3E2
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 20:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbhAUTKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 14:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbhAUTKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Jan 2021 14:10:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BDCF221E7;
        Thu, 21 Jan 2021 19:09:52 +0000 (UTC)
Date:   Thu, 21 Jan 2021 14:09:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Denis Efremov <efremov@linux.com>
Cc:     Gaurav Kohli <gkohli@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
Message-ID: <20210121140951.2a554a5e@gandalf.local.home>
In-Reply-To: <f06efd7b-c7b5-85c9-1a0e-6bb865111ede@linux.com>
References: <1601976833-24377-1-git-send-email-gkohli@codeaurora.org>
        <f06efd7b-c7b5-85c9-1a0e-6bb865111ede@linux.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 21 Jan 2021 17:30:40 +0300
Denis Efremov <efremov@linux.com> wrote:

> Hi,
> 
> This patch (CVE-2020-27825) was tagged with
> Fixes: b23d7a5f4a07a ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")
> 
> I'm not an expert here but it seems like b23d7a5f4a07a only refactored
> ring_buffer_reset_cpu() by introducing reset_disabled_cpu_buffer() without
> significant changes. Hence, mutex_lock(&buffer->mutex)/mutex_unlock(&buffer->mutex)
> can be backported further than b23d7a5f4a07a~ and to all LTS kernels. Is
> b23d7a5f4a07a the actual cause of the bug?
> 

Ug, that looks to be a mistake. Looking back at the thread about this:

  https://lore.kernel.org/linux-arm-msm/20200915141304.41fa7c30@gandalf.local.home/

That should have been:

Depends-on: b23d7a5f4a07 ("ring-buffer: speed up buffer resets by avoiding synchronize_rcu for each CPU")

-- Steve
