Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD0F4A5D6B
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 14:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238614AbiBAN2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 08:28:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59008 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238612AbiBAN2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 08:28:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96D8161550;
        Tue,  1 Feb 2022 13:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFFAC340EB;
        Tue,  1 Feb 2022 13:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643722112;
        bh=SIqq9crD10sgnkKKMFFcJOxkf1QKasn6QR3NIP9XRHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ICn0cMvLVZK2SakKeULzNMwWIdXdNq/5aKuMcpBGA4X6aJF7QLNnM5KFiK9mIqYY8
         NnLMG0rJOy7M4k6eXEccc5PRP3P91zggBq/nB193GuQWAh65YjUx2AsugxbMeeQ1QO
         p1w0OcLjH6WoSqytzRFUYhIhi4J1tK1GKlzbPqMFGu23dSVhguke6uAl5gF+H9SuIu
         zOmRYRXAwt2wmf62l77l8hENhS/nDS93RCb0y64/PtkZzlrCn/SPvP97haLN+KjYU+
         QTx2TeoBBWSedKJTAMMK85Ykxgh4tlVPtELmBkxj5cFay0k5AlUESIq7zvV+uMpvPz
         MSEIScwOYScew==
Date:   Tue, 1 Feb 2022 14:28:25 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        kernel test robot <oliver.sang@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        0day robot <lkp@intel.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [fs/exec]  80bd5afdd8: xfstests.generic.633.fail
Message-ID: <20220201132825.zgl3fhnmhex5hcaw@wittgenstein>
References: <20220127000724.15106-1-ariadne@dereferenced.org>
 <20220131144352.GE16385@xsang-OptiPlex-9020>
 <20220131150819.iuqlz3rz6q7cheap@wittgenstein>
 <Yff9+tIDAvYM5EO/@casper.infradead.org>
 <20220131153707.oe45h7tuci2cbfuv@wittgenstein>
 <YfgFeWbZPl+gAUYE@casper.infradead.org>
 <20220131161415.wlvtsd4ecehyg3x5@wittgenstein>
 <20220131171344.77iifun5wdilbqdz@wittgenstein>
 <20220131135940.20790cff1747e79dd855aaf4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220131135940.20790cff1747e79dd855aaf4@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 01:59:40PM -0800, Andrew Morton wrote:
> On Mon, 31 Jan 2022 18:13:44 +0100 Christian Brauner <brauner@kernel.org> wrote:
> 
> > > in other words, the changes that you see CMD_ARGS[0] == NULL for
> > > execveat() seem higher than for path-based exec.
> > > 
> > > To counter that we should probably at least update the execveat()
> > > manpage with a recommendation what CMD_ARGS[0] should be set to if it
> > > isn't allowed to be set to NULL anymore. This is why was asking what
> > > argv[0] is supposed to be if the binary doesn't take any arguments.
> > 
> > Sent a fix to our fstests now replacing the argv[0] as NULL with "".
> 
> As we hit this check so quickly, I'm thinking that Ariadne's patch
> "fs/exec: require argv[0] presence in do_execveat_common()" (which
> added the check) isn't something we'll be able to merge into mainline?

Not in the originally envisioned form. But I think Kees patch to make a
argv[0] the empty string when it's NULL has a better chance of
surviving.
