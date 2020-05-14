Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A11C1D3D72
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgENT1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:27:46 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56466 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgENT1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 15:27:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y5h6nPrhEzpYCzdipFANUUrKCuB7CVP+YlT+ibTkEPU=;
        b=hH6EIcDOTGXrzmcV/2IaG6pmXmawPa6XrBHrN/nH7uQbg+K9u7f4AQGqhkrD2A1cNoDNfV
        u30FpyCJSjwOyyDEHmmERkyAHzORQDVhAqcK+vTtJQL84TLOjRBvDQ9WV4Km11HUZTBYV4
        tAjy6SSbB8JrPUwSkX5T/+6xXRwCrlc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171--HXsfovRPfaR3hf9MfvoDg-1; Thu, 14 May 2020 15:27:43 -0400
X-MC-Unique: -HXsfovRPfaR3hf9MfvoDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8948107ACCD;
        Thu, 14 May 2020 19:27:41 +0000 (UTC)
Received: from treble (ovpn-117-14.rdu2.redhat.com [10.10.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 15E6C5D9CA;
        Thu, 14 May 2020 19:27:39 +0000 (UTC)
Date:   Thu, 14 May 2020 14:27:38 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 4.19 37/48] x86/entry/64: Fix unwind hints in register
 clearing code
Message-ID: <20200514192738.nolajgjg56of4nat@treble>
References: <20200513094351.100352960@linuxfoundation.org>
 <20200513094401.325580400@linuxfoundation.org>
 <20200513214856.GA27858@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200513214856.GA27858@amd>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 11:48:56PM +0200, Pavel Machek wrote:
> On Wed 2020-05-13 11:45:03, Greg Kroah-Hartman wrote:
> > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > 
> > commit 06a9750edcffa808494d56da939085c35904e618 upstream.
> > 
> > The PUSH_AND_CLEAR_REGS macro zeroes each register immediately after
> > pushing it.  If an NMI or exception hits after a register is cleared,
> > but before the UNWIND_HINT_REGS annotation, the ORC unwinder will
> > wrongly think the previous value of the register was zero.  This can
> > confuse the unwinding process and cause it to exit early.
> > 
> > Because ORC is simpler than DWARF, there are a limited number of unwind
> > annotation states, so it's not possible to add an individual unwind hint
> > after each push/clear combination.  Instead, the register clearing
> > instructions need to be consolidated and moved to after the
> > UNWIND_HINT_REGS annotation.
> 
> This actually makes kernel entry/exit slower, due to poor instruction
> scheduling. And that is a bit of hot path... Is it strictly
> neccessary? Not everyone needs ORC scheduler. Should it be somehow
> optional?

I didn't measure a difference beyond the noise level, did you?

-- 
Josh

