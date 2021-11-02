Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1549244331E
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 17:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbhKBQko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 12:40:44 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:32892 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbhKBQjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 12:39:55 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9297A212C8;
        Tue,  2 Nov 2021 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635871036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7nyVmI1mw9hsrpGGFASoS9zmXwbZwXMt3G3NBwpCKoI=;
        b=oxpUqcVUqOdx58uNgbc5N6ILlWgD3iJ5JPVwc2mdzgH+1mj50dvEB5b+/uhhjl1TRp4gBu
        LqFrZ2K4t2GlUf0LdITJXWcCqKYJmqnEd8YJ6PgxhFZwI0AAMs5q04OFKDqkXCyB+mTm9w
        KVRl2sit9AWi35m02eH2qPy1jDHOqoQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635871036;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7nyVmI1mw9hsrpGGFASoS9zmXwbZwXMt3G3NBwpCKoI=;
        b=ap4V+wyZXiSnHi24Hqmm/NJJvV092FZptqOKrb38V8qzI3Vs9bcV3t1Y6DRPVnoyqcb2wL
        AceBPKZEc9ueKnCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 949F313BB8;
        Tue,  2 Nov 2021 16:37:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id i3BsIjtpgWGhcQAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 02 Nov 2021 16:37:15 +0000
Date:   Tue, 2 Nov 2021 17:37:13 +0100
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
Message-ID: <YYFpOfovSN2Af+ux@suse.de>
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

On Mon, Nov 01, 2021 at 04:11:42PM -0500, Eric W. Biederman wrote:
> I seem to remember the consensus when this was reviewed that it was
> unnecessary and there is already support for doing something like
> this at a more fine grained level so we don't need a new kexec hook.

It was a discussion, no consenus :)

I still think it is better to solve this in generic code for everybody
to re-use than with an hack in the architecture hooks.

More and more platforms which enable confidential computing features
may need this hook in the future.

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
