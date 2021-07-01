Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB173B95F2
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 20:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhGASK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 14:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233305AbhGASK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 14:10:27 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A22E6611F1;
        Thu,  1 Jul 2021 18:07:56 +0000 (UTC)
Date:   Thu, 1 Jul 2021 14:07:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paul Burton <paulburton@google.com>
Cc:     Joel Fernandes <joelaf@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
Message-ID: <20210701140754.5847a50f@oasis.local.home>
In-Reply-To: <YN38D3dg0fLzL0Ia@google.com>
References: <20210630003406.4013668-1-paulburton@google.com>
        <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com>
        <YN38D3dg0fLzL0Ia@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Jul 2021 10:31:59 -0700
Paul Burton <paulburton@google.com> wrote:

> I was tempted to just add the redundant checks anyway (pick your battles
> and all) but for show() in particular it wound up making things seem
> non-sensical to me ("display the value describing this non-NULL pointer
> into tgid_map only if tgid_map is not NULL?").

I agree with your assessment, and will actually take your first patch,
as I don't think the comment is that helpful, not to mention, we don't
use '//' comments in the kernel, so that would have to be changed.

But for cases like this, I usually have something like:


	if (WARN_ON_ONCE(!tgid_map))
		return -1;

Because the logic is what makes tgid_map not being NULL, but as
experience has taught me, the logic can sometimes be mistaken, at least
as time goes by. And things that are protected by logic, deserve a
WARN*() when it doesn't go as planned.

We can always add that later, if needed.

-- Steve
