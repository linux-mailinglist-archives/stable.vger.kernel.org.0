Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633AC631042
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 19:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiKSSZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 13:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbiKSSZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 13:25:53 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DAC2AE43;
        Sat, 19 Nov 2022 10:25:52 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EF1491F383;
        Sat, 19 Nov 2022 18:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1668882350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hygy7F65S609NQFcqg6vDNh07pkYe/unIVrwGkaPmX4=;
        b=E/JTQKcEyvySP/5ZvZlinvaVsNdHs1wUZOvqj9/DofqDN+1KaT3NkccHONqqtR40XMjr/y
        nPxUstvWsvIERHsTOBFtm/qY5IohnAZNXUNYXi4Gc54mgOcqYdB+GogwBjbuwTljYIHAGd
        /2E7/4NJgXO2rpLFM4YaWzB6KtSIja4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1668882350;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hygy7F65S609NQFcqg6vDNh07pkYe/unIVrwGkaPmX4=;
        b=yPTfHdWj1uogn8KFqbBRDkDMDZ3ZW3hDWUWFzDs5i8Vud5oMV/5b/yRHwTpAlwVkr+rIWZ
        BvnQqfXonn0ps6BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E295A1377F;
        Sat, 19 Nov 2022 18:25:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id u6E8N64feWMyXwAAMHmgww
        (envelope-from <bp@suse.de>); Sat, 19 Nov 2022 18:25:50 +0000
Date:   Sat, 19 Nov 2022 19:25:50 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Peter Gonda <pgonda@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V5] virt: sev: Prevent IV reuse in SNP guest driver
Message-ID: <Y3kfrivSHY8m9ihv@zn.tnic>
References: <20221116175558.2373112-1-pgonda@google.com>
 <3e50c258-8732-088c-d9d8-dfaae82213f0@amd.com>
 <CAMkAt6ppvVUHRCyOjba=_HmYPp_cZaQB1J=HLvFf8yRD1dXPPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMkAt6ppvVUHRCyOjba=_HmYPp_cZaQB1J=HLvFf8yRD1dXPPQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 17, 2022 at 07:19:17AM -0700, Peter Gonda wrote:
> Thanks Tom. I'll update with all the feedback after Boris chimes in.

No need - it looks pretty good to me. I'll queue it next week with Tom's
comments incorporated.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
