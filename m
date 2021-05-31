Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EF2395833
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 11:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhEaJix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 05:38:53 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40498 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhEaJiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 05:38:50 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EAE752191B;
        Mon, 31 May 2021 09:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622453829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wfuKeKQBwRNhlmIIYywYKWqSPum7bvOeAX1XbngvXSc=;
        b=dRYhpdCHgSNRFkL4tdQz8iWSDEmREm1IeprU4mEnlMlDFuRDJLl+ZWEAfw5Afxd/VDNQv9
        EKvl6KDzrcniS99P8nlt0AolP84CygUwNLTcDbtCdozpK2OZYfvo0VzzQLkz31yIy662Gl
        EX3W5FYajoMfI7AAEpqiKCzJ74kKWw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622453829;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wfuKeKQBwRNhlmIIYywYKWqSPum7bvOeAX1XbngvXSc=;
        b=/A7b72mGthQ0Lqy4EDhiPW/E50LU9fHVcXA+RtPKkvg+3vI+W0W4JIRSNFW09LuSTvvbBT
        ia/FEjChQKbpLGAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 6178E118DD;
        Mon, 31 May 2021 09:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622453829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wfuKeKQBwRNhlmIIYywYKWqSPum7bvOeAX1XbngvXSc=;
        b=dRYhpdCHgSNRFkL4tdQz8iWSDEmREm1IeprU4mEnlMlDFuRDJLl+ZWEAfw5Afxd/VDNQv9
        EKvl6KDzrcniS99P8nlt0AolP84CygUwNLTcDbtCdozpK2OZYfvo0VzzQLkz31yIy662Gl
        EX3W5FYajoMfI7AAEpqiKCzJ74kKWw4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622453829;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wfuKeKQBwRNhlmIIYywYKWqSPum7bvOeAX1XbngvXSc=;
        b=/A7b72mGthQ0Lqy4EDhiPW/E50LU9fHVcXA+RtPKkvg+3vI+W0W4JIRSNFW09LuSTvvbBT
        ia/FEjChQKbpLGAA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id Y7AlFkWutGBeXQAALh3uQQ
        (envelope-from <jroedel@suse.de>); Mon, 31 May 2021 09:37:09 +0000
Date:   Mon, 31 May 2021 11:37:08 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Pu Wen <puwen@hygon.cn>
Cc:     Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        joro@8bytes.org, thomas.lendacky@amd.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@suse.de, hpa@zytor.com,
        sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
Message-ID: <YLSuRBzM6piigP8t@suse.de>
References: <20210526072424.22453-1-puwen@hygon.cn>
 <YK6E5NnmRpYYDMTA@google.com>
 <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
Authentication-Results: imap.suse.de;
        none
X-Spam-Level: 
X-Spam-Score: 0.00
X-Spamd-Result: default: False [0.00 / 100.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         RCPT_COUNT_TWELVE(0.00)[16];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 11:08:32PM +0800, Pu Wen wrote:
> Reading MSR_AMD64_SEV which is not implemented on Hygon Dhyana CPU will cause
> the kernel reboot, and native_read_msr_safe() has no help.

The reason for the reboot is that there is no #GP or #DF handler set up
when this MSR is read, so its propagated to a shutdown event. But there
is an IDT already, so you can set up early and #GP handler to fix the
reboot.

Regards,

	Joerg
