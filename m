Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9317B4B6ABC
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 12:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiBOLZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 06:25:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232446AbiBOLZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 06:25:54 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947F5108555;
        Tue, 15 Feb 2022 03:25:44 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 506DE1F38A;
        Tue, 15 Feb 2022 11:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644924343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=adJSoSE9Bupy5BHYL/QvO31gaCs5ojBBDPdNJcHiJrQ=;
        b=psBJoPYRHChgfX/0VV6wYre7TS/KB2RBXIWyKQ1sKcimR/1GjTEIUyaENcV6wPdipToQPc
        6qv20oZz3tf8w4Kxop1MCTPFLUsNS60ahFLl9hapIfxHnjtvg8ItoEqCzmKqbxFiWW7aMA
        BIl+EnwPLiW5+nC+/yR56sjAkeUDZvg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2F8CF13C40;
        Tue, 15 Feb 2022 11:25:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t1z7CreNC2JGPQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Tue, 15 Feb 2022 11:25:43 +0000
Date:   Tue, 15 Feb 2022 12:25:41 +0100
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Solar Designer <solar@openwall.com>, linux-kernel@vger.kernel.org,
        Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>, stable@vger.kernel.org
Subject: Re: [PATCH 5/8] ucounts: Handle wrapping in is_ucounts_overlimit
Message-ID: <20220215112541.GH21589@blackbody.suse.cz>
References: <87o83e2mbu.fsf@email.froward.int.ebiederm.org>
 <20220211021324.4116773-5-ebiederm@xmission.com>
 <20220212223638.GB29214@openwall.com>
 <87k0dxv5eq.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k0dxv5eq.fsf@email.froward.int.ebiederm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 09:23:09AM -0600, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> Pretty much. The function essentially only exists so that we can
> handle the weirdness of RLIMIT_NPROC.
> Now that I have discovered the
> weirdness of RLIMIT_NPROC is old historical sloppiness I expect the
> proper solution is to rework how RLIMIT_NPROC operates and to remove
> is_ucounts_overlimit all together.

The fork path could make do with some kind of atomic add+check (similar
to inc_ucounts) and overflows would be sanitized by that. (Seems to
apply to other former RLIMIT_* per-user counters too.)

The is_ucounts_overlimit() and overflowable increment indeed appears
necessary only to satisfy the set*uid+execve pair.

For the sake of bug-fixing, both the patches 5/8 and 6/8 can have 
Reviewed-by: Michal Koutný <mkoutny@suse.com>


Michal
