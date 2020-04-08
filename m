Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32FC71A2886
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 20:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730732AbgDHSXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 14:23:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32651 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730728AbgDHSXq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 14:23:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586370225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hqTq2Wy3TNDTzfSsOcRzLQkDhw37DQsS+GCpZMUDZFo=;
        b=KqqxWSRm/A9mchfV5pb+n1BukFUCpLwadMgMu0gwVcwNtW35Lxdd1RATFrANXdQXZfUiLE
        wdX0sO3/QCClCSME7BH638kNKqGWIjbTXzfiGYkq0Lu1f3wTgfkFRYggSCEvP+M40xmAho
        8SWlgHXLH+MwEgHMVpK6zapqW9dZKc0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-XsFltCapNOamuqjPPB_lXg-1; Wed, 08 Apr 2020 14:23:41 -0400
X-MC-Unique: XsFltCapNOamuqjPPB_lXg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9ED88017F4;
        Wed,  8 Apr 2020 18:23:39 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-85.rdu2.redhat.com [10.10.115.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFCA09A253;
        Wed,  8 Apr 2020 18:23:39 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 169B92202B8; Wed,  8 Apr 2020 14:23:39 -0400 (EDT)
Date:   Wed, 8 Apr 2020 14:23:39 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Message-ID: <20200408182339.GC93547@redhat.com>
References: <877dyqkj3h.fsf@nanos.tec.linutronix.de>
 <F2BD5266-A9E5-41C8-AC64-CC33EB401B37@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F2BD5266-A9E5-41C8-AC64-CC33EB401B37@amacapital.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 09:48:02PM -0700, Andy Lutomirski wrote:

[..]
> It would be nifty if the host also told the guest what the guest virtual address was if the host knows it.

It will be good to know and send guest virtual address as well. While
sending SIGBUS to guest user space, information about which access
triggered SIGBUS will be useful.

I thought GUEST_LINEAR_ADDRESS provides guest virtual address if
EPT_VIOLATION_GLA_VALID bit is set. And it seems to work for my
simple test case. But when I try to read intel SDM, section "27.2" VM
exits, EPT violations, I am not so sure.

Somebody who understands this better, can you please help me understand
what exactly GUEST_LINEAR_ADDRESS is supposed to contain during
EPT violation. I assumed it is guest virtual address and added a
patch in my RFC patch series.

https://lore.kernel.org/kvm/20200331194011.24834-3-vgoyal@redhat.com/

But I might have misunderstood it.

Vivek

