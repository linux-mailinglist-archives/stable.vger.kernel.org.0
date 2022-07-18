Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91D55789BF
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 20:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbiGRSqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 14:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiGRSqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 14:46:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E702E9C9;
        Mon, 18 Jul 2022 11:46:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B8A6A2077E;
        Mon, 18 Jul 2022 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658169994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IEi9Vz+G38C+o5hOJ1yrZT3rdapUJkl0ZlusWRAZA3Y=;
        b=PBmt63953sU4ntvHe/O4lDUWhLNlStCouc89TG1qj4oyRYUikRKLT9nDc7a1FR9noEb7kd
        3KTGn3YIqmNBinlxvIhO86rkmN0SuFmWjOauSSA77poxIzTdIx2s0piwJXjyhF47kGzrf5
        oovfUqBNs8O5RF6X+Gc5L/rog70oYww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658169994;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IEi9Vz+G38C+o5hOJ1yrZT3rdapUJkl0ZlusWRAZA3Y=;
        b=BAT9hQXmWJEFK31Hvu6iX3BQ2einZEoUKLMmV5WZyxpH8E+RKirOwRW2k81ScjCkAkEycG
        xm425/Qt6Q7Q39Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E9C813A37;
        Mon, 18 Jul 2022 18:46:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id h92nJoqq1WIOMAAAMHmgww
        (envelope-from <bp@suse.de>); Mon, 18 Jul 2022 18:46:34 +0000
Date:   Mon, 18 Jul 2022 20:46:34 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Message-ID: <YtWqit2B3UYIWht1@zn.tnic>
References: <20220715194550.793957-1-cascardo@canonical.com>
 <YtVG8VBmFikS6GMn@worktop.programming.kicks-ass.net>
 <YtWKK2ZLib1R7itI@zn.tnic>
 <CAHk-=wiWQOsxqE+tvZi_MjzGaqfG6Xo5AhbYXtiLWcKVVvbycQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wiWQOsxqE+tvZi_MjzGaqfG6Xo5AhbYXtiLWcKVVvbycQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 18, 2022 at 11:34:02AM -0700, Linus Torvalds wrote:
> Why would we have to protect the kernel from EFI?

Yes, we cleared this up on IRC in the meantime.

This was raised as a concern in case we don't trust EFI. But we cannot
not (double negation on purpose) trust EFI because it can do whatever it
likes anyway, "underneath" the OS.

I'm keeping the UNTRAIN_RET-in-C diff in my patches/ folder, though - I
get the feeling we might need it soon for something else.

:-)

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
