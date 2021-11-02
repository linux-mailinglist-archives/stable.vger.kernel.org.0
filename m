Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2582D443438
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 18:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhKBRDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 13:03:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34434 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhKBRDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 13:03:00 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F12D22191E;
        Tue,  2 Nov 2021 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635872424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnCsQ7BN32L02J/65RauwbZm1QvjnZr+v+hxhCe8MxI=;
        b=LN+ZU9zVSkG+f0o1YeJTC9q80r9sNYe6LxDrXS7XF8DzJ53ODTemD9FbGpNEHMy+hyDNXE
        hdCigzNumqte3Rcc9+thzX+rrlZxhUHNqmkECg5/UMzrWtj7pGm1s+8O7g8aXdyMZf7HDq
        BtYnASAc7IuY5Caj6S3VgneFfyq5XBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635872424;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dnCsQ7BN32L02J/65RauwbZm1QvjnZr+v+hxhCe8MxI=;
        b=ja6aDrNj7Fh4aeiNIcEUe8KPzSQl+xaRPWbSKjWn8xpSUgSP3K6SrDUs+ZMp4zP3RFNhuJ
        g7inhpvxt12rZPCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0963513E74;
        Tue,  2 Nov 2021 17:00:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OXF4AKdugWFDfQAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 02 Nov 2021 17:00:23 +0000
Date:   Tue, 2 Nov 2021 18:00:21 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, kexec@lists.infradead.org, stable@vger.kernel.org,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 01/12] kexec: Allow architecture code to opt-out at
 runtime
Message-ID: <YYFupTJjUljpuZgL@suse.de>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-2-joro@8bytes.org>
 <YYARccITlowHABg1@zn.tnic>
 <87pmrjbmy9.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pmrjbmy9.fsf@disp2133>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi again,

On Mon, Nov 01, 2021 at 04:11:42PM -0500, Eric W. Biederman wrote:
> I seem to remember the consensus when this was reviewed that it was
> unnecessary and there is already support for doing something like
> this at a more fine grained level so we don't need a new kexec hook.

Forgot to state to problem again which these patches solve:

Currently a Linux kernel running as an SEV-ES guest has no way to
successfully kexec into a new kernel. The normal SIPI sequence to reset
the non-boot VCPUs does not work in SEV-ES guests and special code is
needed in Linux to safely hand over the VCPUs from one kernel to the
next. What happens currently is that the kexec'ed kernel will just hang.

The code which implements the VCPU hand-over is also included in this
patch-set, but it requires a certain level of Hypervisor support which
is not available everywhere.

To make it clear to the user that kexec will not work in their
environment, it is best to disable the respected syscalls. This is what
the hook is needed for.

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nürnberg
Germany
 
(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev

